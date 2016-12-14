//
//  PhoneNumberViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "CountryPickerViewController.h"

@interface PhoneNumberViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) NSDictionary *selectedCountry;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeField;

@end

@implementation PhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameField.delegate = self;
    self.title = @"Enter Details";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction:)];
    [rightItem setTitle:@"Save"];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
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

    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [appdelegate checkForTermsOfUseAndPrivacyPolicy:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)loadJsonDataWithFileName:(NSString *)filename{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    NSArray *arrays = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    return arrays;
}

- (IBAction)countryCodeAction:(id)sender {
    [_countryCodeField setAdjustsFontSizeToFitWidth:YES];
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
    [self presentViewController:navController animated:YES completion:nil];
    controller.completion = ^(NSMutableDictionary *selectedCountry) {
        [_countryCodeField setText:[NSString stringWithFormat:@"%@ -",[selectedCountry valueForKey:@"dial_code"]]];
    };
}

- (BOOL)validatePhoneNumber:(NSString*)number{
    if (number.length>=7)
        return TRUE;
    else
        return FALSE;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= 16 || returnKey;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)nextAction:(id)sender {
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
    [appdelegate setSettingsViewController];
}
@end
