//
//  ResqLocationManager.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const didUpdateLocationNotification;
extern NSString * const locationMangerLocationServicesStatusChangeNotification;

@interface ResqLocationManager : NSObject

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (ResqLocationManager *)sharedManager;

- (void) startUpdatingLocation;
- (void) stopUpdatingLocation;

+ (BOOL)canUseLocationServices;
+ (BOOL)didPhoneAllowedUseLocationServices;

//
@property (nonatomic, strong) CLLocationManager *locationManager;


@end
