//
//  XYQTouchPadViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQTouchPadViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "XYQSignalModel.h"
#import "XYQSocketManager.h"
#import "XYQCommomModel.h"

@interface XYQTouchPadViewController ()<SocketCmdDelegate>

@property (nonatomic, strong) UIView            *touchView;
@property (nonatomic, assign) CGPoint           location;
@property (nonatomic, assign) CGPoint           doubleLocation;
@property (nonatomic, strong) XYQSignalModel    *model;
@property (nonatomic, strong) XYQSocketManager  *socketServer;

@end

@implementation XYQTouchPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initView];
    [self p_initWithTouchPad];
    [self p_initWithGresture];
    
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
    
    self.socketServer = [XYQSocketManager socketManager];
    self.socketServer.socketCmd.socketDelegate = self;
    
    self.title = @"遥控器";
    self.model = [[XYQSignalModel alloc] init];
}

- (void)p_initWithTouchPad {
    self.touchView = [[UIView alloc] initWithFrame:CGRectMake(XYQWidth / 20, XYQHeight / 6, XYQWidth / 20 * 18, XYQHeight / 1.5)];
    self.touchView.backgroundColor = [UIColor colorWithRed:120 / 255.0 green:115 / 255.0 blue:115 / 255.0 alpha:1];
    [self.touchView.layer setCornerRadius:6];
    [self.touchView.layer setBorderWidth:3];
    [self.touchView.layer setBorderColor:[UIColor colorWithRed:151 / 255.0 green:151 / 255.0
                                                          blue:151 / 255.0 alpha:1].CGColor];
    [self.view addSubview:self.touchView];
    
    UIButton *leftClickButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftClickButton.frame = CGRectMake(XYQWidth / 20, XYQHeight / 6 + XYQHeight / 1.5, XYQWidth / 20 * 9, XYQHeight / 12);
    leftClickButton.backgroundColor = [UIColor colorWithRed:120 / 255.0 green:115 / 255.0 blue:115 / 255.0 alpha:1];
    [leftClickButton.layer setCornerRadius:5];
    [leftClickButton.layer setBorderWidth:3];
    [leftClickButton.layer setBorderColor:[UIColor colorWithRed:151 / 255.0 green:151 / 255.0
                                                           blue:151 / 255.0 alpha:1].CGColor];
    [leftClickButton setTitle:@"左键" forState:UIControlStateNormal];
    [leftClickButton setTintColor:[UIColor whiteColor]];
    [leftClickButton addTarget:self action:@selector(leftClickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftClickButton];
    
    UIButton *rightClickButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightClickButton.frame = CGRectMake(XYQWidth - XYQWidth / 20 - XYQWidth / 20 * 9, XYQHeight / 6 + XYQHeight / 1.5,
                                        XYQWidth / 20 * 9, XYQHeight / 12);
    rightClickButton.backgroundColor = [UIColor colorWithRed:120 / 255.0 green:115 / 255.0 blue:115 / 255.0 alpha:1];
    [rightClickButton.layer setCornerRadius:5];
    [rightClickButton.layer setBorderWidth:3];
    [rightClickButton.layer setBorderColor:[UIColor colorWithRed:151 / 255.0 green:151 / 255.0
                                                            blue:151 / 255.0 alpha:1].CGColor];
    [rightClickButton setTitle:@"右键" forState:UIControlStateNormal];
    [rightClickButton setTintColor:[UIColor whiteColor]];
    [rightClickButton addTarget:self action:@selector(rightClickButtonAction)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightClickButton];
}

- (void)p_initWithGresture {
    //单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(leftClickButtonAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.touchView addGestureRecognizer:singleTap];
    
    //双指单击手势
    UITapGestureRecognizer *douFingleTap = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(rightClickButtonAction)];
    douFingleTap.numberOfTapsRequired = 1;
    douFingleTap.numberOfTouchesRequired = 2;
    [self.touchView addGestureRecognizer:douFingleTap];
    
    //捏合手势
    UIPinchGestureRecognizer *pinGresture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handlePich:)];
    [self.touchView addGestureRecognizer:pinGresture];
    
    //拖动手势
    UIPanGestureRecognizer *panGresture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTap:)];
    panGresture.minimumNumberOfTouches = 1;
    panGresture.maximumNumberOfTouches = 1;
    [self.touchView addGestureRecognizer:panGresture];
    
    //双指拖动手势
    UIPanGestureRecognizer *doublePanTap = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(doublePanTap:)];
    doublePanTap.minimumNumberOfTouches = 2;
    doublePanTap.maximumNumberOfTouches = 2;
    [self.touchView addGestureRecognizer:doublePanTap];
}

