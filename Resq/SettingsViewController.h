//
//  SettingsViewController.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResqViewController.h"
@import Firebase;

@interface SettingsViewController : ResqViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (nonatomic, retain) UISlider *notificationTimeSlider;
@property (nonatomic, retain) UILabel *notificationTimeLabel;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic, retain) NSMutableArray* contactsArray;

@end
