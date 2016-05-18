//
//  XYQSocketManager.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "XYQSocketCmd.h"
#import "XYQSocketFile.h"

@interface XYQSocketManager : NSObject <NSCopying, AsyncSocketDelegate>

@property (nonatomic, strong) XYQSocketCmd    *socketCmd;
@property (nonatomic, strong) XYQSocketFile   *socketFile;

+ (instancetype)socketManager;

- (void)initSocket;

@end
