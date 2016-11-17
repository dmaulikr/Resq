//
//  MenuViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "MenuViewController.h"
#import "SettingsViewController.h"
#import "ActivateViewController.h"
#import "AppDelegate.h"

@interface MenuViewController ()

@property (nonatomic, retain) SettingsViewController * settingsViewController;
@property (nonatomic, retain) ActivateViewController * activateViewController;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)activateAction:(id)sender {
    _activateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivateViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_activateViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];

//    [appdelegate.sideMenuViewController setContentViewController:navigationController animated:YES];
//    [appdelegate.sideMenuViewController hideMenuViewController];
}

- (IBAction)settingsAction:(id)sender {
    _settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_settingsViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];

//    [appdelegate.sideMenuViewController setContentViewController:navigationController animated:YES];
//    [appdelegate.sideMenuViewController hideMenuViewController];
}
@end
