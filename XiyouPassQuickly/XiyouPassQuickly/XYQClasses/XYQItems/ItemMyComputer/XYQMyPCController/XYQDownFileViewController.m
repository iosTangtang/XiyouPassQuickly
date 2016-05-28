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

//@property (nonatomic, strong) UIActivityIndicatorView   *activity;
@property (nonatomic, assign) int                       icount;
@property (nonatomic, strong) NSMutableData             *muData;
@property (nonatomic, copy)   NSString                  *fileName;
@property (nonatomic, strong) UIWebView                 *webView;
@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UIProgressView            *progress;

@end

@implementation XYQDownFileViewController

#pragma mark - lazy load
- (UIProgressView *)progress {
    if (_progress == nil) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progress.frame = CGRectMake(0, XYQHeight / 20 + XYQHeight / 28, XYQWidth, 0);
        _progress.trackTintColor = [UIColor whiteColor];
        _progress.progress = 0;
        _progress.transform = CGAffineTransformMakeScale(1.0f, 6.0f);
        _progress.progressTintColor = [UIColor colorWithRed:62 / 255.0 green:230 / 255.0 blue:110 / 255.0 alpha:1];
    }
    return _progress;
}

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
    button.frame = CGRectMake(19, 20, 50, 20);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 2 - XYQWidth / 4, XYQHeight / 28, XYQWidth / 2, 23)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    //添加进度条
    [self.view addSubview:self.progress];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake(XYQWidth - XYQWidth / 8, XYQHeight / 28, 23, 23);
    [shareButton setTintColor:[UIColor whiteColor]];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"Fill 126"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
}

#pragma mark ButtonAction
- (void)buttonAction {
    self.muData = nil;
    self.icount = 0;
    
    XYQSocketManager *socketServer = [XYQSocketManager socketManager];
    socketServer.socketFile.fileDelegate = nil;
    
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
}

#pragma mark - SocketFileDelegate
- (void)getFileDataMessage:(NSData *)data {
    
    _icount++;
    if (_icount == 1) {
        _length = 0;
        [data getBytes:&_length length:sizeof(_length)];
        NSLog(@"----%d", _length);
        self.muData = [NSMutableData data];
        if (data.length > 4) {
            NSMutableData *tempData = [NSMutableData dataWithData:data];
            NSData *firstData = [tempData subdataWithRange:NSMakeRange(4, data.length - 4)];
            [self.muData appendData:firstData];
        }
    } else {
        [self.muData appendData:data];
        [self.progress setProgress:self.muData.length / (float)_length animated:YES];
        if (self.muData.length == _length) {
            NSLog(@"%lu", (unsigned long)self.muData.length);
            [self createFile];
            self.muData = nil;
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
    
    if (succeed) {
        [self.progress removeFromSuperview];
        NSURL *url = [NSURL fileURLWithPath:pathStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    } else {
        [self showMessage:@"加载文件失败"];
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
