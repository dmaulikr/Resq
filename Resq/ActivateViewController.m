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
    
    [[UserManager sharedManager] startAdvertising];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:didUpdateLocationNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         
         _latitude_label.text = [NSString stringWithFormat:@"%f",[ResqLocationManager sharedManager].currentLocation.coordinate.latitude];
         _longitude_label.text = [NSString stringWithFormat:@"%f",[ResqLocationManager sharedManager].currentLocation.coordinate.longitude];
         NSLog(@"%f",[ResqLocationManager sharedManager].currentLocation.horizontalAccuracy);
         
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

@end
