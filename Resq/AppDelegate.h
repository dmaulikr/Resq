//
//  AppDelegate.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/14/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <RESideMenu/RESideMenu.h>
#import "LandingViewController.h"

#define DEVICE_OFFSET (CGRectGetWidth([UIScreen mainScreen].bounds)/320)
#define appdelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) RESideMenu *sideMenuViewController;
@property (strong, nonatomic) UINavigationController *appNavigationController;
@property (nonatomic, retain) IIViewDeckController *viewDeckController;
@property (nonatomic, retain) LandingViewController *landingViewController;

-(void)saveContext;
-(NSURL*)applicationDocumentsDirectory;
-(void)setActivateViewController;
-(void)checkForTermsOfUseAndPrivacyPolicy:(UIViewController*)viewController;
-(void)testAlrt;
@end

