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
@property (weak, nonatomic) IBOutlet UIButton *weekendwarrior_btn;
@property (weak, nonatomic) IBOutlet UIButton *tourist_btn;
@property (weak, nonatomic) IBOutlet UIButton *seasonpass_btn;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionStatus;

@property (strong, nonatomic) SKProduct * weekendWarrior_product;
@property (strong, nonatomic) SKProduct * tourist_product;
@property (strong, nonatomic) SKProduct * seasonpass_product;


@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightItem setTitle:@"Restore"];
    [self setTitle:@"Subscription"];
    [((UIScrollView *)self.view) setScrollEnabled:YES];
    ((UIScrollView *)self.view).contentSize = CGSizeMake(320.0, 555);
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:kMKStoreKitProductsAvailableNotification
     object:nil
     queue:[[NSOperationQueue alloc] init]
     usingBlock:^(NSNotification *note) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self updateProducts];
         });
     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:kMKStoreKitProductPurchasedNotification
     object:nil
     queue:[[NSOperationQueue alloc] init]
     usingBlock:^(NSNotification *note) {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
             [self performSelector:@selector(updateStatus) withObject:nil afterDelay:0.5];
             [SVProgressHUD dismiss];
         });
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                      [SVProgressHUD dismiss];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
                                                      NSLog(@"Restored Purchases");
                                                      [self performSelector:@selector(updateStatus) withObject:nil afterDelay:0.5];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitReceiptValidationNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [self performSelector:@selector(updateStatus) withObject:nil afterDelay:0.5];
                                                      });
                                                      
                                                      //[[MKStoreKit sharedKit] restorePurchases];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitReceiptValidationFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
                                                  }];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:kMKStoreKitProductsAvailableNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kMKStoreKitProductPurchasedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kMKStoreKitRestoredPurchasesNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kMKStoreKitRestoringPurchasesFailedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kMKStoreKitProductPurchaseFailedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kMKStoreKitReceiptValidationNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kMKStoreKitReceiptValidationFailedNotification];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _weekendwarrior_btn.hidden = YES;
    _tourist_btn.hidden = YES;
    _seasonpass_btn.hidden = YES;
    [self updateProducts];
    [self updateStatus];
}

-(void)menuAction:(id)sender{
    [appdelegate.viewDeckController openLeftViewAnimated:YES];
}

-(void)rightItemAction:(id)sender{
    [SVProgressHUD show];
    [[MKStoreKit sharedKit] restorePurchases];
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
            [_weekendwarrior_btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
            _weekendWarrior_product = product;
        }
        if([product.productIdentifier isEqualToString:SEASONPASS_IN_APP]){
            _seasonpass_btn.hidden = NO;
            [_seasonpass_btn setTitle:[_priceFormatter stringFromNumber:product.price] forState:UIControlStateNormal];
            [_seasonpass_btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
            _seasonpass_product = product;
        }
        if([product.productIdentifier isEqualToString:RIPPER_IN_APP]){
            _tourist_btn.hidden = NO;
            [_tourist_btn setTitle:[_priceFormatter stringFromNumber:product.price] forState:UIControlStateNormal];
            [_tourist_btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
            _tourist_product = product;
        }
    }
}

-(IBAction)weekendwarriorAction:(id)sender{
    
    [self startProductWithProductID:_weekendWarrior_product];
    //[[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:WEEKEND_WARRIOR_IN_APP];
}

-(IBAction)touristAction:(id)sender{
    [self startProductWithProductID:_tourist_product];
}

-(IBAction)seasonpassAction:(id)sender{
    [self startProductWithProductID:_seasonpass_product];
    //[[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:SEASONPASS_IN_APP];
}

-(void)startProductWithProductID:(SKProduct *)product{
    NSString *numberOfDays = @"";
    if([product.productIdentifier isEqualToString:WEEKEND_WARRIOR_IN_APP]){
        numberOfDays = @"3 Days";
    } else if([product.productIdentifier isEqualToString:SEASONPASS_IN_APP]){
        numberOfDays = @"1 Year";
    }else if([product.productIdentifier isEqualToString:RIPPER_IN_APP]){
        numberOfDays = @"1 Month";
    }
    
    if(![[NSUserDefaults standardUserDefaults] freeTrial]){
        if([[UserManager sharedManager] subscriptionNumberOfDaysLeft] > 0){
            UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Snow Rescue"  message:[NSString stringWithFormat:@"You currenctly have an active subscription. Do you want to buy The %@ and extend your current subscription with %@?",[NSString stringWithFormat:@"%@ for %@",product.localizedTitle,[_priceFormatter stringFromNumber:product.price]],numberOfDays]  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Buy" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [SVProgressHUD show];
                [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:product.productIdentifier];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else{
            [SVProgressHUD show];
            [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:product.productIdentifier];
        }
    }else{
        [SVProgressHUD show];
        [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:product.productIdentifier];
    }
}

-(void)updateStatus{
    
    NSInteger numberOfDays = [[UserManager sharedManager]subscriptionNumberOfDaysLeft];
    if([[MKStoreKit sharedKit] isProductPurchased:SEASONPASS_IN_APP]) {
        NSDate * date = [[MKStoreKit sharedKit] expiryDateForProduct:SEASONPASS_IN_APP];
        if([date isKindOfClass:[NSNull class]]){
            [[MKStoreKit sharedKit] refreshAppStoreReceipt];
            return;
        }
        
        
        if([[MKStoreKit sharedKit] expiryDateForProduct:SEASONPASS_IN_APP]) {
            if([[NSUserDefaults standardUserDefaults]freeTrial]){
                [[NSUserDefaults standardUserDefaults]setFreeTrial:NO];
                [[NSUserDefaults standardUserDefaults] setSubscriptionDate:[[UserManager sharedManager]getDateAfterAddingNumberOfDays:0]];
                NSLog(@"Days to be added :   %ld",[[UserManager sharedManager]seasonPassNumberOfDaysInWithExpiryDate:date]);
            }
        }else if([[MKStoreKit sharedKit] expiryDateForProduct:WEEKEND_WARRIOR_IN_APP]) {
            if([[NSUserDefaults standardUserDefaults]freeTrial]){
                [[NSUserDefaults standardUserDefaults]setFreeTrial:NO];
                [[NSUserDefaults standardUserDefaults] setSubscriptionDate:[[UserManager sharedManager]getDateAfterAddingNumberOfDays:0]];
                NSLog(@"Days to be added :   %ld",[[UserManager sharedManager]seasonPassNumberOfDaysInWithExpiryDate:date]);
            }
        }else{
            NSLog(@"NO");
        }
        numberOfDays += [[UserManager sharedManager]seasonPassNumberOfDaysInWithExpiryDate:date];
    }
    
    if([[NSUserDefaults standardUserDefaults]freeTrial]){
        [_subscriptionStatus setText:[NSString stringWithFormat:@"Free Trial ends in %ld day(s)",[[UserManager sharedManager]subscriptionNumberOfDaysLeft]]];
    } else if(numberOfDays <= 0){
        [_subscriptionStatus setText:[NSString stringWithFormat:@"Expired, Please choose an option"]];
    } else if(numberOfDays > 0){
        [_subscriptionStatus setText:[NSString stringWithFormat:@"Your Subscription status: Ends in %ld day(s)",numberOfDays]];
    }
}
@end
