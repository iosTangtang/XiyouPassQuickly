//
//  XYQHandleModel.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQHandleModel.h"

@implementation XYQHandleModel

- (instancetype)initWithTyp:(NSString *)typ Msg:(NSString *)msg {
    self = [super init];
    if (self) {
        _Typ = typ;
        _Msg = msg;
    }
    return self;
}

- (void)setTyp:(NSString *)typ Msg:(NSString *)msg {
    self.Typ = typ;
    self.Msg = msg;
}

@end
