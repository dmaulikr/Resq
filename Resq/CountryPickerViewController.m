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


@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UISearchController *controller;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) SearchResultsViewController *searchResultsController;

@end

@implementation CountryPickerViewController

static NSString *cellIdentifier = @"CountryTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchResultsController = (SearchResultsViewController *)self.controller.searchResultsController;
    _searchResultsController.delegate = self;
    [self addObserver:_searchResultsController forKeyPath:@"results" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView registerClass:[CountryTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self initWithObjectsApp];
}


- (UISearchController *)controller {
    if (!_controller) {
        // instantiate search results table view
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchResultsViewController *resultsController = [storyboard instantiateViewControllerWithIdentifier:@"SearchResultsViewController"];
        resultsController.delegate = self;
        _controller = [[UISearchController alloc]initWithSearchResultsController:resultsController];
        _controller.searchResultsUpdater = self;
        _controller.delegate = self;
        [_controller.searchBar setBarTintColor:[UIColor groupTableViewBackgroundColor]];
        [_controller.view setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _controller;
}

-(void)dealloc{
    [self removeObserver:_searchResultsController forKeyPath:@"results"];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sections count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.sections objectAtIndex: section] count];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.sectionTitles indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionTitles objectAtIndex:section] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    id object = [[self.sections objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    cell.savingLabel.text =[object valueForKeyPath:self.keypath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedObject = [[self.sections objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    [self updateSelection:NO];
    self.completion(self.selectedObject);
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.tableView reloadData];
    [self updateSelection:YES];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    [self.searchResults removeAllObjects];
    self.searchResults = [[NSMutableArray alloc]init];
    
    for (NSArray *section in _sections) {
        for (NSDictionary *dict in section){
            NSDictionary * country =(NSDictionary*)dict;
            if(country && [country valueForKey:@"name"] && searchText && [[[country valueForKey:@"name"]lowercaseString] containsString:searchText.lowercaseString]){
                [self.searchResults addObject:dict];
            }
        }
    }
}

-(void)updateSelection:(BOOL)animate{
    NSInteger index = 0;
    int j = 0;
    for(NSArray * objectArray in self.sections){
        index = [objectArray indexOfObject:self.selectedObject];
        if( index != NSNotFound)
            break;
        j++;
    }
    UITableViewScrollPosition  position = animate? UITableViewScrollPositionMiddle:UITableViewScrollPositionNone;
    if (index != NSNotFound && self.keypath)
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:j] animated:YES scrollPosition:position];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.controller.searchBar.text = @"";
    [self presentViewController:self.controller animated:YES completion:nil];
    return NO;
}

# pragma mark - Search Results Updater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSMutableArray * resultsArray = [[NSMutableArray alloc]init];
    for (NSArray *section in _sections) {
        for (NSDictionary *dict in section){
            if([dict isKindOfClass:[NSDictionary class]]){
                NSDictionary * country =(NSDictionary*)dict;
                if(country && [country valueForKey:@"name"] && self.controller.searchBar.text && [[[country valueForKey:@"name"]lowercaseString] containsString:self.controller.searchBar.text.lowercaseString]){
                    [resultsArray addObject:country];
                }
            }
            else{
                NSString * searchStringTemp = dict[self.keypath];
                if(searchStringTemp && self.controller.searchBar.text && [searchStringTemp.lowercaseString containsString:self.controller.searchBar.text.lowercaseString]){
                    [resultsArray addObject:dict];
                }
            }
        }
    }
    self.results = resultsArray;
}

# pragma mark - Search Result Controller Delegate

-(void)didTapOnProduct:(NSDictionary *)result{
    [self dismissViewControllerAnimated:YES completion:^{
        self.completion(result);
    }];
}


@end
