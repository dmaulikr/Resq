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
    self.title = @"Activate";
    
    [[UserManager sharedManager]startAdvertising];
    [[_activate_btn layer]setCornerRadius:CGRectGetHeight(_activate_btn.frame)/2];
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

- (UIImage *)stretchableButtonImageWithColor:(UIColor *)color cornerRadius:(int)cornerRadius{
    CGSize size = CGSizeMake(11, 11);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [color set];
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius] fill];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [ret resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

- (IBAction)activateButtonAction:(id)sender {
    if(![[UserManager sharedManager]isActivated]){
        [[ResqLocationManager sharedManager]startUpdatingLocation];
        UIImage* bg_image = [self stretchableButtonImageWithColor:[UIColor greenColor] cornerRadius:CGRectGetHeight(_activate_btn.frame)/2];
        [_activate_btn setBackgroundImage:bg_image forState:UIControlStateNormal];
        self.activate_btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.activate_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_activate_btn setTitle:@"Active\nPress to deactivate" forState:UIControlStateNormal];
        [[UserManager sharedManager]setIsActivated:YES];
        [[UserManager sharedManager]setup];
    }else{
        [[ResqLocationManager sharedManager]stopUpdatingLocation];
        UIImage* bg_image = [self stretchableButtonImageWithColor:[UIColor grayColor] cornerRadius:CGRectGetHeight(_activate_btn.frame)/2];
        [_activate_btn setBackgroundImage:bg_image forState:UIControlStateNormal];
        [_activate_btn setTitle:@"Activate" forState:UIControlStateNormal];
        [[UserManager sharedManager]setIsActivated:NO];
        if([[UserManager sharedManager] alertTimer]){
            [[[UserManager sharedManager] alertTimer] invalidate];
        }
    }
    //    [[UserManager sharedManager]setTimeRemaining:0];
}

-(void)updateView{
    if([[UserManager sharedManager]isActivated]){
        UIImage* bg_image = [self stretchableButtonImageWithColor:[UIColor greenColor] cornerRadius:CGRectGetHeight(_activate_btn.frame)/2];
        [_activate_btn setBackgroundImage:bg_image forState:UIControlStateNormal];
        self.activate_btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.activate_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_activate_btn setTitle:@"Active\nPress to deactivate" forState:UIControlStateNormal];
    }else{
        UIImage* bg_image = [self stretchableButtonImageWithColor:[UIColor grayColor] cornerRadius:CGRectGetHeight(_activate_btn.frame)/2];
        [_activate_btn setBackgroundImage:bg_image forState:UIControlStateNormal];
        [_activate_btn setTitle:@"Activate" forState:UIControlStateNormal];
    }
}

@end
