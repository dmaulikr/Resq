//
//  FirebaseManager.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/20/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "FirebaseManager.h"

@implementation FirebaseManager

static FirebaseManager *_sharedManagerInstance = nil;

+ (FirebaseManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManagerInstance = [[FirebaseManager alloc] init];
        
    });
    return _sharedManagerInstance;
}

- (id) init {
    if (self = [super init]) {
        _ref = [[FIRDatabase database] reference];
    }
    return self;
}


-(void)registerOrUpdateUserWithcompletion:(void (^)(BOOL isUpdated, NSError * error))completion{
    NSString* name = [[NSUserDefaults standardUserDefaults]valueForKey:@"name"];
    NSString* phoneNumber = [[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"];
    NSString* deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"];
    deviceToken = deviceToken ? deviceToken : @"";
    
    [[[[_ref child:@"users"]queryOrderedByChild:@"phone"] queryEqualToValue:phoneNumber]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
        if(snapshot.exists){
            NSDictionary * dic = snapshot.value;
            NSLog(@"%@",[[dic allKeys] firstObject]);
            [[[_ref child:@"users"]child:[[dic allKeys] firstObject]] setValue:@{@"name":name, @"token":deviceToken, @"phone":phoneNumber}withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if(error){
                    completion(NO,error);
                }else{
                    completion(YES,nil);
                }
            }];
        }else{
            [[_ref child:@"users"].childByAutoId setValue:@{@"name":name,@"token":deviceToken,@"phone":phoneNumber} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                [[[[_ref child:@"users"]queryOrderedByChild:@"phone"] queryEqualToValue:phoneNumber]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * snapshot) {
                    if(snapshot.exists){
                        NSDictionary * dic = snapshot.value;
                        NSLog(@"%@",[[dic allKeys] firstObject]);
                        completion(YES,nil);
                    }
                } withCancelBlock:^(NSError * _Nonnull error) {
                    completion(NO,error);
                }];
            }];
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        completion(NO,error);
    }];
}

-(void)getContacts{
//    [[[_ref child:@"users"]queryOrderedByChild:@"phone"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
//        if(snapshot.exists){
//            NSDictionary * dic = snapshot.value;
//            NSLog(@"%@",[[dic allKeys] firstObject]);
//            completion(YES,nil);
//        }
//    } withCancelBlock:^(NSError * _Nonnull error) {
//        completion(NO,error);
//    }];

}

@end
