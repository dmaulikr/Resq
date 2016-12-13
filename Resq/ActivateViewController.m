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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appdelegate checkForTermsOfUseAndPrivacyPolicy:self];
    [self updateView];

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
