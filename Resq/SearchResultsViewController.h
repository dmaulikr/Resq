//
//  SearchResultsViewController.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/18/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultsViewControllerDelegate <NSObject>

-(void)didTapOnProduct:(NSDictionary*)result;

@end

@interface SearchResultsViewController : UITableViewController

@property (nonatomic, weak) id<SearchResultsViewControllerDelegate> delegate;

@end
