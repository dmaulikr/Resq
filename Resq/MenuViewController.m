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
#import "UserProfileViewController.h"
#import "InstructionsViewController.h"
#import "PrivacyPolicyViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface MenuViewController ()<MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) UserProfileViewController * userProfileViewController;
@property (nonatomic, retain) PrivacyPolicyViewController * privacyPolicyViewController;
@property (nonatomic, retain) InstructionsViewController * instructionsViewController;

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
    if(appdelegate.landingViewController)
        appdelegate.landingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    [appdelegate.landingViewController setIsActivateScreen:YES];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:appdelegate.landingViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}

- (IBAction)settingsAction:(id)sender {
    if(appdelegate.landingViewController)
        appdelegate.landingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    [appdelegate.landingViewController setIsActivateScreen:NO];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:appdelegate.landingViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}

- (IBAction)profileAction:(id)sender {
    _userProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_userProfileViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}

- (IBAction)privacyPolicyAction:(id)sender {
    _privacyPolicyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_privacyPolicyViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}

- (IBAction)howToUserAction:(id)sender {
    _instructionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_instructionsViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}

- (IBAction)feedbackAction:(id)sender {
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        composer.mailComposeDelegate = self;
        [composer setSubject:@"RESQ"];
        [composer setToRecipients:@[@"eden201621@gmail.com"]];
        [self presentViewController:composer animated:YES completion:nil];
    }else{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Email", nil) message:NSLocalizedString(@"There are no Email account setup on this device. Go to Settings to add one.", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:^{
        //[appdelegate.viewDeckController closeOpenView];
    }];
}
@end
