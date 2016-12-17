//
//  ActivateViewController.h
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResqViewController.h"
#import "ActivateViewController.h"

@interface ActivateViewController : ResqViewController

@property (weak, nonatomic) IBOutlet UILabel *longitude_label;
@property (weak, nonatomic) IBOutlet UILabel *latitude_label;
@property (weak, nonatomic) IBOutlet UIButton *activate_btn;
@property (weak, nonatomic) IBOutlet UILabel *accuracy_label;

@end
