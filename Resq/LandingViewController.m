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
@property (nonatomic, retain) SettingsViewController* settingsViewController;
@property (nonatomic, retain) ActivateViewController* activateViewController;
@property (nonatomic, retain) UIPageControl* pageControl;

@end

@implementation LandingViewController

-(void)updateSettingScreen{
    self.title = @"Settings";
    [_pageControl setCurrentPage:0];
}

-(void)updateActiviateScreen{
    self.title = @"Activate";
    [_pageControl setCurrentPage:1];
}

-(void)menuAction:(id)sender{
    [appdelegate.viewDeckController openLeftViewAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    _activateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivateViewController"];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    NSArray *viewControllers = [NSArray arrayWithObject:_settingsViewController];
    if(_isActivateScreen){
        viewControllers = [NSArray arrayWithObject:_activateViewController];
    }
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    CGRect pageViewRect = self.view.bounds;
    pageViewRect = CGRectInset(pageViewRect, 0, 0);
    self.pageViewController.view.frame = pageViewRect;
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake((SCREEN_WIDTH-40)/2, SCREEN_HEIGHT-88 , 40, 20);
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.0/255.0 green:190.0/255.0 blue:246.0/255.0 alpha:1.0]];
    [self.view addSubview:_pageControl];
    if(_isActivateScreen){
        [self updateActiviateScreen];
    }else{
        [self updateSettingScreen];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if([viewController isKindOfClass:[ActivateViewController class]]){
        return _settingsViewController;
    }
    else{
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if([viewController isKindOfClass:[ActivateViewController class]]){
        return nil;
    }
    else{
        return _activateViewController;
    }
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if([previousViewControllers.firstObject isKindOfClass:[SettingsViewController class]]){
        [self updateActiviateScreen];
    }else{
        [self updateSettingScreen];
    }
}

#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    self.pageViewController.doubleSided = YES;
    return UIPageViewControllerSpineLocationMin;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appdelegate checkForTermsOfUseAndPrivacyPolicy:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
