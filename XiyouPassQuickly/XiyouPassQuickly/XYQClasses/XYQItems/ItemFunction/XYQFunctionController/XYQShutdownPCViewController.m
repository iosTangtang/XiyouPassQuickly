//
//  XYQShutdownPCViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQShutdownPCViewController.h"
#import "XYQSocketManager.h"
#import "XYQCommomModel.h"
#import "XYQHandleModel.h"

@interface XYQShutdownPCViewController ()<SocketCmdDelegate>

@property (nonatomic, strong) XYQSocketManager *socketServer;

@end

@implementation XYQShutdownPCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initWithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)p_initWithView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XYQWidth, XYQHeight)];
    imageView.image = [UIImage imageNamed:@"Rectangle 1"];
    [self.view addSubview:imageView];
    
    self.title = @"遥控关机";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 200, 60, 60);
    [button setTitle:@"遥控电脑" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction {
    XYQHandleModel *handle = [[XYQHandleModel alloc] init];
    XYQCommomModel *comm = [[XYQCommomModel alloc] init];
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"遥控电脑" message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *shutDown = [UIAlertAction actionWithTitle:@"关机"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [weakSelf timeShutDown];
                                                     }];
    [alert addAction:shutDown];
    
    UIAlertAction *logoff = [UIAlertAction actionWithTitle:@"注销"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [handle setTyp:@"Cmd" Msg:@"Win_Logoff"];
                                                       NSString *string = [handle toJSONString];
                                                       [comm setFlag:@"1" Msg:string];
                                                       NSString *comStr = [comm toJSONString];
                                                       
                                                       NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
                                                       
                                                       [weakSelf.socketServer.socketCmd sendMessage:sendStr];
                                                   }];
    [alert addAction:logoff];
    
    UIAlertAction *sleep = [UIAlertAction actionWithTitle:@"睡眠"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [handle setTyp:@"Cmd" Msg:@"Win_Sleep"];
                                                      NSString *string = [handle toJSONString];
                                                      [comm setFlag:@"1" Msg:string];
                                                      NSString *comStr = [comm toJSONString];
                                                      NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
                                                      
                                                      [weakSelf.socketServer.socketCmd sendMessage:sendStr];
                                                  }];
    [alert addAction:sleep];
    
    UIAlertAction *reset = [UIAlertAction actionWithTitle:@"重启"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [handle setTyp:@"Cmd" Msg:@"Win_Reset"];
                                                      NSString *string = [handle toJSONString];
                                                      [comm setFlag:@"1" Msg:string];
                                                      NSString *comStr = [comm toJSONString];
                                                      NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
                                                      
                                                      [weakSelf.socketServer.socketCmd sendMessage:sendStr];
                                                  }];
    [alert addAction:reset];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 限时关机
- (void)timeShutDown {
    XYQHandleModel *handle = [[XYQHandleModel alloc] init];
    XYQCommomModel *comm = [[XYQCommomModel alloc] init];
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"遥控电脑" message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *shutDown = [UIAlertAction actionWithTitle:@"立即关机"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [handle setTyp:@"Cmd" Msg:@"Win_Shutdown_Immediately"];
                                                         NSString *string = [handle toJSONString];
                                                         [comm setFlag:@"1" Msg:string];
                                                         NSString *comStr = [comm toJSONString];
                                                         
                                                         NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
                                                         
                                                         [weakSelf.socketServer.socketCmd sendMessage:sendStr];
                                                     }];
    [alert addAction:shutDown];
    
    UIAlertAction *logoff = [UIAlertAction actionWithTitle:@"半小时关机"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [handle setTyp:@"Cmd" Msg:@"Win_Shutdown_HalfAfterHour"];
                                                       NSString *string = [handle toJSONString];
                                                       [comm setFlag:@"1" Msg:string];
                                                       NSString *comStr = [comm toJSONString];
                                                       
                                                       NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
                                                       
                                                       NSLog(@"%@", sendStr);
                                                       [weakSelf.socketServer.socketCmd sendMessage:sendStr];
                                                   }];
    [alert addAction:logoff];
    
    UIAlertAction *sleep = [UIAlertAction actionWithTitle:@"一小时关机"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [handle setTyp:@"Cmd" Msg:@"Win_Shutdown_AfterOneHour"];
                                                      NSString *string = [handle toJSONString];
                                                      [comm setFlag:@"1" Msg:string];
                                                      NSString *comStr = [comm toJSONString];
                                                      NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
                                                      
                                                      [weakSelf.socketServer.socketCmd sendMessage:sendStr];
                                                  }];
    [alert addAction:sleep];
    
    UIAlertAction *reset = [UIAlertAction actionWithTitle:@"取消关机"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [handle setTyp:@"Cmd" Msg:@"Win_Shutdown_Cancel"];
                                                      NSString *string = [handle toJSONString];
                                                      [comm setFlag:@"1" Msg:string];
                                                      NSString *comStr = [comm toJSONString];
                                                      NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
                                                      
                                                      [weakSelf.socketServer.socketCmd sendMessage:sendStr];
                                                  }];
    [alert addAction:reset];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [weakSelf presentViewController:alert animated:YES completion:nil];
}

#pragma mark SocketCmdDelegate
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
