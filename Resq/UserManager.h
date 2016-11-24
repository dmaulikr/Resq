//
//  UserManager.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/24/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (UserManager *)sharedManager;

-(NSManagedObject *)getObject:(NSString *)className predicate:(NSString*)predicate;
-(NSArray *)getAllContacts:(NSString *)className predicate:(NSString*)predicate isFrequent:(BOOL)isFrequent;

@end
