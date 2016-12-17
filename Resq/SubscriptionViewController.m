//
//  SubscriptionViewController.m
//  Resq
//
//  Created by Muhammad Ahsan on 12/14/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "SubscriptionViewController.h"

#define SEASONPASS_IN_APP @"com.app.resq.seasonpass"
#define TOURIST_IN_APP @"com.app.resq.tourist"
#define WEEKEND_WARRIOR_IN_APP @"com.app.resq.weekendwarrior"

@interface SubscriptionViewController (){
    NSNumberFormatter * _priceFormatter;
    
}
@property (weak, nonatomic) IBOutlet UIButton *weekendwarrior_btn;
@property (weak, nonatomic) IBOutlet UIButton *tourist_btn;
@property (weak, nonatomic) IBOutlet UIButton *seasonpass_btn;

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Subscription"];
    [((UIScrollView *)self.view) setScrollEnabled:YES];
    ((UIScrollView *)self.view).contentSize = CGSizeMake(320.0, 555);
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self updateProducts];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _weekendwarrior_btn.hidden = YES;
    _tourist_btn.hidden = YES;
    _seasonpass_btn.hidden = YES;
    [self updateProducts];
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

-(void)updateProducts{
    for(SKProduct * product in [[MKStoreKit sharedKit] availableProducts]){
        [_priceFormatter setLocale:product.priceLocale];
        if([product.productIdentifier isEqualToString:WEEKEND_WARRIOR_IN_APP]){
            _weekendwarrior_btn.hidden = NO;
            [_weekendwarrior_btn setTitle:[_priceFormatter stringFromNumber:product.price] forState:UIControlStateNormal];
            
        }
        if([product.productIdentifier isEqualToString:SEASONPASS_IN_APP]){
            _seasonpass_btn.hidden = NO;
            [_seasonpass_btn setTitle:[_priceFormatter stringFromNumber:product.price] forState:UIControlStateNormal];
        }
        if([product.productIdentifier isEqualToString:TOURIST_IN_APP]){
            _tourist_btn.hidden = NO;
            [_tourist_btn setTitle:[_priceFormatter stringFromNumber:product.price] forState:UIControlStateNormal];
        }
        
        if([[MKStoreKit sharedKit] expiryDateForProduct:SEASONPASS_IN_APP]) {
            //unlock it
            NSLog(@"YES");
        }else{
            NSLog(@"NO");
        }
    }
}

-(IBAction)weekendwarriorAction:(id)sender{
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:WEEKEND_WARRIOR_IN_APP];
}

-(IBAction)touristAction:(id)sender{
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:TOURIST_IN_APP];
}

-(IBAction)seasonpassAction:(id)sender{
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:SEASONPASS_IN_APP];
}

@end
