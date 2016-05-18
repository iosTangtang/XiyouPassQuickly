//
//  XYQSocketCmd.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQSocketCmd.h"

@implementation XYQSocketCmd

//链接socket方法
- (int) startConnectedServer:(NSString *)HostIP Port:(int)HostPort {
    
    if ([HostIP isEqualToString:@""] || HostPort == 0) {
        NSParameterAssert(nil);
    }
    //配置socket的运行循环模式
    [self setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
    NSError *err = nil;
    
    if (![self isConnected]) {
        if (![self connectToHost:HostIP onPort:HostPort withTimeout:SOCKET_TIME_OUT error:&err]) {
            return SRV_CONNECTED_FAIL;
        } else {
            NSLog(@"Connect!");
            return SRV_CONNECTED_SUC;
        }
    } else {
        return SRV_CONNECTED;
    }
}

//断开链接(手动)
- (void)cutOffServer {
    self.userData = SOCKETOFFLINEBYUSER;
    [self disconnect];
}

//发送消息
- (void)sendMessage:(id)message {
    //向服务器发送数据
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self writeData:data withTimeout:WRITE_TIME_OUT tag:0];
}

#pragma mark AsyncSocketDelegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    [self.socketDelegate getCmdConnectionMessage:@"链接服务器成功"];
    [self readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    
    //获取还未来得及读取的数据
    NSData * unreadData = [sock unreadData];
    
    if(unreadData.length > 0) {
        //返回还未读取的数据
        [self onSocket:sock didReadData:unreadData withTag:0];
    } else {
        
        NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
        if (err.code == 57) {
            self.userData = SOCKETOFFLINEBYWIFICUT;
        }
    }
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    
    NSLog(@"Sorry the connect is failure %ld",sock.userData);
    [self.socketDelegate getCmdConnectionMessage:@"链接服务器失败"];
}

//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    [self readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}

//接收消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self.socketDelegate getCmdDataMessage:data];
    [self readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}


@end
