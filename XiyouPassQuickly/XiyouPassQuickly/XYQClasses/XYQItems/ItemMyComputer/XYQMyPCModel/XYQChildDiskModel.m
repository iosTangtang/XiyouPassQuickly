//
//  XYQChildDiskModel.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQChildDiskModel.h"

@implementation XYQChildDiskModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.childDisk = [NSMutableArray array];
    }
    return self;
}

- (void)addDisk:(XYQDiskModel *)disk {
    [self.childDisk addObject:disk];
}

@end
