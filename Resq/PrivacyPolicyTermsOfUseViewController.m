//
//  PrivacyPolicyViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 12/4/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "PrivacyPolicyTermsOfUseViewController.h"
#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyTermsOfUseViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PrivacyPolicyTermsOfUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableViews setTableFooterView:[[UIView alloc]init]];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UILabel* title = [cell viewWithTag:1];
    if(indexPath.row == 0){
        title.text = @"Privacy policy";
    } if(indexPath.row == 1){
        title.text = @"Terms of use";
    }
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* titleString = @"";
    NSString* urlString = @"";
    if(indexPath.row == 0){
        titleString = @"Privacy policy";
        urlString = @"http://www.snowrescueapp.com/privacy";
    } if(indexPath.row == 1){
        titleString = @"Terms of use";
        urlString = @"http://www.snowrescueapp.com/terms-of-use";
    }
    
    PrivacyPolicyViewController *privacyPolicyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyViewController"];
    [privacyPolicyViewController setUrlString:urlString];
    [privacyPolicyViewController setTitleString:titleString];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:privacyPolicyViewController];
    [navigationController.navigationBar setTranslucent:NO];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
@end
