//
//  SubscriptionViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 12/14/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "SubscriptionViewController.h"

@interface SubscriptionViewController (){
    NSNumberFormatter * _priceFormatter;
    
}

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Subscription"];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          for(SKProduct *prod in [MKStoreKit sharedKit]. availableProducts){
                                                              [_priceFormatter setLocale:prod.priceLocale];
                                                          }
                                                      });
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      if([[MKStoreKit sharedKit] isProductPurchased:@"com.app.resq.seasonpass"]) {
                                                          NSLog(@"YES");
                                                          
                                                          
                                                          if(![[NSUserDefaults standardUserDefaults]boolForKey:@"isPaymentStatusUpdated"]){
                                                              
                                                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                                                                  
                                                                  
                                                              });
                                                              
                                                              [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isPaymentStatusUpdated"];
                                                              [[NSUserDefaults standardUserDefaults]synchronize];
                                                              
                                                          }
                                                          
                                                          
                                                          
                                                      }
                                                      
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
                                                      NSLog(@"Restored Purchases");
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                  }];
    
}

-(void)menuAction:(id)sender{
    [appdelegate.viewDeckController openLeftViewAnimated:YES];
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

@end
