//
//  BluetoothViewController.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/22/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BluetoothViewController : ResqViewController <MCBrowserViewControllerDelegate, MCSessionDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

- (void)sendMessage:(id)sender;
- (void)connectToDevice:(id)sender;

@end