#pragma mark - ClickButtonAction
- (void)leftClickButtonAction {
    
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"3" Msg:@"0,0,Left,"];
    NSString *sendStr = [comm toJSONString];
    NSString *comStr = [NSString stringWithFormat:@"XiYou#%@",sendStr];
    [self.socketServer.socketCmd sendMessage:comStr];
}

- (void)rightClickButtonAction {
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"3" Msg:@"0,0,Right,"];
    NSString *sendStr = [comm toJSONString];
    NSString *comStr = [NSString stringWithFormat:@"XiYou#%@",sendStr];
    [self.socketServer.socketCmd sendMessage:comStr];
}

#pragma mark - 手势监测函数
static float scale = 0;
- (void)handlePich:(UIPinchGestureRecognizer *)pinGresture {
    NSString *operate = nil;
    
    if (pinGresture.state == UIGestureRecognizerStateBegan) {
        scale = pinGresture.scale;
    } else if (pinGresture.state == UIGestureRecognizerStateEnded) {
        if (scale - pinGresture.scale < 0) {
            operate = @"Big";
        } else {
            operate = @"Small";
        }
        
        XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"3" Msg:[NSString stringWithFormat:@"0,0,%@,",operate]];
        NSString *sendStr = [comm toJSONString];
        NSString *comStr = [NSString stringWithFormat:@"XiYou#%@",sendStr];
        [self.socketServer.socketCmd sendMessage:comStr];
    }
}

- (void)panTap:(UIPanGestureRecognizer *)panGesture {
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.location = [panGesture locationInView:panGesture.view.superview];
    }
    CGPoint afterLocation = [panGesture locationInView:panGesture.view.superview];
    
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"3" Msg:[NSString stringWithFormat:@"%f,%f,%@,",
                                                              afterLocation.x - self.location.x,
                                                              afterLocation.y - self.location.y,
                                                              @"Move"]];
    NSString *sendStr = [comm toJSONString];
    NSString *comStr = [NSString stringWithFormat:@"XiYou#%@",sendStr];
    
    NSLog(@"%@", comStr);
    [self.socketServer.socketCmd sendMessage:comStr];
}

- (void)doublePanTap:(UIPanGestureRecognizer *)doublePanTap {
    if (doublePanTap.state == UIGestureRecognizerStateBegan) {
        self.doubleLocation = [doublePanTap locationInView:doublePanTap.view.superview];
    } else if (doublePanTap.state == UIGestureRecognizerStateEnded) {
        CGPoint afterLocation = [doublePanTap locationInView:doublePanTap.view.superview];
        if (afterLocation.y - self.doubleLocation.y > 0) {
            XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"3" Msg:@"0,0,WheelDown,"];
            NSString *sendStr = [comm toJSONString];
            NSString *comStr = [NSString stringWithFormat:@"XiYou#%@",sendStr];
            
            [self.socketServer.socketCmd sendMessage:comStr];
        } else if(afterLocation.y - self.doubleLocation.y < 0){
            XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"3" Msg:@"0,0,WheelUp,"];
            NSString *sendStr = [comm toJSONString];
            NSString *comStr = [NSString stringWithFormat:@"XiYou#%@",sendStr];
            
            [self.socketServer.socketCmd sendMessage:comStr];
        }
    }
}

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
