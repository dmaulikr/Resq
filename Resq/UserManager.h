//
//  UserManager.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/24/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject{
    NSMutableData* fileData;
}

+ (UserManager *)sharedManager;

-(NSManagedObject *)getObject:(NSString *)className predicate:(NSString*)predicate;
-(NSArray *)getAllContacts:(NSString *)className predicate:(NSString*)predicate isFrequent:(BOOL)isFrequent;

-(void)setup;
-(void)startAdvertising;
-(void)sendMessage:(NSString*)to;

@property(assign) BOOL isActivated;
@property(assign) int timeRemaining;
@property(nonatomic, retain)NSTimer * alertTimer;
@property(nonatomic, retain)NSTimer * alertDif30;
@property(nonatomic, retain)NSTimer * alertDif20;
@property(nonatomic, retain)NSTimer * alertDif10;
@property(nonatomic, retain)NSTimer * alertDif1;

-(NSDate*)getDateAfterAddingNumberOfDays:(int)days;
-(NSInteger)subscriptionNumberOfDaysLeft;
-(NSDate*)getUpdatedSubscriptionDateAfterAddingNumberOfDays:(int)days;
-(NSInteger)seasonPassNumberOfDaysInWithExpiryDate:(NSDate*)date;

@end
