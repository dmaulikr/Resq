//
//  CountryPickerViewController.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryPickerViewController : UIViewController

@property (nonatomic, strong) id selectedObject;
@property (nonatomic, strong) NSString *keypath;
@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void(^completion)(id selectedObject);


@end
