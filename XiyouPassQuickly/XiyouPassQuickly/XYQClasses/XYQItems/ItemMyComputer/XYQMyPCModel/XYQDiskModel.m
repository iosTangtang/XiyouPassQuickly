//
//  XYQDiskModel.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQDiskModel.h"

@implementation XYQDiskModel

- (instancetype)initWithFullName:(NSString *)fullName Name:(NSString *)name Label:(NSString *)label FileTyp:(NSString *)fileTyp {
    self = [super init];
    if (self) {
        _FullName = fullName;
        _Name = name;
        _Lable = label;
        _FileTyp = fileTyp;
    }
    return self;
}

- (void)setName:(NSString *)name VolLable:(NSString *)volLable FullName:(NSString *)fullName FileTyp:(NSString *)fileTyp {
    self.Name = name;
    self.Lable = volLable;
    self.FullName = fullName;
    self.FileTyp = fileTyp;
}

@end
