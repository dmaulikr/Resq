//
//  PrivacyPolicyViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 12/4/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleString;
    if([self presentingViewController]){
        [self.leftItem setImage:[UIImage imageNamed:@"back-arrow"]];
    }
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross-ping-btn"] style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)menuAction:(id)sender{
    if([self presentingViewController]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [appdelegate.viewDeckController openLeftViewAnimated:YES];
    }
}
@end
