//
//  SettingsViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "SettingsViewController.h"
#import "PhoneNumberViewController.h"
#import "BluetoothViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <ContactsUI/ContactsUI.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CBCentralManager+Blocks.h"

@interface SettingsViewController ()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    [self.settingsTableView setTableFooterView:[[UIView alloc]init]];
    _contactsArray = [[NSMutableArray alloc] init];
    _frequentContactsArray = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"] && [[[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"] length]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UserManager sharedManager]startAdvertising];
            CBUUID *demoServiceUUID = [CBUUID UUIDWithString:@"7846ED88-7CD9-495F-AC2A-D34D245C9FB6"];
            [[CBCentralManager defaultManager] scanForPeripheralsWithServices:@[demoServiceUUID] options:nil didDiscover:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
            }];
            
        });
        [self updateList];
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
    //    [[UserManager sharedManager]sendMessage:@""];
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
            return _frequentContactsArray.count;
            break;
        }case ResqSettingCellTypeNotificationTimeCell:{
            return 1;
            break;
        }case ResqSettingCellTypeBuddyListHeaderCell:{
            return 1;
            break;
        }case ResqSettingCellTypeBuddyCell:{
            return _contactsArray.count;
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
            
            Contacts * contact = [_frequentContactsArray objectAtIndex:indexPath.row];
            [buddyName setText:contact.name];
            
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
            Contacts * contact = [_contactsArray objectAtIndex:indexPath.row];
            
            [removeBuddy addTarget:self action:@selector(removeBuddyAction:) forControlEvents:UIControlEventTouchUpInside];
            [buddyName setText:contact.name];
            
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
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(indexPath.section == ResqSettingCellTypeCloseByCell){
            BluetoothViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothViewController"];
            UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:controller];
            navController.navigationBar.translucent = NO;
            [self presentViewController:navController animated:YES completion:nil];
        }if(indexPath.section == ResqSettingCellTypeContactsSettingCell){
            ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    ABPeoplePickerNavigationController*  _addressBookController = [[ABPeoplePickerNavigationController alloc] init];
                    [[_addressBookController navigationBar] setBarStyle:UIBarStyleBlack];
                    
                    //                _addressBookController.delegate =  self;
                    [_addressBookController setPredicateForEnablingPerson:[NSPredicate predicateWithFormat:@"%K.@count > 0", ABPersonPhoneNumbersProperty]];
                    [_addressBookController setPeoplePickerDelegate:self];
                    [self presentViewController:_addressBookController animated:YES completion:nil];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ALERT_VIEW(@"RESQ", @"PLEASE_GRANT_CONTACTS")
                    });
                }
            });
        }
    });
}

-(void)clearbuddyAction:(id)sender{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"RESQ"
                                 message:[NSString stringWithFormat:@"Are You Sure you want to remove all Buddies?"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    for (Contacts *contact in _contactsArray) {
                                        contact.isBuddy = @(NO);
                                    }
                                    NSError* error;
                                    [appdelegate.managedObjectContext save:&error];
                                    if(error){
                                        NSLog(@"Some thing is Wrong");
                                    }else{
                                        [self updateList];
                                    }                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)removeBuddyAction:(id)sender{
    NSLog(@"Remove Buddy Action");
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.settingsTableView];
    NSIndexPath *indexPath = [self.settingsTableView indexPathForRowAtPoint:buttonPosition];
    Contacts * contact = [_contactsArray objectAtIndex:indexPath.row];
    
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"RESQ"
                                 message:[NSString stringWithFormat:@"Are You Sure you want to remove %@ from your buddy List?",contact.name]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    NSManagedObjectContext *context = appdelegate.managedObjectContext;
                                    contact.isBuddy = @(NO);
                                    NSError *saveError = nil;
                                    [context save:&saveError];
                                    [self updateList];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addBuddyAction:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.settingsTableView];
    NSIndexPath *indexPath = [self.settingsTableView indexPathForRowAtPoint:buttonPosition];
    Contacts * contact = [_frequentContactsArray objectAtIndex:indexPath.row];
    
    NSLog(@"Add Buddy Action");
    NSManagedObjectContext *context = appdelegate.managedObjectContext;
    contact.isBuddy = @(YES);
    contact.frequentCount = @([contact.frequentCount integerValue]+ 1);
    NSError *saveError = nil;
    [context save:&saveError];
    [self updateList];
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
    [[UserManager sharedManager]setup];
    
}

-(void)closeBySwitchAction:(id)sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"Close By: %@", onoff.on ? @"On" : @"Off");
    [[NSUserDefaults standardUserDefaults]setBool:onoff.on forKey:@"closeBySwitch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)contactsSwitchAction:(id)sender {
    UISwitch *onoff = (UISwitch *) sender;
    NSLog(@"Contacts: %@", onoff.on ? @"On" : @"Off");
    [[NSUserDefaults standardUserDefaults]setBool:onoff.on forKey:@"contactsSwitch"];
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

#pragma mark - AddressBook Delegate Methods

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    // Compose the full name.
    NSString *fullName = @"";
    // Before adding the first and the last name in the fullName string make sure that these values are filled in.
    if (firstName != nil) {
        fullName = [fullName stringByAppendingString:firstName];
    }
    if (lastName != nil) {
        fullName = [fullName stringByAppendingString:@" "];
        fullName = [fullName stringByAppendingString:lastName];
    }
    if (property == kABPersonPhoneProperty) {
        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
            if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                CFRelease(multiPhones);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                NSLog(@"Name: %@",fullName);
                NSLog(@"Phone Number: %@",phoneNumber);
                [self addBuddyinList:phoneNumber name:fullName];
                CFRelease(phoneNumberRef);
            }
        }
    }else{
        ALERT_VIEW(@"RESQ", @"Please select Phone number.")
    }
}

-(void)addBuddyinList:(NSString*)mobileNumber name:(NSString*)name{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSString *predicateString = [NSString stringWithFormat:@"phoneNumber = '%@' ", mobileNumber];//OR contact_id = '123'
    Contacts *userobject = (Contacts *)[[UserManager sharedManager]getObject:@"Contacts" predicate:predicateString];
    NSInteger count = 1;
    if(!userobject){
        NSEntityDescription* entityDesc=[NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:appdelegate.managedObjectContext];
        userobject = (Contacts *) [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:appdelegate.managedObjectContext];
        count = 1 + [userobject.frequentCount integerValue];
    }
    
    userobject.contact_id = @"123";
    userobject.deviceToken = @"";
    userobject.frequentCount = @(count);
    userobject.isBuddy = @(YES);
    userobject.name = name;
    userobject.phoneNumber = mobileNumber;
    
    NSError* error;
    [appdelegate.managedObjectContext save:&error];
    if(error){
        NSLog(@"Some thing is Wrong");
    }else{
        [self updateList];
    }
}

-(void)updateList{
    NSString *predicateString = [NSString stringWithFormat:@"isBuddy = '%@' ", @(YES)];
    _contactsArray = (NSMutableArray*)[[UserManager sharedManager]getAllContacts:@"Contacts" predicate:predicateString isFrequent:NO];
    
    predicateString = [NSString stringWithFormat:@"isBuddy = '%@' ", @(NO)];
    _frequentContactsArray = (NSMutableArray*)[[UserManager sharedManager]getAllContacts:@"Contacts" predicate:predicateString isFrequent:YES];
    [self.settingsTableView reloadData];
}

@end
