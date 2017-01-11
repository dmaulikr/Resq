//
//  ActivateViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "ActivateViewController.h"
#import "PhoneNumberViewController.h"

@interface ActivateViewController ()

@end

@implementation ActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView) name:ResetActivateModeView object:nil];
    
    [[UserManager sharedManager] startAdvertising];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:didUpdateLocationNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         
         _latitude_label.text = [NSString stringWithFormat:@"%f",[ResqLocationManager sharedManager].currentLocation.coordinate.latitude];
         _longitude_label.text = [NSString stringWithFormat:@"%f",[ResqLocationManager sharedManager].currentLocation.coordinate.longitude];
         
         NSString * accuracyValue = [NSString stringWithFormat:@"%.0f",[ResqLocationManager sharedManager].currentLocation.horizontalAccuracy];
         NSString * accuracyString = [NSString stringWithFormat:@"%@m\nAccuracy",accuracyValue];
         NSMutableDictionary *accuracyAttributes = [[NSMutableDictionary alloc]initWithDictionary:
                                                    @{
                                                      NSForegroundColorAttributeName: [UIColor blackColor],
                                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:48.0],
                                                      }];
         NSMutableAttributedString *accuracyattributedText = [[NSMutableAttributedString alloc] initWithString:accuracyString];
         NSRange accuracyRange = [accuracyString rangeOfString:accuracyValue];
         [accuracyattributedText setAttributes:accuracyAttributes range:accuracyRange];
         _accuracy_label.attributedText = accuracyattributedText;
         
     }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appdelegate checkForTermsOfUseAndPrivacyPolicy:self];
    [self updateView];
    _latitude_label.text = [NSString stringWithFormat:@"%f",[ResqLocationManager sharedManager].currentLocation.coordinate.latitude];
    _longitude_label.text = [NSString stringWithFormat:@"%f",[ResqLocationManager sharedManager].currentLocation.coordinate.longitude];
    
}

-(void)menuAction:(id)sender{
    [appdelegate.viewDeckController openLeftViewAnimated:YES];
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

- (IBAction)onActivateBtnClick:(UIButton *)sender {
    if(![self checkActivationStatus]){
        ALERT_VIEW(@"Snow Rescue", @"your free trial is over, please purchase...")
        return;
    }
    sender.selected = !sender.selected;
    
    if(![[UserManager sharedManager] isActivated]){
        [[ResqLocationManager sharedManager] startUpdatingLocation];
        [[UserManager sharedManager] setIsActivated:YES];
        [[UserManager sharedManager] setup];
    }
    else{
        [[ResqLocationManager sharedManager] stopUpdatingLocation];
        
        [[UserManager sharedManager] setIsActivated:NO];
        if([[UserManager sharedManager] alertTimer]){
            [[[UserManager sharedManager] alertTimer] invalidate];
        }
        if([[UserManager sharedManager] alertDif30]){
            [[[UserManager sharedManager] alertDif30] invalidate];
        }
        if([[UserManager sharedManager] alertDif20]){
            [[[UserManager sharedManager] alertDif20] invalidate];
        }
        if([[UserManager sharedManager] alertDif10]){
            [[[UserManager sharedManager] alertDif10] invalidate];
        }
    }
}

-(void)updateView{
    if([[UserManager sharedManager] isActivated]){
        self.activate_btn.selected = YES;
    }
    else{
        self.activate_btn.selected = NO;
    }
}


-(BOOL)checkActivationStatus{
    NSInteger numberOfDays = [[UserManager sharedManager]subscriptionNumberOfDaysLeft];
    if([[MKStoreKit sharedKit] isProductPurchased:SEASONPASS_IN_APP]) {
        NSDate * date = [[MKStoreKit sharedKit] expiryDateForProduct:SEASONPASS_IN_APP];
        if([[MKStoreKit sharedKit] expiryDateForProduct:SEASONPASS_IN_APP]) {
            NSLog(@"Date after  \t%@",date);
            NSLog(@"Days to be added :   %ld",[[UserManager sharedManager]seasonPassNumberOfDaysInWithExpiryDate:date]);
        }else{
            NSLog(@"NO");
        }
        numberOfDays += [[UserManager sharedManager]seasonPassNumberOfDaysInWithExpiryDate:date];
    }
    if([[MKStoreKit sharedKit] isProductPurchased:RIPPER_IN_APP]) {
        NSDate * date = [[MKStoreKit sharedKit] expiryDateForProduct:RIPPER_IN_APP];
        if([[MKStoreKit sharedKit] expiryDateForProduct:RIPPER_IN_APP]) {
            NSLog(@"Date after  \t%@",date);
            NSLog(@"Days to be added :   %ld",[[UserManager sharedManager]seasonPassNumberOfDaysInWithExpiryDate:date]);
        }else{
            NSLog(@"NO");
        }
        numberOfDays += [[UserManager sharedManager]seasonPassNumberOfDaysInWithExpiryDate:date];
    }
    BOOL isActive = NO;
    if([[NSUserDefaults standardUserDefaults]freeTrial]){
        isActive = YES;
    } else if(numberOfDays <= 0){
        isActive = NO;
    } else if(numberOfDays > 0){
        isActive = YES;
    }
    return isActive;
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:ResetActivateModeView];
}
@end
