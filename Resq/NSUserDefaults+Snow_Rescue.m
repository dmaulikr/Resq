//
//  NSUserDefaults+Snow_Rescue.m
//  Resq
//
//  Created by Muhammad Ahsan on 12/19/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "NSUserDefaults+Snow_Rescue.h"

@implementation NSUserDefaults (Snow_Rescue)

- (BOOL)appSeeded{
    return [self boolForKey:@"APP_SEDDED"];
}

- (void)setAppSeeded:(BOOL)appSeeded{
    [self setBool:appSeeded forKey:@"APP_SEDDED"];
    [self synchronize];
}

- (BOOL)freeTrial{
    return [self boolForKey:@"FREE_TRIAL"];
}

- (void)setFreeTrial:(BOOL)freeTrial{
    [self setBool:freeTrial forKey:@"FREE_TRIAL"];
    [self synchronize];
}

- (BOOL)isFreeTrialOver{
    if(![self objectForKey:@"IS_FREE_TRIAL_OVER"])
        return NULL;

    return [self boolForKey:@"IS_FREE_TRIAL_OVER"];
}

- (void)setIsFreeTrialOver:(BOOL)isOver{
    [self setBool:isOver forKey:@"IS_FREE_TRIAL_OVER"];
    [self synchronize];
}

- (NSDate *)subscriptionDate{
    return [self objectForKey:@"SUBSCRIPTION_DATE"];
}

- (void)setSubscriptionDate:(NSDate *)date{
    [self setObject:date forKey:@"SUBSCRIPTION_DATE"];
    [self synchronize];
}
@end
