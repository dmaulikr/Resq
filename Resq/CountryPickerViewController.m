//
//  CountryPickerViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "CountryPickerViewController.h"
#import "CountryTableViewCell.h"
@interface CountryPickerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * sections;
@property (nonatomic, retain) NSMutableArray * sectionTitles;
@property (nonatomic, retain) NSMutableArray * searchResults;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayControllers;

@end

@implementation CountryPickerViewController

static NSString *cellIdentifier = @"CountryTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CountryTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    
    
    // Do any additional setup after loading the view.
    
    
    
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initWithObjectsApp];
}

-(IBAction) doneButtonAction:(id)sender{
    self.completion(self.selectedObject);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayControllers.searchResultsTableView) {
        return 1;
    }
    return [self.sections count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayControllers.searchResultsTableView) {
        return [self.searchResults count];
    }
    return [[self.sections objectAtIndex: section] count];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayControllers.searchResultsTableView) {
        return nil;
    }
    return self.sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.sectionTitles indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    if (aTableView == self.searchDisplayControllers.searchResultsTableView)
        return nil;    
    return [self.sectionTitles objectAtIndex:section] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    id object;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        object = [self.searchResults objectAtIndex:indexPath.row];
        //        cell.savingLabel.text =[object valueForKeyPath:self.keypath];
        cell.textLabel.text =[object valueForKeyPath:self.keypath];
    } else{
        object= [[self.sections objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
        cell.savingLabel.text =[object valueForKeyPath:self.keypath];
    }
    //[cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //self.selectedObject = self.objects[indexPath.row];
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        self.selectedObject = [self.searchResults objectAtIndex:indexPath.row];
        [self.searchDisplayController setActive:NO animated:YES];
        [self updateSelection:YES];
    } else{
        self.selectedObject= [[self.sections objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
        [self.searchDisplayController setActive:NO animated:YES];
        [self updateSelection:NO];
        
    }
}


#pragma mark - Table view data source

-(void)initWithObjectsApp{
    self.sections = [NSMutableArray array];
    self.sectionTitles = [NSMutableArray array];
    for (NSDictionary * object in self.objects) {
        NSMutableArray * section = [self.sections lastObject];
        
        if (!section || ![[[[section lastObject] valueForKey:self.keypath] substringToIndex: 1] isEqualToString: [[object valueForKey:self.keypath ] substringToIndex: 1]]) {
            // Create a new section on change of first character
            [self.sections addObject: [NSMutableArray array]];
            [self.sectionTitles addObject: [[object valueForKey:self.keypath ] substringToIndex: 1]];
        }
        [[self.sections lastObject] addObject: object];
    }
    
    //    NSInteger index=0;
    //    int j=0;
    //    for(NSArray * objectArray in self.sections){
    //        index = [objectArray indexOfObject:self.selectedObject];
    //       if( index != NSNotFound)
    //           break;
    //        j++;
    //    }
    [self.tableView reloadData];
    
    //    if (index != NSNotFound && self.keypath)
    //        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:j] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [self updateSelection:YES];
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    //    self.searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
    
    [self.searchResults removeAllObjects];
    self.searchResults = [[NSMutableArray alloc]init];
    
    for (NSArray *section in _sections) {
        for (NSDictionary *dict in section)
        {
            NSDictionary * country =(NSDictionary*)dict;
            
            
            if(country && [country valueForKey:@"name"] && searchText && [[[country valueForKey:@"name"]lowercaseString] containsString:searchText.lowercaseString]){
                [self.searchResults addObject:dict];
            }
            
            //            NSComparisonResult result = [dict[self.keypath] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            //            if (result == NSOrderedSame)
            //            {
            //                [self.searchResults addObject:dict];
            //            }
            
        }
    }
    
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchResults removeAllObjects];
    self.searchResults = [[NSMutableArray alloc]init];
    
    for (NSArray *section in _sections) {
        for (NSDictionary *dict in section)
        {
            if([dict isKindOfClass:[NSDictionary class]]){
                
                NSDictionary * country =(NSDictionary*)dict;
                
                if(country && [country valueForKey:@"name"] && searchString && [[[country valueForKey:@"name"]lowercaseString] containsString:searchString.lowercaseString]){
                    [self.searchResults addObject:country];
                }
                
                //                NSComparisonResult result = [country.name compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
                //                if (result == NSOrderedSame)
                //                {
                //                    [self.searchResults addObject:country];
                //                }
            }
            else{
                
                NSString * searchStringTemp = dict[self.keypath];
                
                if(searchStringTemp && searchString && [searchStringTemp.lowercaseString containsString:searchString.lowercaseString]){
                    [self.searchResults addObject:dict];
                }
                //                NSComparisonResult result = [searchStringTemp compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
                //                if (result == NSOrderedSame)
                //                {
                //                    [self.searchResults addObject:dict];
                //                }
            }
            
        }
    }
    return YES;
}

-(void)updateSelection:(BOOL)animate{
    NSInteger index=0;
    int j=0;
    for(NSArray * objectArray in self.sections){
        index = [objectArray indexOfObject:self.selectedObject];
        if( index != NSNotFound)
            break;
        j++;
    }
    //[self.tableView reloadData];
    UITableViewScrollPosition  position = animate? UITableViewScrollPositionMiddle:UITableViewScrollPositionNone;
    if (index != NSNotFound && self.keypath)
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:j] animated:YES scrollPosition:position];
}

@end
