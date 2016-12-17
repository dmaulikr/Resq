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
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar.png"]]];
    _leftItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"menu_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStyleDone target:self action:@selector(menuAction:)];
    [_leftItem setShouldGroupAccessibilityChildren:YES];
    _rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction:)];
    
    [self.navigationItem setRightBarButtonItem:_rightItem animated:YES];
    [self.navigationItem setLeftBarButtonItem:_leftItem animated:YES];
}

- (void)menuAction:(id)sender {
    [appdelegate.sideMenuViewController presentLeftMenuViewController];
}

- (void)rightItemAction:(id)sender {
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
