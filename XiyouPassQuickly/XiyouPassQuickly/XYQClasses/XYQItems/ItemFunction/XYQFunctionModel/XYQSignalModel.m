//
//  XYQSignalModel.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQSignalModel.h"

@implementation XYQSignalModel

- (instancetype)initWithX:(double)x Y:(double)y Mode:(NSString *)mode {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _mode = mode;
    }
    return self;
}

- (void)setX:(double)x Y:(double)y Mode:(NSString *)mode {
    self.x = x;
    self.y = y;
    self.mode = mode;
}

@end
