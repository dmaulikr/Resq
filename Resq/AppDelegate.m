//
//  AppDelegate.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/14/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "AppDelegate.h"
#import "ActivateViewController.h"
#import "MenuViewController.h"
#import "SettingsViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "PhoneNumberViewController.h"
#import "LandingViewController.h"
#import "PrivacyPolicyViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"] && [[[NSUserDefaults standardUserDefaults]valueForKey:@"phoneNumber"] length]){
        [self setActivateViewController];
    }else{
        [[NSUserDefaults standardUserDefaults]setFloat:120.0 forKey:@"notificationTime"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PhoneNumberViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"PhoneNumberViewController"];
        self.window.rootViewController = controller;
    }
    
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    /*[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bar.png"]]];
     */
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor colorWithRed:176.0/255.0 green:184.0/255.0 blue:198.0/255.0 alpha:1.0]}];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0/255.0 green:190.0/255.0 blue:246.0/255.0 alpha:1.0]];
     
    [[MKStoreKit sharedKit] startProductRequest];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:kMKStoreKitProductsAvailableNotification
     object:nil
     queue:[[NSOperationQueue alloc] init]
     usingBlock:^(NSNotification *note) {
         NSLog(@"Products available: %@", [[MKStoreKit sharedKit] availableProducts]);
         for(SKProduct * product in [[MKStoreKit sharedKit] availableProducts]){
             
             NSNumberFormatter *_priceFormatter = [[NSNumberFormatter alloc] init];
             [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
             [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
             [_priceFormatter setLocale:product.priceLocale];
             
             
             NSLog(@"Price: %@",[_priceFormatter stringFromNumber:product.price]);
             NSLog(@"Description: %@",product.localizedDescription);
             NSLog(@"Title: %@",product.localizedTitle);
             NSLog(@"Identifire: %@\n\n\n\n",product.productIdentifier);
             
             NSLog(@"%@",[[MKStoreKit sharedKit] expiryDateForProduct:@"com.app.resq.seasonpass"]);
             if([[MKStoreKit sharedKit] expiryDateForProduct:@"com.app.resq.seasonpass"]) {
                 //unlock it
                 NSLog(@"YES");
             }else{
                 NSLog(@"NO");
             }
             
             
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             if([[MKStoreKit sharedKit] isProductPurchased:@"com.app.resq.seasonpass"]) {
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                     
                 });                                                          }
             else{
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                     
                 });
             }
         });
     }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}

-(void)setActivateViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ActivateViewController *contentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ActivateViewController"];
    //    SettingsViewController *contentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    MenuViewController * leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    if(!_landingViewController)
        _landingViewController = [storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    [_landingViewController setIsActivateScreen:YES];
    _appNavigationController = [[UINavigationController alloc]initWithRootViewController:_landingViewController];
    [_appNavigationController.navigationBar setTranslucent:NO];
    _sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:_appNavigationController
                                                         leftMenuViewController:leftMenuViewController
                                                        rightMenuViewController:nil];
    _sideMenuViewController.contentViewInPortraitOffsetCenterX = -10 * DEVICE_OFFSET;
    [_sideMenuViewController setPanGestureEnabled:NO];
    [_sideMenuViewController setParallaxEnabled:NO];
    _sideMenuViewController.fadeMenuView = NO;
    _sideMenuViewController.scaleMenuView = YES;
    
    _viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:_appNavigationController leftViewController:leftMenuViewController];
    _viewDeckController.panningCancelsTouchesInView = NO;
    _viewDeckController.leftSize = 60 * DEVICE_OFFSET;
    _viewDeckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    self.window.rootViewController = _viewDeckController;
    
    //    self.window.rootViewController = _sideMenuViewController;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Eden.Resq" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Resq" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Resq.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)checkForTermsOfUseAndPrivacyPolicy:(UIViewController*)viewController{
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"Agreement Accepted"]){
        return;
    }
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Privacy Policy and Terms of Use"  message:@"By clicking \"I accept\", I agree to accept the Privacy Policy and Terms of Use!"  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Privacy Policy and Terms of Use" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PrivacyPolicyViewController *privacyPolicyViewController = [storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyViewController"];
        UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:privacyPolicyViewController];
        [navigationController.navigationBar setTranslucent:NO];
        [viewController presentViewController:navigationController animated:YES completion:nil];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"I accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Agreement Accepted"];
    }]];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (UIViewController*) topMostController{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController isKindOfClass:[UIAlertController class]]){
        topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return topController;
}
@end
