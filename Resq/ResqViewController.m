//
//  ResqViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "ResqViewController.h"
#import "AppDelegate.h"

@interface ResqViewController ()

@end

@implementation ResqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"menu-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStyleDone target:self action:@selector(menuAction:)];
    [_leftItem setShouldGroupAccessibilityChildren:YES];
    _rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction:)];
    
    UIFont *navBarTitleFont = [UIFont systemFontOfSize:13.0];
    [_rightItem setTitleTextAttributes:@{
                                         NSFontAttributeName : navBarTitleFont,
                                         } forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:_rightItem animated:YES];
    [self.navigationItem setLeftBarButtonItem:_leftItem animated:YES];
}

- (void)menuAction:(id)sender {
    [appdelegate.sideMenuViewController presentLeftMenuViewController];
}

- (void)rightItemAction:(id)sender {
}

@end
