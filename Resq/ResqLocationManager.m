//
//  ResqLocationManager.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "ResqLocationManager.h"
//#import "AFHTTPSessionManager.h"
@import UIKit;
@import AVFoundation;       // for AVAudioSession

NSString * const didUpdateLocationNotification = @"didUpdateLocationNotification";
NSString * const didUpdateHeadingNotification = @"didUpdateHeadingNotification";
NSString * const locationMangerLocationServicesStatusChangeNotification = @"locationMangerLocationServicesStatusChangeNotification";

@interface ResqLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation ResqLocationManager

static ResqLocationManager *_sharedLocationManagerInstance = nil;

+ (ResqLocationManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManagerInstance = [[ResqLocationManager alloc] init];
    });
    return _sharedLocationManagerInstance;
}

- (id) init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self initilizeAudioPlayer];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 50.0;
    }
    return self;
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    NSLog(@"Ahsan");
    
}
-(void)outputRotationData:(CMRotationRate)rotation
{
    NSLog(@"Hananta");
    
}

- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingHeading];
    if([self respondsToSelector:@selector(allowsBackgroundLocationUpdates)])
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
                                                CMAcceleration userAcceleration = deviceMotion.userAcceleration;
                                                double totalAcceleration = sqrt(userAcceleration.x * userAcceleration.x +
                                                                                userAcceleration.y * userAcceleration.y + userAcceleration.z * userAcceleration.z);
                                                // UPDATE: print debug information
                                                float staticThreshold = 0.020;
                                                if(totalAcceleration> staticThreshold){
                                                    NSLog (@"total=%f", totalAcceleration);
                                                    [[UserManager sharedManager] setup];
                                                }
                                            }];
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    [self.motionManager stopDeviceMotionUpdates];
    
}

+ (BOOL)canUseLocationServices
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL phoneLocationServicesRestricted = ![CLLocationManager locationServicesEnabled];
    
    BOOL appLocationServicesRestricted;
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusNotDetermined:
            appLocationServicesRestricted = NO;
            break;
        default:
            appLocationServicesRestricted = YES;
            break;
    }
    
    BOOL result = (!phoneLocationServicesRestricted && !appLocationServicesRestricted) || !appLocationServicesRestricted;
    
    return result;
}

+ (BOOL)didPhoneAllowedUseLocationServices
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    BOOL appLocationServicesRestricted;
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            appLocationServicesRestricted = YES;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            appLocationServicesRestricted = YES;
            break;
        case kCLAuthorizationStatusNotDetermined:
            appLocationServicesRestricted = NO;
            break;
        case kCLAuthorizationStatusRestricted:
            appLocationServicesRestricted = NO;
            break;
        default:
            appLocationServicesRestricted = YES;
            break;
    }
    
    BOOL result = appLocationServicesRestricted;
    
    return result;
}

- (CLLocation *)currentLocation{
    //    if(!self->_currentLocation){
    //        [self startUpdatingLocation];
    //    }
    //    self.currentLocation = [[CLLocation alloc] initWithLatitude:25.130486 longitude: 55.11684];
    if (self->_currentLocation && CLLocationCoordinate2DIsValid(self->_currentLocation.coordinate)) {
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%f", self->_currentLocation.coordinate.latitude] forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%f", self->_currentLocation.coordinate.longitude] forKey:@"longitude"];
    }else{
        [[NSUserDefaults standardUserDefaults]setValue:@"0.00" forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults]setValue:@"0.00" forKey:@"longitude"];
    }
    return self->_currentLocation;
}

- (void)locationManager:(CLLocationManager *) manager didUpdateHeading:(nonnull CLHeading *)newHeading{
    //    NSLog(@"Heading");
    [[NSNotificationCenter defaultCenter] postNotificationName:didUpdateHeadingNotification object:newHeading];
    [[UserManager sharedManager] setup];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations != nil && locations.count > 0){
        [self setSessionActiveWithMixing:YES]; // YES == duck if other audio is playing
        //[self playSound];
        CLLocation *location = [locations lastObject];
        if (location)
            self.currentLocation = location;
        NSLog(@"%.3f,%.3f",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude);
        [[NSNotificationCenter defaultCenter] postNotificationName:didUpdateLocationNotification object:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [[NSNotificationCenter defaultCenter] postNotificationName:locationMangerLocationServicesStatusChangeNotification object:self];
}

#pragma mark - Audio Support

- (void)initilizeAudioPlayer{
    // set our default audio session state
    [self setSessionActiveWithMixing:NO];
    NSURL *heroSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Hero" ofType:@"aiff"]];
    assert(heroSoundURL);
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:heroSoundURL error:nil];
}

- (void)setSessionActiveWithMixing:(BOOL)duckIfOtherAudioIsPlaying{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] && duckIfOtherAudioIsPlaying){
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDuckOthers error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)playSound{
    assert(self.audioPlayer);
    if (self.audioPlayer && (self.audioPlayer.isPlaying == NO)){
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        //NSLog(@"update");
        //NSInteger count = [[[NSUserDefaults standardUserDefaults] valueForKey:@"count"] integerValue]+1;
        //[[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
        //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"count"]);
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

@end
