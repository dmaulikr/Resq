//
//  UpdateUserProfileViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 12/17/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "UpdateUserProfileViewController.h"
#import "CountryPickerViewController.h"

@interface UpdateUserProfileViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) NSDictionary *selectedCountry;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeField;

@end

@implementation UpdateUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameField.delegate = self;
    self.title = @"Profile";
    //[self.rightItem setTitle:@"Save"];
    


    NSString *countryCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"dial_code"];
    if(countryCode){
        NSArray *arrays = [self loadJsonDataWithFileName:@"country"];
        for( NSDictionary* countryDic in arrays){
            if([[countryDic valueForKey:@"dial_code"] isEqualToString:countryCode]){
                _selectedCountry = countryDic;
                [_countryCodeField setTitle:[NSString stringWithFormat:@"(%@) -",[_selectedCountry valueForKey:@"dial_code"]] forState:UIControlStateNormal];
                [_countryCodeField sizeToFit];
                CGRect frame = _phoneField.frame;
                frame.origin.x = CGRectGetMaxX(_countryCodeField.frame) +5;
                _phoneField.frame =frame;
                
                break;
            }
        }
    }
    [_nameField setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"name"]];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"dial_code"]){
        [_phoneField setText:[[[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"] stringByReplacingOccurrencesOfString:[[NSUserDefaults standardUserDefaults] valueForKey:@"dial_code"] withString:@""]];
    }
    [_countryCodeField setTitle:[NSString stringWithFormat:@"(%@) - ",[[NSUserDefaults standardUserDefaults] valueForKey:@"dial_code"]] forState:UIControlStateNormal];
    [_countryCodeField sizeToFit];
    CGRect frame = _phoneField.frame;
    frame.origin.x = CGRectGetMaxX(_countryCodeField.frame) +5;
    _phoneField.frame =frame;
    
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
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

-(NSArray*)loadJsonDataWithFileName:(NSString *)filename{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSArray *arrays = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    return arrays;
}

- (IBAction)countryCodeAction:(id)sender {
    CountryPickerViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CountryPickerViewController"];
    NSArray *arrays = [self loadJsonDataWithFileName:@"country"];
    NSSortDescriptor* brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    arrays = [[arrays sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    [controller setObjects:arrays];
    [controller setSelectedObject:_selectedCountry];
    [controller setKeypath:@"name"];
    [controller setTitle:NSLocalizedString(@"Select Country",nil)];
    UINavigationController * navController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
    controller.completion = ^(NSMutableDictionary *selectedCountry) {
        _selectedCountry = selectedCountry;
        [_countryCodeField setTitle:[NSString stringWithFormat:@"(%@) -",[selectedCountry valueForKey:@"dial_code"]] forState:UIControlStateNormal];
        [_countryCodeField sizeToFit];
        CGRect frame = _phoneField.frame;
        frame.origin.x = CGRectGetMaxX(_countryCodeField.frame) + 5;
        _phoneField.frame =frame;
    };
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

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 16 || returnKey;
}

- (IBAction)updateAction:(id)sender {
    [self.view endEditing:YES];
    if([_nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
        ALERT_VIEW(@"Snow Rescue", @"Please enter your name.")
        return;
    }
    
    BOOL isValidPhoneNumber = true;//[self validatePhoneNumber:self.phoneField.text];
    
    if(!isValidPhoneNumber){
        ALERT_VIEW(@"Snow Rescue", @"Please enter a valid mobile number.")
        return;
    }
    
    NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",[_selectedCountry valueForKey:@"dial_code"],_phoneField.text];
    NSLog(@"phone number: %@",phoneNumber);
    [[NSUserDefaults standardUserDefaults]setValue:phoneNumber forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults]setValue:_nameField.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults]setValue:[_selectedCountry valueForKey:@"dial_code"] forKey:@"dial_code"];
    [self.navigationController popViewControllerAnimated:YES];
    ALERT_VIEW(@"Snow Rescue", @"User profile update!")
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
