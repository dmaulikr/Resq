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
#import "SubscriptionViewController.h"
#import "PrivacyPolicyTermsOfUseViewController.h"

@interface MenuViewController ()<MFMailComposeViewControllerDelegate>
    
    @property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuButtons;
    
    @property (nonatomic, retain) UserProfileViewController * userProfileViewController;
    @property (nonatomic, retain) PrivacyPolicyTermsOfUseViewController * privacyPolicyViewController;
    @property (nonatomic, retain) InstructionsViewController * instructionsViewController;
    @property(nonatomic, retain) UIButton* selectedButton;
    
    @end

@implementation MenuViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [_scroller setScrollEnabled:YES];
    _scroller.contentSize = CGSizeMake(320.0, 555);

    
    _selectedButton = [_menuButtons objectAtIndex:0];
    [[[_menuButtons objectAtIndex:5]titleLabel] setNumberOfLines:0];
    [self unselectButtons];
}
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    _nameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    _phoneNumberField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"];
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
    
- (IBAction)activateAction:(UIButton*)sender {
    _selectedButton = sender;
    [self unselectButtons];
    if(appdelegate.landingViewController)
    appdelegate.landingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    [appdelegate.landingViewController setIsActivateScreen:YES];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:appdelegate.landingViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}
    
- (IBAction)settingsAction:(UIButton*)sender {
    _selectedButton = sender;
    [self unselectButtons];
    
    if(appdelegate.landingViewController)
    appdelegate.landingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    [appdelegate.landingViewController setIsActivateScreen:NO];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:appdelegate.landingViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}
    
- (IBAction)profileAction:(UIButton*)sender {
    _selectedButton = sender;
    [self unselectButtons];
    
    _userProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_userProfileViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}
    
- (IBAction)subscriptionAction:(UIButton*)sender {
    _selectedButton = sender;
    [self unselectButtons];
    
    SubscriptionViewController *subscriptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubscriptionViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:subscriptionViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}
    
- (IBAction)privacyPolicyAction:(UIButton*)sender {
    _selectedButton = sender;
    [self unselectButtons];
    
    _privacyPolicyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyTermsOfUseViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_privacyPolicyViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}
    
- (IBAction)howToUserAction:(UIButton*)sender {
    _selectedButton = sender;
    [self unselectButtons];
    
    _instructionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_instructionsViewController];
    [navigationController.navigationBar setTranslucent:NO];
    appdelegate.viewDeckController.centerController = navigationController;
    [appdelegate.viewDeckController closeOpenView];
}
    
- (IBAction)feedbackAction:(UIButton*)sender {
    _selectedButton = sender;
    [self unselectButtons];
    
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        composer.mailComposeDelegate = self;
        [composer setSubject:@"Snow Rescue"];
        [composer setToRecipients:@[@"Contact@snowrescueapp.com"]];
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
    
-(void)unselectButtons{
    for(UIButton * menuButton in _menuButtons){
        if(menuButton == _selectedButton){
            [menuButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:190.0/255.0 blue:246.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [menuButton setImage:[menuButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [menuButton.imageView setTintColor:[UIColor colorWithRed:0.0/255.0 green:190.0/255.0 blue:246.0/255.0 alpha:1.0]];
            
        }else{
            [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [menuButton setImage:[menuButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [menuButton.imageView setTintColor:[UIColor blackColor]];
            
        }
    }
}
    @end
