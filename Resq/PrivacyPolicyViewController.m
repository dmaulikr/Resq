//
//  PrivacyPolicyViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 12/4/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Privacy Policy and Terms of Use";
    if([self presentingViewController]){
        [self.leftItem setImage:[UIImage imageNamed:@"back-arrow"]];
        
    }
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Temp_privacy_policy" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];

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

-(void)menuAction:(id)sender{
    if([self presentingViewController]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [appdelegate.viewDeckController openLeftViewAnimated:YES];
}
@end
