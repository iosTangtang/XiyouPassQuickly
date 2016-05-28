//
//  XYQVoiceChangeViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/22.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQVoiceChangeViewController.h"
#import "XYQSocketManager.h"
#import "XYQHandleModel.h"
#import "XYQCommomModel.h"

@interface XYQVoiceChangeViewController ()<SocketCmdDelegate>

@end

@implementation XYQVoiceChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - private method
- (void)p_initButton {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XYQWidth, XYQHeight)];
    imageView.image = [UIImage imageNamed:@"Rectangle 1"];
    [self.view addSubview:imageView];
    
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    upButton.tag = 1;
    upButton.frame = CGRectMake(XYQWidth / 2.0 - 70, XYQHeight / 2.0 - 20, 60, 40);
//    [upButton setTitle:@"增大音量" forState:UIControlStateNormal];
    [upButton setBackgroundImage:[UIImage imageNamed:@"volue"] forState:UIControlStateNormal];
    [upButton setTintColor:[UIColor whiteColor]];
    [upButton addTarget:self action:@selector(voiceCtrlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upButton];
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    downButton.tag = 2;
    downButton.frame = CGRectMake(XYQWidth / 2.0 + 20, XYQHeight / 2.0 - 20, 60, 40);
//    [downButton setTitle:@"减小音量" forState:UIControlStateNormal];
    [downButton setBackgroundImage:[UIImage imageNamed:@"downVolue"] forState:UIControlStateNormal];
    [downButton setTintColor:[UIColor whiteColor]];
    [downButton addTarget:self action:@selector(voiceCtrlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.tag = 3;
    closeButton.frame = CGRectMake(XYQWidth / 2.0 - 20, XYQHeight / 2.0 + 40, 60, 40);
//    [closeButton setTitle:@"静音" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"ccccccc"] forState:UIControlStateNormal];
    [closeButton setTintColor:[UIColor whiteColor]];
    [closeButton addTarget:self action:@selector(voiceCtrlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
}

#pragma mark - voiceController
- (void)voiceCtrlAction:(UIButton *)sender {
    XYQHandleModel *handle = [[XYQHandleModel alloc] init];
    
    if (sender.tag == 1) {
        [handle setTyp:@"Cmd" Msg:@"Win_VolumeUp"];
    } else if (sender.tag == 2) {
        [handle setTyp:@"Cmd" Msg:@"Win_VolumeDown"];
    } else {
        [handle setTyp:@"Cmd" Msg:@"Win_VolumeMute"];
    }
    
    
    NSString *string = [handle toJSONString];
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"1" Msg:string];
    NSString *comStr = [comm toJSONString];
    
    NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
    XYQSocketManager *socket = [XYQSocketManager socketManager];
    socket.socketCmd.socketDelegate = self;
    [socket.socketCmd sendMessage:sendStr];
}

#pragma mark - socketCmd Delegate
- (void)getCmdDataMessage:(NSData *)data {
    
}

- (void)getCmdConnectionMessage:(NSString *)string {
    if ([string isEqualToString:@"链接服务器失败"]) {
        XYQSocketManager *socketServer = [XYQSocketManager socketManager];
        [socketServer.socketCmd cutOffServer];
        [socketServer.socketFile cutOffServer];
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSNotification *notification = [NSNotification notificationWithName:@"ConnectionFailed" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
