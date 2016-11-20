//
//  FirebaseManager.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/20/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirebaseManager : NSObject

+ (FirebaseManager *)sharedManager;

@property (strong, nonatomic) FIRDatabaseReference *ref;

-(void)registerOrUpdateUserWithcompletion:(void (^)(BOOL isUpdated, NSError * error))completion;
@end
