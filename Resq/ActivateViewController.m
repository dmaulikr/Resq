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

@property (assign) BOOL isActivated;
@end

@implementation ActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Activate";
    [[_activate_btn layer]setCornerRadius:CGRectGetHeight(_activate_btn.frame)/2];
    _isActivated = NO;
    [self activateButtonAction:nil];
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
    if(_isActivated){
        [[ResqLocationManager sharedManager]startUpdatingLocation];
        UIImage* bg_image = [self stretchableButtonImageWithColor:[UIColor redColor] cornerRadius:CGRectGetHeight(_activate_btn.frame)/2];
        [_activate_btn setBackgroundImage:bg_image forState:UIControlStateNormal];
        [_activate_btn setTitle:@"Deactivate" forState:UIControlStateNormal];
        _isActivated = NO;
        
    }else{
        [[ResqLocationManager sharedManager]stopUpdatingLocation];
        UIImage* bg_image = [self stretchableButtonImageWithColor:[UIColor colorWithRed:13.0/255.0 green:187.0/255.0 blue:15.0/255.0 alpha:1.0] cornerRadius:CGRectGetHeight(_activate_btn.frame)/2];
        [_activate_btn setBackgroundImage:bg_image forState:UIControlStateNormal];
        [_activate_btn setTitle:@"Activate" forState:UIControlStateNormal];
        _isActivated = YES;
    }
}
@end
