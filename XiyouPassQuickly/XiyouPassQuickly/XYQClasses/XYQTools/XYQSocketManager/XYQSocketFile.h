//
//  XYQSocketFile.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "AsyncSocket.h"

//用于传出数据的socket
@protocol SocketFileDelegate <NSObject>

@required
- (void)getFileDataMessage:(NSData *)data;
- (void)getFileConnectionMessage:(NSString *)string;

@end

@interface XYQSocketFile : AsyncSocket

@property (nonatomic, weak) id<SocketFileDelegate> fileDelegate;

//链接socket方法 调用该方法前需要先设置IP和端口port 否则会崩溃
- (int) startConnectedServer:(NSString *)HostIP Port:(int)HostPort;

//断开链接(手动)
- (void)cutOffServer;

//发送消息
- (void)sendMessage:(id)message;

@end
