//
//  XYQMyPCCollectionViewCell.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQMyPCCollectionViewCell.h"

@implementation XYQMyPCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_initView];
    }
    return self;
}

- (void)p_initView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width / 10,
                                                                self.contentView.frame.size.height / 10,
                                                                self.contentView.frame.size.width / 10 * 6,
                                                                self.contentView.frame.size.height / 10 * 6)];
    backView.backgroundColor = [UIColor colorWithRed:44 / 255.0 green:151 / 255.0
                                                blue:221 / 255.0 alpha:1];
    [backView.layer setCornerRadius:self.contentView.frame.size.width / 10 * 3];
    [self.contentView addSubview:backView];
    
    self.diskLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               self.contentView.frame.size.width / 10 * 1.5,
                                                               self.contentView.frame.size.width / 10 * 6,
                                                               self.contentView.frame.size.height / 10 * 3)];
    [self.diskLabel setTextColor:[UIColor whiteColor]];
    [self.diskLabel setFont:[UIFont fontWithName:@"Helvetica-Bold"
                                            size:15]];
    self.diskLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.diskLabel];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width / 10,
                                                                 self.contentView.frame.size.width / 10 * 7,
                                                                 self.contentView.frame.size.width / 10 * 6,
                                                                 self.contentView.frame.size.height / 10 * 3)];
    [self.detailLabel setTextColor:[UIColor whiteColor]];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.detailLabel setFont:[UIFont fontWithName:@"Helvetica-Bold"
                                              size:15]];
    [self.contentView addSubview:self.detailLabel];
}

@end
