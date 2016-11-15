//
//  ResqViewController.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResqViewController : UIViewController

@property (nonatomic,retain) UIBarButtonItem *leftItem;
@property (nonatomic,retain) UIBarButtonItem *rightItem;

- (void)menuAction:(id)sender;
- (void)rightItemAction:(id)sender;

@end
