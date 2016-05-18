//
//  XYQCommomModel.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQCommomModel.h"

@implementation XYQCommomModel

- (instancetype)initWithFlag:(NSString *)flag Msg:(NSString *)msg {
    self = [super init];
    if (self) {
        _Flag = flag;
        _Msg = msg;
    }
    return self;
}

- (void)setFlag:(NSString *)flag Msg:(NSString *)msg {
    self.Flag = flag;
    self.Msg = msg;
}

@end
