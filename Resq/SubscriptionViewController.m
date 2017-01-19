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

@property (assign)BOOL isRipperCanDo;
@property (assign)BOOL isSeasonCanDo;


@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightItem setTitle:@"Restore"];
    [self setTitle:@"Subscription"];
    [((UIScrollView *)self.view) setScrollEnabled:YES];
    ((UIScrollView *)self.view).contentSize = CGSizeMake(320.0, 575);
    
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
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self updatePurchased];
                                                      });
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self updatePurchased];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      [SVProgressHUD dismiss];
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
    [[NSNotificationCenter defaultCenter] removeObserver:kMKStoreKitReceiptValidationFailedNotification];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _weekendwarrior_btn.hidden = YES;
    _tourist_btn.hidden = YES;
    _seasonpass_btn.hidden = YES;
    [self updateProducts];
    [self performSelector:@selector(updateStatus:) withObject:@(NO) afterDelay:0.0];
}

-(void)menuAction:(id)sender{
    [appdelegate.viewDeckController openLeftViewAnimated:YES];
}

-(void)rightItemAction:(id)sender{
    [SVProgressHUD show];
    [[MKStoreKit sharedKit] restorePurchases];
}

-(void)updatePurchased{
    [SVProgressHUD show];
    int64_t number = [[NSDate date] timeIntervalSince1970];
    number *= 1000;
    NSNumber * currentTime = @(number);
    [[MKStoreKit sharedKit] startValidatingAppStoreReceiptWithCompletionHandler:^(NSArray *receipts, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(!error){
                BOOL isExpired = YES;
                for(NSDictionary * receipt in receipts){
                    if(receipt && [receipt valueForKey:@"expires_date_ms"] && [[receipt valueForKey:@"expires_date_ms"]doubleValue]>[currentTime doubleValue]){
                        NSLog(@"Date1 %@:",[NSDate date]);
                        NSInteger expiryValue = [[receipt valueForKey:@"expires_date_ms"] integerValue];
                        expiryValue = expiryValue/1000;
                        NSTimeInterval timestamp = (NSTimeInterval)[@(expiryValue) doubleValue];
                        NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
                        NSLog(@"Date2 %@:",updatetimestamp);
                        NSInteger numberOfDays = [[UserManager sharedManager]seasonPassNumberOfDaysInWithExpiryDate:updatetimestamp];
                        [[NSUserDefaults standardUserDefaults] setSubscriptionDate:[[UserManager sharedManager]getDateAfterAddingNumberOfDays:[@(numberOfDays) intValue]]];
                        isExpired = NO;
                        break;
                    }
                }
                if(receipts && isExpired && ![[NSUserDefaults standardUserDefaults]freeTrial]){
                    [[NSUserDefaults standardUserDefaults] setSubscriptionDate:[[UserManager sharedManager]getDateAfterAddingNumberOfDays:0]];
                }
                [self updateStatus:@(NO)];
                [SVProgressHUD dismiss];
                
            }else{
                NSLog(@" Error: %@",error);
                [SVProgressHUD dismiss];
            }
        });
    }];
}

-(void)updateProducts{
    for(SKProduct * product in [[MKStoreKit sharedKit] availableProducts]){
        [_priceFormatter setLocale:product.priceLocale];
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
}

-(IBAction)touristAction:(id)sender{
    _isRipperCanDo = YES;
    [self startProductWithProductID:_tourist_product];
}

-(IBAction)seasonpassAction:(id)sender{
    _isRipperCanDo = YES;
    [self startProductWithProductID:_seasonpass_product];
}

-(void)startProductWithProductID:(SKProduct *)product{
    NSString *numberOfDays = @"";
    
    if([product.productIdentifier isEqualToString:SEASONPASS_IN_APP]){
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

-(void)updateStatus:(NSNumber*)timerObject{
    NSInteger numberOfDays = [[UserManager sharedManager]subscriptionNumberOfDaysLeft];
    if([[NSUserDefaults standardUserDefaults]freeTrial]){
        [_subscriptionStatus setText:[NSString stringWithFormat:@"Free Trial ends in %ld day(s)",[[UserManager sharedManager]subscriptionNumberOfDaysLeft]]];
    } else if(numberOfDays <= 0){
        [_subscriptionStatus setText:[NSString stringWithFormat:@"Expired, Please choose an option"]];
    } else if(numberOfDays > 0){
        [_subscriptionStatus setText:[NSString stringWithFormat:@"Your Subscription status: Ends in %ld day(s)",numberOfDays]];
    }
    [SVProgressHUD dismiss];
}
@end
