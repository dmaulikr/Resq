//
//  LandingViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 12/4/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "LandingViewController.h"

@interface LandingViewController (){
    UIImageView *navBarHairlineImageView;
}

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RESQ";
    NSArray *items = @[ @"Settings", @"Activate"];
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation =
    [[CarbonTabSwipeNavigation alloc] initWithItems:items delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:self];
    carbonTabSwipeNavigation.navigationController.navigationBar.translucent = NO;
    [carbonTabSwipeNavigation setTabBarHeight:40.0];
    
    [carbonTabSwipeNavigation.toolbar setTranslucent:NO];
    [carbonTabSwipeNavigation setNormalColor:[UIColor grayColor]];
    [carbonTabSwipeNavigation setSelectedColor:[UIColor blackColor]];
    [carbonTabSwipeNavigation setIndicatorColor:[UIColor blackColor]];
    
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:SCREEN_WIDTH/2 forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:SCREEN_WIDTH/2 forSegmentAtIndex:1];
    if(_isActivateScreen)
        [carbonTabSwipeNavigation setCurrentTabIndex:1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
    [appdelegate checkForTermsOfUseAndPrivacyPolicy:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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

// delegate
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                         viewControllerAtIndex:(NSUInteger)index {
    SettingsViewController * settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    ActivateViewController * activateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivateViewController"];
    
    if(index==0){
        return  settingsViewController;
    }else
        return  activateViewController;
}

-(void)menuAction:(id)sender{
    [appdelegate.viewDeckController openLeftViewAnimated:YES];
}
@end
