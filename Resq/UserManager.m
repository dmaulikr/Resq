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

-(void)setup{
    //    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        if(_isActivated){
    //            int totalTime = [[NSUserDefaults standardUserDefaults]floatForKey:@"notificationTime"];
    //
    //            NSLog(@"Ahsan %d    -     %d",_timeRemaining ,totalTime);
    //            if(_timeRemaining<=totalTime){
    //                _timeRemaining++;
    //            }else{
    //                NSLog(@"Fire Alert");
    //                _isActivated = NO;
    //            }
    //        }
    //    }];
    
    if(_isActivated){
        if(_alertTimer){
            [_alertTimer invalidate];
        }
        _alertTimer = [NSTimer scheduledTimerWithTimeInterval:[[NSUserDefaults standardUserDefaults]floatForKey:@"notificationTime"] target:self selector:@selector(alertAction) userInfo:nil repeats:NO];
    }
}

-(void)alertAction{
    if(_isActivated){
        
        NSString *predicateString = [NSString stringWithFormat:@"isBuddy = '%@' ", @(YES)];
        NSMutableArray* arr = (NSMutableArray*)[[UserManager sharedManager]getAllContacts:@"Contacts" predicate:predicateString isFrequent:NO];
        for(Contacts * contact in arr){
            [self sendMessage:contact.phoneNumber];
        }
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.alertBody = @"Send SMS to all buddies!";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        //[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        _isActivated = NO;
    }
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

- (NSString *)urlencode:(NSString*)string {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[string UTF8String];
    NSInteger sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(void)sendMessage:(NSString*)to{
    NSString * from = @"+12137856052";
    from = [self urlencode:from];
    to = [self urlencode:to];
    NSLog(@"%@   %@",to, from);
    NSString* mapUrlPath = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f&iwloc=A",[ResqLocationManager sharedManager].currentLocation.coordinate.latitude,[ResqLocationManager sharedManager].currentLocation.coordinate.longitude];
    mapUrlPath = [self urlencode:mapUrlPath];
    
    NSString *post = [NSString stringWithFormat:@"To=%@&From=%@&Body=%@ needs your help at this location: %@",to,from,[[NSUserDefaults standardUserDefaults] valueForKey:@"name"],mapUrlPath];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",postData.length];
    NSString *urlString = [NSString stringWithFormat: @"https://api.twilio.com/2010-04-01/Accounts/AC069ca1df85386763f163a49d22948cdb/Messages.json"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: urlString]];
    [request setHTTPMethod: @"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [request setTimeoutInterval:100];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"AC069ca1df85386763f163a49d22948cdb",@"4b61e09a05a8f7a0ae46378ceb51d2c3"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    NSData *response;
    NSError *WSerror;
    NSHTTPURLResponse *WSresponse = nil;
    NSString *responseString;
    response = [NSURLConnection sendSynchronousRequest:request returningResponse:&WSresponse error:&WSerror];
    responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] ;
    if(WSresponse.statusCode == 0){
        NSLog(@"Response: %@",responseString);
    }
}

-(void)startAdvertising{
    static NSString * const BBDemoServiceUUID = @"7846ED88-7CD9-495F-AC2A-D34D245C9FB6";
    CBUUID *demoServiceUUID = [CBUUID UUIDWithString:BBDemoServiceUUID];
    NSDictionary *dict = @{
                           CBAdvertisementDataServiceUUIDsKey : @[demoServiceUUID],
                           CBAdvertisementDataLocalNameKey : [NSString stringWithFormat:@"%@√%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"name"],[[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"]],
                           CBAdvertisementDataTxPowerLevelKey : @"923",
                           CBAdvertisementDataManufacturerDataKey : @"BlocksBluetooth Demo This is a BlocksBluetooth demo characteristic",
                           };
    [[CBPeripheralManager defaultManager] startAdvertising:dict didStart:^(NSError *error) {
        if(error){
            NSLog(@"Error startAdvertising::: %@",error);
        }
    }];
}

@end
