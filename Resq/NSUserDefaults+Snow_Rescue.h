//
//  NSUserDefaults+Snow_Rescue.h
//  Resq
//
//  Created by Muhammad Ahsan on 12/19/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Snow_Rescue)

- (BOOL)appSeeded;
- (void)setAppSeeded:(BOOL)appSeeded;

- (BOOL)freeTrial;
- (void)setFreeTrial:(BOOL)freeTrial;

- (BOOL)isFreeTrialOver;
- (void)setIsFreeTrialOver:(BOOL)isOver;

- (NSDate *)subscriptionDate;
- (void)setSubscriptionDate:(NSDate *)date;

@end
