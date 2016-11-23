//
//  UserManager.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/24/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

static UserManager *_sharedUserManagerInstance = nil;

+ (UserManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUserManagerInstance = [[UserManager alloc] init];
    });
    return _sharedUserManagerInstance;
}

- (NSArray *)allEntitiesWithName:(NSString *)name sortKey:(NSString *)sortKey {
    return [self allEntitiesWithName:name sortDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES] ]];
}

- (NSArray *)allEntitiesWithName:(NSString *)name sortDescriptors:(NSArray *)descriptors {
    NSManagedObjectContext *context = appdelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:name];
    
    fetchRequest.sortDescriptors = descriptors;
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

-(void)updateUser:(NSDictionary*)contactDic{
    NSEntityDescription* entityDesc=[NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:appdelegate.managedObjectContext];
    Contacts *userobject = (Contacts *)[self getObject:NSStringFromClass([Contacts class]) predicate:nil];
    if(!userobject){
        userobject = (Contacts *) [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:appdelegate.managedObjectContext];
    }
    
    userobject.contact_id = ![[contactDic valueForKey:@"contact_id"] isKindOfClass:[NSNull class]]?[contactDic valueForKey:@"contact_id"] : @"";
    userobject.deviceToken = ![[contactDic valueForKey:@"deviceToken"]isKindOfClass:[NSNull class]]?[contactDic valueForKey:@"deviceToken"] : @(0);
    userobject.frequentCount = ![[contactDic valueForKey:@"frequentCount"]isKindOfClass:[NSNull class]]?[contactDic valueForKey:@"frequentCount"] : @"";
    userobject.isBuddy = ![[contactDic valueForKey:@"isBuddy"]isKindOfClass:[NSNull class]]?@([[contactDic valueForKey:@"isBuddy"] boolValue]) : @(NO);
    userobject.name = ![[contactDic valueForKey:@"dob"]isKindOfClass:[NSNull class]]?[contactDic valueForKey:@"dob"] : @"";
    userobject.phoneNumber = ![[contactDic valueForKey:@"phoneNumber"]isKindOfClass:[NSNull class]]?[contactDic valueForKey:@"phoneNumber"] : @"";
    
    NSError* error;
    [appdelegate.managedObjectContext save:&error];
    if(error){
        NSLog(@"Some thing is Wrong");
    }
}

-(NSManagedObject *)getObject:(NSString *)className predicate:(NSString*)predicate{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    if(predicate)
        fetchRequest.predicate = [NSPredicate predicateWithFormat:predicate];
    fetchRequest.fetchLimit = 1;
    NSError *error;
    NSArray *results = [appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results.count)
        return results[0];
    return nil;
}

-(NSArray *)getAllContacts:(NSString *)className predicate:(NSString*)predicate isFrequent:(BOOL)isFrequent{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    if(predicate)
        fetchRequest.predicate = [NSPredicate predicateWithFormat:predicate];
    
    if(isFrequent){
        fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"frequentCount" ascending:NO]];
        fetchRequest.fetchLimit = 4;
        
    }
    NSError *error;
    NSArray *results = [appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results.count)
        return results;
    return nil;
}


- (void)deleteAllEntitiesWithName:(NSString *)name{
    NSManagedObjectContext *context = appdelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:context]];
    [request setIncludesPropertyValues:NO];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    //error handling goes here
    for (NSManagedObject *obj in results) {
        [context deleteObject:obj];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}
@end
