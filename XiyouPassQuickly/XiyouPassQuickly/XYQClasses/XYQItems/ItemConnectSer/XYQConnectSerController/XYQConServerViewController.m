//
//  XYQConServerViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQConServerViewController.h"
#import "HCScanQRViewController.h"
#import "SystemFunctions.h"
#import "XYQSocketManager.h"

@interface XYQConServerViewController ()<UITextFieldDelegate, SocketCmdDelegate>

@property (nonatomic, strong) UITextField               *ipTextField;
@property (nonatomic, strong) UITextField               *portTextField;
@property (nonatomic, strong) UIActivityIndicatorView   *activity;
@property (nonatomic, strong) UIButton                  *connectButton;

@end

@implementation XYQConServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(XYQWidth / 2 - XYQWidth / 6, XYQHeight / 15,
                                                                          XYQWidth / 3, XYQHeight / 4)];
    logoView.image = [UIImage imageNamed:@"Logo"];
    [self.view addSubview:logoView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(XYQWidth - XYQWidth / 5, XYQHeight / 28, XYQWidth / 8, XYQHeight / 20);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //二维码扫描按钮
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    scanButton.frame = CGRectMake(30, XYQHeight / 25, 26, 26);
    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    self.ipTextField = [[UITextField alloc] initWithFrame:CGRectMake(XYQWidth / 10, XYQHeight / 4 + XYQHeight / 15 + XYQHeight / 20,
                                                                     XYQWidth / 10 * 8, XYQHeight / 15)];
    self.ipTextField.backgroundColor = [UIColor whiteColor];
    self.ipTextField.delegate = self;
    self.ipTextField.placeholder = @"IP地址";
    self.ipTextField.text = @"172.20.1.198";
    self.ipTextField.textAlignment = NSTextAlignmentCenter;
    [self.ipTextField.layer setCornerRadius:5];
    self.ipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ipTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.ipTextField];
    
    self.portTextField = [[UITextField alloc] initWithFrame:CGRectMake(XYQWidth / 10, XYQHeight / 4 + XYQHeight / 15 * 3,
                                                                       XYQWidth / 10 * 8, XYQHeight / 15)];
    self.portTextField.backgroundColor = [UIColor whiteColor];
    self.portTextField.delegate = self;
    self.portTextField.placeholder = @"端口号";
    self.portTextField.text = @"10240";
    self.portTextField.textAlignment = NSTextAlignmentCenter;
    [self.portTextField.layer setCornerRadius:5];
    self.portTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.portTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.portTextField];
    
    self.connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.connectButton.frame = CGRectMake(XYQWidth / 2 - XYQWidth / 6, XYQHeight / 2 + XYQHeight / 15, XYQWidth / 3, XYQHeight / 15);
    self.connectButton.backgroundColor = [UIColor colorWithRed:96 / 255.0 green:149 / 255.0 blue:231 / 255.0 alpha:1];
    [self.connectButton.layer setCornerRadius:5];
    self.connectButton.tag = 65625;
    [self.connectButton setTitle:@"链接" forState:UIControlStateNormal];
    [self.connectButton setTintColor:[UIColor whiteColor]];
    [self.connectButton addTarget:self action:@selector(connectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.connectButton];
    
    //初始化缓冲控件
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.frame = CGRectMake(0, 0, XYQWidth / 6, XYQWidth / 6);
    self.activity.center = self.view.center;
    self.activity.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.activity];
}

#pragma mark ButtonAction
- (void)buttonAction {
    XYQSocketManager *socketManager = [XYQSocketManager socketManager];
    [socketManager.socketCmd cutOffServer];
    [socketManager.socketFile cutOffServer];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scanButtonAction {
    HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
    //调用此方法来获取二维码信息
    __weak typeof(self) weakSelf = self;
    
    [scan successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
        weakSelf.ipTextField.text = QRCodeInfo;
        XYQSocketManager *socketServer = [XYQSocketManager socketManager];
        socketServer.socketCmd.socketDelegate = self;
        [socketServer.socketCmd cutOffServer];
        [socketServer.socketFile cutOffServer];
        [socketServer.socketCmd startConnectedServer:weakSelf.ipTextField.text Port:[weakSelf.portTextField.text intValue]];
        [socketServer.socketFile startConnectedServer:weakSelf.ipTextField.text
                                                 Port:[weakSelf.portTextField.text intValue] + 1];
        weakSelf.connectButton.enabled = NO;
        [self.activity startAnimating];
    }];
    [self presentViewController:scan animated:YES completion:nil];
}

- (void)connectButton:(UIButton *)sender {
    
    if ([self.ipTextField.text isEqualToString:@""] || [self.portTextField.text isEqualToString:@""]) {
        [self showErrorMessage:@"IP地址或端口号为空"];
    } else {
        XYQSocketManager *socketServer = [XYQSocketManager socketManager];
        socketServer.socketCmd.socketDelegate = self;
        [socketServer.socketCmd cutOffServer];
        [socketServer.socketFile cutOffServer];
        [socketServer.socketCmd startConnectedServer:self.ipTextField.text Port:[self.portTextField.text intValue]];
        [socketServer.socketFile startConnectedServer:self.ipTextField.text
                                                 Port:[self.portTextField.text intValue] + 1];
        [self.activity startAnimating];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.ipTextField resignFirstResponder];
    [self.portTextField resignFirstResponder];
    return YES;
}

#pragma mark showMessage
- (void)showErrorMessage:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSucMessage:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark SocketCmdDelegate
- (void)getCmdDataMessage:(NSData *)data {
    
}

- (void)getCmdConnectionMessage:(NSString *)string {
    [self.activity stopAnimating];
    self.connectButton.enabled = YES;
    if ([string isEqualToString:@"链接服务器成功"]) {
        [self showSucMessage:string];
    } else {
        [self showErrorMessage:string];
    }
}

@end
