//
//  UserProfileViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/27/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CountryPickerViewController.h"

@interface UserProfileViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) NSDictionary *selectedCountry;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeField;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameField.delegate = self;
    self.title = @"user details";
    [self.rightItem setTitle:@"Save"];
    
    // Do any additional setup after loading the view.
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode]; // get country code, e.g. ES (Spain), FR (France), etc.
    if(countryCode){
        NSArray *arrays = [self loadJsonDataWithFileName:@"country"];
        for( NSDictionary* countryDic in arrays){
            if([[countryDic valueForKey:@"code"] isEqualToString:countryCode]){
                _selectedCountry = countryDic;
                [_countryCodeField setText:[NSString stringWithFormat:@"(%@) -",[_selectedCountry valueForKey:@"dial_code"]]];
                break;
            }
        }
    }
    [_nameField setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"name"]];
    [_phoneField setText:[[[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"] stringByReplacingOccurrencesOfString:[[NSUserDefaults standardUserDefaults] valueForKey:@"dial_code"] withString:@""]];
    [_countryCodeField setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"dial_code"]];
    
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
    if([_nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
        ALERT_VIEW(@"RESQ", @"Please enter your name.")
        return;
    }
    
    BOOL isValidPhoneNumber = true;//[self validatePhoneNumber:self.phoneField.text];
    
    if(!isValidPhoneNumber){
        ALERT_VIEW(@"RESQ", @"Please enter a valid mobile number.")
        return;
    }
    
    NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",[_selectedCountry valueForKey:@"dial_code"],_phoneField.text];
    NSLog(@"phone number: %@",phoneNumber);
    [[NSUserDefaults standardUserDefaults]setValue:phoneNumber forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults]setValue:_nameField.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults]setValue:[_selectedCountry valueForKey:@"dial_code"] forKey:@"dial_code"];
    
    ALERT_VIEW(@"RESQ", @"User profile update!")
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
        [_countryCodeField setText:[NSString stringWithFormat:@"(%@) -",[selectedCountry valueForKey:@"dial_code"]]];
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
@end
