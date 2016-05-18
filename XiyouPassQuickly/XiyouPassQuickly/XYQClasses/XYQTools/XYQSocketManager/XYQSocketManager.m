//
//  XYQSocketManager.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQSocketManager.h"

static XYQSocketManager *socketManager = nil;
@implementation XYQSocketManager

+ (instancetype)socketManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketManager = [[super allocWithZone:NULL] init];
    });
    return socketManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self socketManager];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

- (void)initSocket {
    self.socketCmd = [[XYQSocketCmd alloc] init];
    self.socketCmd.delegate = self.socketCmd;
    
    self.socketFile = [[XYQSocketFile alloc] init];
    self.socketFile.delegate = self.socketFile;
}

@end
