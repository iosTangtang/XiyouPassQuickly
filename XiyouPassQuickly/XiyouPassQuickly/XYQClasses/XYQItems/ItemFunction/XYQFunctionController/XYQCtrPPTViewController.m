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
    offPPT.frame = CGRectMake(XYQWidth / 2.0 - 15, XYQHeight / 2.0 - 15, 30, 30);
    [offPPT setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [offPPT setTintColor:[UIColor whiteColor]];
    [offPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:offPPT];
    
    UILabel *offLabel = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 2.0 - 20, XYQHeight / 2.0 + 15, 40, 20)];
    offLabel.text = @"关闭";
    offLabel.font = [UIFont systemFontOfSize:12.f];
    offLabel.textColor = [UIColor whiteColor];
    offLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:offLabel];
    
    UIButton *prePPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    prePPT.tag = 1;
    prePPT.frame = CGRectMake(XYQWidth / 2.0 - 85, XYQHeight / 2.0 - 15, 20, 30);
    [prePPT setBackgroundImage:[UIImage imageNamed:@"pre"] forState:UIControlStateNormal];
    [prePPT setTintColor:[UIColor whiteColor]];
    [prePPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prePPT];
    
    UILabel *preLabel = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 2.0 - 90, XYQHeight / 2.0 + 15, 40, 20)];
    preLabel.text = @"上一页";
    preLabel.font = [UIFont systemFontOfSize:12.f];
    preLabel.textColor = [UIColor whiteColor];
    preLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:preLabel];
    
    UIButton *nextPPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextPPT.tag = 2;
    nextPPT.frame = CGRectMake(XYQWidth / 2.0 + 65, XYQHeight / 2.0 - 15, 20, 30);
    [nextPPT setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextPPT setTintColor:[UIColor whiteColor]];
    [nextPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextPPT];
    
    UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 2.0 + 55, XYQHeight / 2.0 + 15, 40, 20)];
    nextLabel.text = @"下一页";
    nextLabel.font = [UIFont systemFontOfSize:12.f];
    nextLabel.textColor = [UIColor whiteColor];
    nextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nextLabel];
    
    UIButton *firstPPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    firstPPT.tag = 3;
    firstPPT.frame = CGRectMake(XYQWidth / 2.0 - 12.5, XYQHeight / 2.0 - 100, 25, 30);
    [firstPPT setBackgroundImage:[UIImage imageNamed:@"first"] forState:UIControlStateNormal];
    [firstPPT setTintColor:[UIColor whiteColor]];
    [firstPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstPPT];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 2.0 - 20, XYQHeight / 2.0 - 70, 40, 20)];
    firstLabel.text = @"第一页";
    firstLabel.font = [UIFont systemFontOfSize:12.f];
    firstLabel.textColor = [UIColor whiteColor];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:firstLabel];
    
    UIButton *lastPPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lastPPT.tag = 4;
    lastPPT.frame = CGRectMake(XYQWidth / 2.0 - 12.5, XYQHeight / 2.0 + 70, 25, 30);
    [lastPPT setBackgroundImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
    [lastPPT setTintColor:[UIColor whiteColor]];
    [lastPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastPPT];
    
    UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 2.0 - 30, XYQHeight / 2.0 + 100, 60, 20)];
    lastLabel.text = @"最后一页";
    lastLabel.font = [UIFont systemFontOfSize:12.f];
    lastLabel.textColor = [UIColor whiteColor];
    lastLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lastLabel];
    
    UIButton *playPPT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playPPT.tag = 5;
    playPPT.frame = CGRectMake(XYQWidth / 2.0 - 12.5, XYQHeight / 2.0 - 180, 30, 30);
    [playPPT setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playPPT setTintColor:[UIColor whiteColor]];
    [playPPT addTarget:self action:@selector(allPPT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playPPT];
    
    UILabel *playLabel = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 2.0 - 20, XYQHeight / 2.0 - 150, 40, 20)];
    playLabel.text = @"播放";
    playLabel.font = [UIFont systemFontOfSize:12.f];
    playLabel.textColor = [UIColor whiteColor];
    playLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:playLabel];
    
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
            [self.handle setTyp:@"Cmd" Msg:@"Close_powerpnt"];
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
        case 5:
            [self.handle setTyp:@"Office" Msg:@"Play_PowerPoint"];
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
