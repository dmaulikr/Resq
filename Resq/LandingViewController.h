//
//  LandingViewController.h
//  Resq
//
//  Created by Muhammad Ahsan on 12/4/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "ResqViewController.h"
#import "CarbonKit.h"
#import "ActivateViewController.h"
#import "SettingsViewController.h"

@interface LandingViewController : ResqViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIGestureRecognizerDelegate>

@property (assign)BOOL isActivateScreen;
@property (nonatomic, strong) UIPageViewController *pageViewController;


@end
