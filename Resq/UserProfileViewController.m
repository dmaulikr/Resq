//
//  UserProfileViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/27/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CountryPickerViewController.h"
#import "UpdateUserProfileViewController.h"

@interface UserProfileViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) NSDictionary *selectedCountry;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeField;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameField.delegate = self;
    self.title = @"Profile";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_nameField setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"name"]];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"dial_code"]){
        [_phoneField setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"]];
    }
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

-(void)rightItemAction:(id)sender{
    
}

- (BOOL)validatePhoneNumber:(NSString*)number{
    if (number.length>=7)
        return TRUE;
    else
        return FALSE;
}

-(void)menuAction:(id)sender{
    [appdelegate.viewDeckController openLeftViewAnimated:YES];
}


- (IBAction)updateAction:(id)sender {
    UpdateUserProfileViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateUserProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
