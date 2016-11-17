//
//  SettingsViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "SettingsViewController.h"
#import "PhoneNumberViewController.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    [self.settingsTableView setTableFooterView:[[UIView alloc]init]];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"] && [[[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"] length]){
        NSLog(@"Name %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"name"]);
        NSLog(@"Phone %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"]);
    }else{
        PhoneNumberViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneNumberViewController"];
        UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:controller];
        navController.navigationBar.translucent = NO;
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)menuAction:(id)sender{
    [appdelegate.viewDeckController openLeftViewAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ResqSettingCellType cellType = section;
    switch (cellType) {
        case ResqSettingCellTypeCloseByCell:{
            return 1;
            break;
        }case ResqSettingCellTypeContactsSettingCell:{
            return 1;
            break;
        }case ResqSettingCellTypeFrequentContactHeaderCEL:{
            return 1;
            break;
        }case ResqSettingCellTypeFrequentBuddyCell:{
            return 3;
            break;
        }case ResqSettingCellTypeNotificationTimeCell:{
            return 1;
            break;
        }case ResqSettingCellTypeBuddyListHeaderCell:{
            return 1;
            break;
        }case ResqSettingCellTypeBuddyCell:{
            return 5;
            break;
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"";
    ResqSettingCellType cellType = indexPath.section;
    switch (cellType) {
        case ResqSettingCellTypeCloseByCell:{
            cellIdentifier = CLOSE_BY_CELL;
            break;
        }case ResqSettingCellTypeContactsSettingCell:{
            cellIdentifier = CONTACTS_SETTING_CELL;
            break;
        }case ResqSettingCellTypeFrequentContactHeaderCEL:{
            cellIdentifier = FREQUENT_CONTACTS_HEADER_CELL;
            break;
        }case ResqSettingCellTypeFrequentBuddyCell:{
            cellIdentifier = FREQUENT_BUDDY_CELL;
            break;
        }case ResqSettingCellTypeNotificationTimeCell:{
            cellIdentifier = NOTIFICATION_TIME_CELL;
            break;
        }case ResqSettingCellTypeBuddyListHeaderCell:{
            cellIdentifier = BUDDY_LIST_HEADER_CELL;
            break;
        }case ResqSettingCellTypeBuddyCell:{
            cellIdentifier = BUDDY_CELL;
            break;
        }
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    switch (cellType) {
        case ResqSettingCellTypeCloseByCell:{
            UISwitch * onoff = [cell viewWithTag:1];
            [onoff addTarget: self action: @selector(closeBySwitchAction:) forControlEvents:UIControlEventValueChanged];
            BOOL closeBySwitch = [[NSUserDefaults standardUserDefaults]boolForKey:@"closeBySwitch"];
            onoff.on = closeBySwitch;
            break;
        }case ResqSettingCellTypeContactsSettingCell:{
            UISwitch * onoff = [cell viewWithTag:1];
            [onoff addTarget: self action: @selector(contactsSwitchAction:) forControlEvents:UIControlEventValueChanged];
            BOOL contactsSwitch = [[NSUserDefaults standardUserDefaults]boolForKey:@"contactsSwitch"];
            onoff.on = contactsSwitch;
            break;
        }case ResqSettingCellTypeFrequentContactHeaderCEL:{
            cellIdentifier = FREQUENT_CONTACTS_HEADER_CELL;
            break;
        }case ResqSettingCellTypeFrequentBuddyCell:{
            UILabel * buddyName = [cell viewWithTag:1];
            UIButton * addBuddy = [cell viewWithTag:2];
            [addBuddy addTarget:self action:@selector(addBuddyAction:) forControlEvents:UIControlEventTouchUpInside];
            [buddyName setText:@"Shaikh Ahsan"];
            break;
        }case ResqSettingCellTypeNotificationTimeCell:{
            UISlider * slider = [cell viewWithTag:1];
            slider.minimumValue = 30.0;
            slider.maximumValue = 300.0;
            slider.continuous = YES;
            UILabel * notificationTime = [cell viewWithTag:2];
            BOOL isupdated = _notificationTimeLabel?YES:NO;
            _notificationTimeLabel = notificationTime;
            [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
            if(!isupdated){
                slider.value = [[NSUserDefaults standardUserDefaults]floatForKey:@"notificationTime"];
                [self sliderAction:slider];
            }
            
            break;
        }case ResqSettingCellTypeBuddyListHeaderCell:{
            UIButton * clearbuddyList = [cell viewWithTag:1];
            [clearbuddyList addTarget:self action:@selector(clearbuddyAction:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        }case ResqSettingCellTypeBuddyCell:{
            UILabel * buddyName = [cell viewWithTag:1];
            UIButton * removeBuddy = [cell viewWithTag:2];
            [removeBuddy addTarget:self action:@selector(removeBuddyAction:) forControlEvents:UIControlEventTouchUpInside];
            [buddyName setText:@"Muhammad Ahsan"];
            break;
        }
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResqSettingCellType cellType = indexPath.section;
    switch (cellType) {
        case ResqSettingCellTypeCloseByCell:{
            return 95.0;
            break;
        }case ResqSettingCellTypeContactsSettingCell:{
            return 73.0;
            break;
        }case ResqSettingCellTypeFrequentContactHeaderCEL:{
            return 53.0;
            break;
        }case ResqSettingCellTypeFrequentBuddyCell:{
            return 44.0;
            break;
        }case ResqSettingCellTypeNotificationTimeCell:{
            return 104.0;
            break;
        }case ResqSettingCellTypeBuddyListHeaderCell:{
            return 53.0;
            break;
        }case ResqSettingCellTypeBuddyCell:{
            return 44.0;
            break;
        }
        default:
            break;
    }
    return 0.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)clearbuddyAction:(id)sender{
    NSLog(@"Clear Action");
}

-(void)removeBuddyAction:(id)sender{
    NSLog(@"Remove Buddy Action");
}

-(void)addBuddyAction:(id)sender{
    NSLog(@"Add Buddy Action");
}

-(void)sliderAction:(id)sender{
    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    int valueInt = value;
    int min = valueInt/60;
    NSString* timeString = @"";
    if(min){
        timeString = [NSString stringWithFormat:@"%d %@", min ,min > 1 ? @"min" : @"min"];
    }
    int sec = valueInt%60;
    if(sec){
        timeString = [NSString stringWithFormat:@"%@ %d %@",timeString,sec,sec>1?@"sec" : @"sec"];
    }
    [_notificationTimeLabel setText:timeString];
    [[NSUserDefaults standardUserDefaults]setFloat:value forKey:@"notificationTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)closeBySwitchAction:(id)sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"Close By: %@", onoff.on ? @"On" : @"Off");
    [[NSUserDefaults standardUserDefaults]setBool:onoff forKey:@"closeBySwitch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)contactsSwitchAction:(id)sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"Contacts: %@", onoff.on ? @"On" : @"Off");
    [[NSUserDefaults standardUserDefaults]setBool:onoff forKey:@"contactsSwitch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (nullable IIViewDeckController *)viewDeckControllers {
    __kindof UIViewController *parent = self;
    while (parent) {
        if ([parent isKindOfClass:[IIViewDeckController class]]) {
            return parent;
        }
        parent = parent.parentViewController;
    }
    return nil;
}
@end
