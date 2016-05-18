//
//  XYQFileModel.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQFileModel.h"

@implementation XYQFileModel

- (instancetype)initWithSize:(long)size Name:(NSString *)name Typ:(NSString *)typ Msg:(NSString *)msg {
    self = [super init];
    if (self) {
        _Size = size;
        _Name = name;
        _Typ = typ;
        _Msg = msg;
    }
    return self;
}

- (void) setSize:(long)Size Name:(NSString *)Name Type:(NSString *)Type Msg:(NSString *)Msg {
    self.Size = Size;
    self.Name = Name;
    self.Typ = Type;
    self.Msg = Msg;
}

@end
