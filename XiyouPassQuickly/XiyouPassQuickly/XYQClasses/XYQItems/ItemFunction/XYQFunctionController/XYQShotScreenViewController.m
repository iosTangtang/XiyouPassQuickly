//
//  XYQShotScreenViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQShotScreenViewController.h"
#import "XYQSocketManager.h"
#import "XYQHandleModel.h"
#import "XYQCommomModel.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhotoPickerBrowserViewController.h"

@interface XYQShotScreenViewController ()<SocketCmdDelegate> {
    int _icount;
    int _length;
}

@property (nonatomic, strong) XYQSocketManager          *socketServer;
@property (nonatomic, strong) NSMutableData             *muData;
@property (nonatomic, strong) UIImageView               *shotImage;
@property (nonatomic, strong) UIActivityIndicatorView   *activity;

@end

@implementation XYQShotScreenViewController

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XYQWidth, XYQHeight)];
    imageView.image = [UIImage imageNamed:@"Rectangle 1"];
    [self.view addSubview:imageView];
    
    self.shotImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 104, XYQWidth - 40, 200)];
    self.shotImage.backgroundColor = [UIColor lightGrayColor];
    self.shotImage.userInteractionEnabled = YES;
    [self.view addSubview:self.shotImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self.shotImage addGestureRecognizer:tap];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(XYQWidth / 2.0 - 30, 350, 60, 85);
//    [button setTitle:@"截屏" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"icon1"] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //初始化缓冲控件
    self.activity = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.frame = CGRectMake(0, 0, XYQWidth / 6, XYQWidth / 6);
    self.activity.center = self.view.center;
    self.activity.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.activity];
}

- (void)buttonAction {
    _icount = 0;
    self.muData = nil;
    
    XYQHandleModel *handle = [[XYQHandleModel alloc] init];
    [handle setTyp:@"Cmd" Msg:@"Win_Screenshot"];
    self.shotImage.image = nil;
    
    NSString *string = [handle toJSONString];
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"1" Msg:string];
    NSString *comStr = [comm toJSONString];
    
    NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
    
    [self.socketServer.socketCmd sendMessage:sendStr];
}

#pragma mark - 单击放大功能
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_length != 0 && self.muData.length == _length) {
        ZLPhotoPickerBrowserViewController *browVC = [[ZLPhotoPickerBrowserViewController alloc] init];
        [browVC showHeadPortrait:self.shotImage];
    }
}

#pragma mark - socketCmd Delegate
- (void)getCmdDataMessage:(NSData *)data {
    _icount++;
    if (_icount == 1) {
        _length = 0;
        [data getBytes:&_length length:sizeof(_length)];
        self.muData = [NSMutableData data];
        if (data.length > 4) {
            NSMutableData *tempData = [NSMutableData dataWithData:data];
            NSData *firstData = [tempData subdataWithRange:NSMakeRange(4, data.length - 4)];
            [self.muData appendData:firstData];
        }
        [self.activity startAnimating];
    } else {
        [self.muData appendData:data];
        if (self.muData.length == _length) {
            [self.activity stopAnimating];
            NSLog(@"%lu", (unsigned long)self.muData.length);
            self.shotImage.image = [UIImage imageWithData:self.muData];
        }
    }
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
