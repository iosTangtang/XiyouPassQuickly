//
//  XYQCtrPPTViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQCtrPPTViewController.h"
#import "XYQMyPCViewController.h"
#import "XYQSocketManager.h"
#import "XYQHandleModel.h"
#import "XYQCommomModel.h"

@interface XYQCtrPPTViewController ()<SocketCmdDelegate>

@property (nonatomic, strong) XYQSocketManager          *socketServer;
@property (nonatomic, strong) XYQHandleModel            *handle;
@property (nonatomic, strong) XYQMyPCViewController     *MyVC;
@property (nonatomic, assign) BOOL                      isMyVCOnline;

@end

@implementation XYQCtrPPTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)p_initView {
    self.socketServer = [XYQSocketManager socketManager];
    self.socketServer.socketCmd.socketDelegate = self;
    
    self.handle = [[XYQHandleModel alloc] init];
    
    self.title = @"遥控PPT";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XYQWidth, XYQHeight)];
    imageView.image = [UIImage imageNamed:@"Rectangle 1"];
    [self.view addSubview:imageView];
    
    UIButton *offPPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    offPPT.tag = 0;
    offPPT.frame = CGRectMake(XYQWidth / 2 - XYQWidth / 8, XYQHeight / 4, XYQWidth / 4, XYQHeight / 20);
    [offPPT setTitle:@"关闭PPT" forState:UIControlStateNormal];
    [offPPT setTintColor:[UIColor whiteColor]];
    [offPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:offPPT];
    
    UIButton *nextPPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextPPT.tag = 1;
    nextPPT.frame = CGRectMake(XYQWidth / 2 - XYQWidth / 3, XYQHeight / 3, XYQWidth / 4, XYQHeight / 20);
    [nextPPT setTitle:@"上一页" forState:UIControlStateNormal];
    [nextPPT setTintColor:[UIColor whiteColor]];
    [nextPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextPPT];
    
    UIButton *prePPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    prePPT.tag = 2;
    prePPT.frame = CGRectMake(XYQWidth / 2 + XYQWidth / 8, XYQHeight / 3, XYQHeight / 4, XYQHeight / 20);
    [prePPT setTitle:@"下一页" forState:UIControlStateNormal];
    [prePPT setTintColor:[UIColor whiteColor]];
    [prePPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prePPT];
    
    UIButton *firstPPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    firstPPT.tag = 3;
    firstPPT.frame = CGRectMake(XYQWidth / 2 - XYQWidth / 3, XYQHeight / 2, XYQWidth / 4, XYQHeight / 20);
    [firstPPT setTitle:@"第一页" forState:UIControlStateNormal];
    [firstPPT setTintColor:[UIColor whiteColor]];
    [firstPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstPPT];
    
    UIButton *lastPPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lastPPT.tag = 4;
    lastPPT.frame = CGRectMake(XYQWidth / 2 + XYQWidth / 8, XYQHeight / 2, XYQWidth / 4, XYQHeight / 20);
    [lastPPT setTitle:@"最后一页" forState:UIControlStateNormal];
    [lastPPT setTintColor:[UIColor whiteColor]];
    [lastPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastPPT];
    
    self.MyVC = [[XYQMyPCViewController alloc] init];
    self.MyVC.PPTOpera = @"PPTDO";
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.MyVC];
    [self presentViewController:navi animated:YES completion:nil];
    self.isMyVCOnline = YES;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(0, 0, 50, 30);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.MyVC.navigationItem.leftBarButtonItem = leftButton;
}

- (void)cancelButtonAction:(UIButton *)sender {
    self.isMyVCOnline = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)allPPT:(UIButton *)button {
    
    switch (button.tag) {
        case 0:
            [self.handle setTyp:@"Office" Msg:@"Close_PowerPoint"];
            break;
        case 1:
            [self.handle setTyp:@"Office" Msg:@"Up_PowerPoint"];
            break;
        case 2:
            [self.handle setTyp:@"Office" Msg:@"Down_PowerPoint"];
            break;
        case 3:
            [self.handle setTyp:@"Office" Msg:@"Frist_PowerPoint"];
            break;
        case 4:
            [self.handle setTyp:@"Office" Msg:@"Last_PowerPoint"];
            break;
        default:
            break;
    }
    
    NSString *string = [self.handle toJSONString];
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"1" Msg:string];
    NSString *comStr = [comm toJSONString];
    NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
    
    [self.socketServer.socketCmd sendMessage:sendStr];
}

- (void)getCmdDataMessage:(NSData *)data {
    
}

- (void)getCmdConnectionMessage:(NSString *)string {
    if ([string isEqualToString:@"链接服务器失败"]) {
        XYQSocketManager *socketServer = [XYQSocketManager socketManager];
        [socketServer.socketCmd cutOffServer];
        [socketServer.socketFile cutOffServer];
        if (self.isMyVCOnline == YES) {
            [self.MyVC dismissViewControllerAnimated:YES completion:nil];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSNotification *notification = [NSNotification notificationWithName:@"ConnectionFailed" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
