//
//  PhoneNumberViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "CountryPickerViewController.h"

@interface PhoneNumberViewController ()

@property (nonatomic, retain) NSDictionary *selectedCountry;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeField;

@end

@implementation PhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Enter Details";
    [self.rightItem setTitle:@"Save"];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
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
    
    BOOL isValidPhoneNumber = [self validatePhoneNumber:self.phoneField.text];
    
    if(!isValidPhoneNumber){
        ALERT_VIEW(@"RESQ", @"Please enter a valid mobile number.")
        return;
    }
    
    
    NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",[_selectedCountry valueForKey:@"dial_code"],_phoneField.text];
    NSLog(@"phone number: %@",phoneNumber);
    [[NSUserDefaults standardUserDefaults]setValue:phoneNumber forKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults]setValue:_nameField.text forKey:@"name"];
    [SVProgressHUD show];
    [[FirebaseManager sharedManager]registerOrUpdateUserWithcompletion:^(BOOL isUpdated, NSError *error) {
        if(isUpdated){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if(error){
            ALERT_VIEW(@"RESQ", error.localizedDescription)
        }
        [SVProgressHUD dismiss];
    }];
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

- (BOOL)validatePhoneNumber:(NSString*)number
{
    NSString *numberRegEx = @"[235689][0-9]{6}([0-9]{3})?";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}
@end
