//
//  XYQDownFileViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQDownFileViewController.h"
#import "XYQSocketManager.h"
#import "XYQChildDiskModel.h"
#import "XYQFileModel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XYQDownFileViewController ()<SocketFileDelegate> {
    int _length;
}

@property (nonatomic, strong) UIActivityIndicatorView   *activity;
@property (nonatomic, assign) int                       icount;
@property (nonatomic, strong) NSMutableData             *muData;
@property (nonatomic, copy)   NSString                  *fileName;
@property (nonatomic, strong) UIWebView                 *webView;
@property (nonatomic, strong) UILabel                   *titleLabel;

@end

@implementation XYQDownFileViewController

//- (NSMutableData *)muData {
//    if (_muData == nil) {
//        _muData = [NSMutableData data];
//    }
//    return _muData;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.icount = 0;
    self.muData = [NSMutableData data];
    
    [self p_initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)p_initView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XYQWidth, XYQHeight)];
    imageView.image = [UIImage imageNamed:@"Rectangle 1"];
    [self.view addSubview:imageView];
    
    //注册通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(NotificationAction:) name:@"Down" object:nil];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, XYQHeight / 20 + XYQHeight / 28,
                                                               XYQWidth, XYQHeight - XYQHeight / 20)];
    [self.webView.layer setCornerRadius:5];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;             //自动对页面进行缩放以适应屏幕
    [self.view addSubview:self.webView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(19, XYQHeight / 28, 12, 23);
    [button setBackgroundImage:[UIImage imageNamed:@"fa-angle-left"] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 2 - XYQWidth / 4, XYQHeight / 28, XYQWidth / 2, 23)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    //初始化缓冲控件
    self.activity = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.frame = CGRectMake(0, 0, XYQWidth / 6, XYQWidth / 6);
    self.activity.center = self.view.center;
    self.activity.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.activity];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake(XYQWidth - XYQWidth / 8, XYQHeight / 28, 23, 23);
    [shareButton setTintColor:[UIColor whiteColor]];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"Fill 126"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
}

#pragma mark ButtonAction
- (void)buttonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareButtonAction {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *pathStr = [NSString stringWithFormat:@"%@/%@", path, self.fileName];
    
    NSURL *shareUrl = [NSURL fileURLWithPath:pathStr];
    NSArray *shareArray = @[shareUrl];
    UIActivityViewController *controller = [[UIActivityViewController alloc]
                                            initWithActivityItems:shareArray applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)NotificationAction:(id)sender {
    XYQChildDiskModel *dis = [sender userInfo];
    XYQFileModel *file = [[XYQFileModel alloc] init];
    [file setSize:0 Name:dis.Name Type:@"FileDownload" Msg:dis.FullName];
    self.fileName = dis.Name;
    self.titleLabel.text = self.fileName;
    
    NSString *jsonStr = [file toJSONString];
    
    XYQSocketManager *socketServer = [XYQSocketManager socketManager];
    socketServer.socketFile.fileDelegate = self;
    [socketServer.socketFile sendMessage:jsonStr];
    [self.activity startAnimating];
}

#pragma mark - SocketFileDelegate
- (void)getFileDataMessage:(NSData *)data {
    
    self.icount++;
    if (self.icount == 1) {
        [data getBytes:&_length length:sizeof(_length)];
        NSLog(@"----%d", _length);
    } else if (self.icount > 1) {
        [self.muData appendData:data];
        if (self.muData.length == _length) {
            NSLog(@"%d", self.muData.length);
            [self createFile];
        }
    }
    
}

- (void)getFileConnectionMessage:(NSString *)string {
    if ([string isEqualToString:@"链接服务器失败"]) {
        XYQSocketManager *socketServer = [XYQSocketManager socketManager];
        [socketServer.socketCmd cutOffServer];
        [socketServer.socketFile cutOffServer];
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSNotification *notification = [NSNotification notificationWithName:@"ConnectionFailed" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

#pragma mark - 解析数据并在沙盒中创建文件
- (void)createFile {
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *pathStr = [NSString stringWithFormat:@"%@/%@", path, self.fileName];
    
    BOOL succeed = [self.muData writeToFile:pathStr atomically:YES];
    
    [self.activity stopAnimating];
    
    if (succeed) {
        NSURL *url = [NSURL fileURLWithPath:pathStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
}

#pragma mark ShowMessage
- (void)showMessage:(NSString *)string{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self buttonAction];
    }];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end