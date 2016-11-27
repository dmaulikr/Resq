//
//  SearchResultsViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/18/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "SearchResultsViewController.h"

@interface SearchResultsViewController ()

@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryTableViewCell" forIndexPath:indexPath];
    NSDictionary* object = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text =[object valueForKeyPath:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* object = [self.searchResults objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate didTapOnProduct:object];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // extract array from observer
    self.searchResults = [(NSArray *)object valueForKey:@"results"];
    [self.tableView reloadData];
}

@end
