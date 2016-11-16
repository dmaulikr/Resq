//
//  CountryTableViewCell.m
//  Resq
//
//  Created by Muhammad Ahsan on 11/16/16.
//  Copyright © 2016 Eden. All rights reserved.
//

#import "CountryTableViewCell.h"

@implementation CountryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor clearColor];
        self.savingLabel.backgroundColor = [UIColor clearColor];
        self.savingLabel.adjustsFontSizeToFitWidth = YES;
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
        self.savingLabel = [[UILabel alloc] init];
        [self addSubview:self.savingLabel];
        [self.savingLabel setTextColor:self.savingLabel.textColor];
        [self.savingLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.savingLabel.frame = CGRectMake(16, 0, CGRectGetWidth(self.bounds) - 50, CGRectGetHeight(self.bounds));
    if (!self.selected)
        self.accessoryView.frame = CGRectZero;
    else
        self.accessoryView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 40, CGRectGetHeight(self.bounds) / 2 - 7, 18, 15);
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft){
        self.savingLabel.frame = CGRectMake(20, 0, CGRectGetWidth(self.bounds) - 36, CGRectGetHeight(self.bounds));
        [self.savingLabel setTextAlignment:NSTextAlignmentRight];
        if (!self.selected)
            self.accessoryView.frame = CGRectZero;
        else
            self.accessoryView.frame = CGRectMake( 15, CGRectGetHeight(self.bounds) / 2 - 7, 18, 15);
    }
}
@end
