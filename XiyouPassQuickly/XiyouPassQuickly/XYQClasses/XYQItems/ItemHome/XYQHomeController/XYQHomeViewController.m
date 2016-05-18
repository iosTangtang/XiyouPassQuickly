//
//  XYQHomeViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/17.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQHomeViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "XYQSideViewController.h"
#import "XYQSocketManager.h"
#import "XYQMyPCViewController.h"
#import "XYQCtrPCViewController.h"
#import "XYQHandleModel.h"
#import "XYQCommomModel.h"
#import "XYQConServerViewController.h"
#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"
#import "BDRecognizerViewParamsObject.h"
#import "BDVRSConfig.h"

@interface XYQHomeViewController ()<BDRecognizerViewDelegate>

@property (nonatomic, strong) XYQSocketManager              *socketManager;
@property (nonatomic, copy)   NSDictionary                  *typDic;
@property (nonatomic, copy)   NSDictionary                  *msgDic;
@property (nonatomic, strong) BDRecognizerViewController    *recognizerViewController;
@property (nonatomic, copy)   NSDictionary                  *voiceDic;

@end

@implementation XYQHomeViewController

#pragma mark - 懒加载
- (NSDictionary *)typDic {
    if (!_typDic) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"CMDPlist2" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        _typDic = [[NSDictionary alloc] initWithDictionary:array[0]];
    }
    
    return _typDic;
}

- (NSDictionary *)msgDic {
    if (!_msgDic) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"CMDPlist2" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        _msgDic = [[NSDictionary alloc] initWithDictionary:array[1]];
    }
    
    return _msgDic;
}

- (NSDictionary *)voiceDic {
    if (_voiceDic == nil) {
        _voiceDic = @{@"$name_CORE" : @"打开c盘\n打开d盘\n打开e盘\n打开f盘\n打开桌面文件\n关闭ｐｐｔ\n上一页ｐｐｔ\n下一页ｐｐｔ\n打开画图\n打开计算器\n关闭任务管理器\n关闭资源管理器\n关闭设备管理器\n关闭ｉｅ浏览器\n关闭控制面板",
                      @"$song_CORE" : @"截屏\n注销\n关机\n休眠\n重启\n增大音量\n减小音量\n打开记事本\n打开命令提示符\n打开写字板\n打开远程桌面连接\n打开运行\n打开任务管理器\n打开资源管理器\n打开设备管理器\n打开ｉｅ浏览器\n打开注册表\n打开控制面板\n",
                      @"$app_CORE" : @"打开腾讯微博\n打开京东\n打开天猫\n打开腾讯网\n打开搜狐\n打开新浪微博\n打开新浪\n打开淘宝\n打开谷歌\n打开百度\n关闭画图\n关闭计算器\n关闭记事本\n关闭录音机\n关闭命令提示符\n关闭写字板\n关闭远程桌面连接\n关闭运行\n",
                      @"$artist_CORE" : @"播放ｐｐｔ\n放映幻灯片\n关闭ｅｘｃｅｌ\n关闭ｗｏｒｄ\n打开ｅｘｃｅｌ\n打开ｐｐｔ\n打开ｗｏｒｄ\n最后一页\n第一页\n"};
    }
    return _voiceDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.socketManager = [XYQSocketManager socketManager];
    [self.socketManager initSocket];
    
    [self p_initView];
    [self p_initNavItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
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
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.topItem.title = @"我的快传";
    //设置Navigation上主题字的颜色
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:122 / 255.0 green:124 / 255.0 blue:140 / 255.0 alpha:1],
                                NSForegroundColorAttributeName,
                                [UIFont fontWithName:@"Avenir Next Condensed" size:XYQWidth / 24], NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    //底部的View
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, XYQHeight - XYQHeight / 8, XYQWidth, XYQHeight / 8)];
    [backView setUserInteractionEnabled:YES];
    backView.image = [UIImage imageNamed:@"Path 1"];
    [self.view addSubview:backView];
    
    UIButton *myComputerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myComputerButton.frame = CGRectMake(XYQWidth / 6, XYQHeight / 24, XYQWidth / 7, XYQHeight / 16);
    [myComputerButton setBackgroundImage:[UIImage imageNamed:@"myComputer"] forState:UIControlStateNormal];
    [myComputerButton addTarget:self action:@selector(MyComButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:myComputerButton];
    
    UIButton *controlCompuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    controlCompuButton.frame = CGRectMake(XYQWidth / 2 + XYQWidth / 5, XYQHeight / 24, XYQWidth / 7, XYQHeight / 16);
    [controlCompuButton setBackgroundImage:[UIImage imageNamed:@"controlComputer"] forState:UIControlStateNormal];
    [controlCompuButton addTarget:self action:@selector(ControlButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:controlCompuButton];
    
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    voiceButton.frame = CGRectMake(XYQWidth / 2 - XYQWidth / 8, XYQHeight - XYQWidth / 3, XYQWidth / 4, XYQWidth / 4);
    UIImageView *connectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XYQWidth / 4, XYQWidth / 4)];
    connectView.image = [UIImage imageNamed:@"Voice"];
    [voiceButton addSubview:connectView];
    [voiceButton.layer setCornerRadius:XYQWidth / 8];
    [voiceButton addTarget:self action:@selector(VoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voiceButton];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(XYQWidth / 2 - XYQWidth / 6, XYQHeight / 4,
                                                                          XYQWidth / 3, XYQHeight / 4)];
    logoView.image = [UIImage imageNamed:@"Logo"];
    [self.view addSubview:logoView];
    
    //注册链接中断通知
    NSNotificationCenter *connectionFailed = [NSNotificationCenter defaultCenter];
    [connectionFailed addObserver:self selector:@selector(ConnectionFailed:) name:@"ConnectionFailed" object:nil];
}

- (void)p_initNavItem {
    //导航栏上用来显示侧边栏的button
    MMDrawerBarButtonItem *leftButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(listButtonAction:)];
    [leftButton setTintColor:[UIColor grayColor]];
    [self.navigationItem setLeftBarButtonItem:leftButton animated:YES];
}

#pragma mark - ButtonAction
- (void) MyComButtonAction:(UIButton *)sender {
    if (![self.socketManager.socketCmd isConnected]) {
        [self showMessage:@"还未链接服务器"];
        return;
    }
    
    XYQMyPCViewController *myVC = [[XYQMyPCViewController alloc] init];
    myVC.PPTOpera = @"PPTSHOW";
    [self.navigationController pushViewController:myVC animated:YES];
}

- (void)ControlButtonAction:(UIButton *)sender {
    if (![self.socketManager.socketCmd isConnected]) {
        [self showMessage:@"还未链接服务器"];
        return;
    }
    XYQCtrPCViewController *conVC = [[XYQCtrPCViewController alloc] init];
    [self.navigationController pushViewController:conVC animated:YES];
    
}

- (void) VoiceButtonAction:(UIButton *)sender {
//    if (![self.socketManager.socketCmd isConnected]) {
//        [self showMessage:@"还未链接服务器"];
//        return;
//    }
    [self initWithVoice];
}

- (void)listButtonAction:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - 链接断开通知
- (void)ConnectionFailed:(id)sender {
    [self showMessage:@"与服务器断开链接，请重新链接！"];
}

#pragma mark ShowMessage
- (void)showMessage:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)initWithVoice {
    BDRecognizerViewController *bdReVC = [[BDRecognizerViewController alloc] initWithOrigin:CGPointMake(9, 128)
                                                                                  withTheme:[BDVRSConfig sharedInstance].theme];
    bdReVC.enableFullScreenMode = YES;
    bdReVC.delegate = self;
    self.recognizerViewController = bdReVC;
    
    BDRecognizerViewParamsObject *paramObj = [[BDRecognizerViewParamsObject alloc] init];
    paramObj.apiKey = APIKEY;
    paramObj.secretKey = SECRETKEY;
    paramObj.appCode = APPID;
    
    // 设置是否需要语义理解，只在搜索模式有效
    paramObj.isNeedNLU = [BDVRSConfig sharedInstance].isNeedNLU;
    
    // 设置识别语言
    paramObj.language = [BDVRSConfig sharedInstance].recognitionLanguage;
    
    // 设置识别模式，分为搜索和输入
    paramObj.recogPropList = @[[BDVRSConfig sharedInstance].recognitionProperty];
    
    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
    paramObj.cityID = 1;
    
    //设置禁用标点
    paramObj.disablePuncs = YES;
    
    // 开启联系人识别
    //    paramsObject.enableContacts = YES;
    
    // 设置显示效果，是否开启连续上屏
    paramObj.resultShowMode = BDRecognizerResultShowModeContinuousShow;
    
    // 设置提示音开关，是否打开，默认打开
    paramObj.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
    
    paramObj.isShowTipAfter3sSilence = YES;
    paramObj.isShowHelpButtonWhenSilence = YES;
    paramObj.tipsTitle = @"您可以说";
    paramObj.tipsList = [NSArray arrayWithObjects:@"打开PPT", @"打开Word", @"打开百度", @"打开新浪微博", @"打开任务管理器", nil];
    
    paramObj.licenseFilePath= [[NSBundle mainBundle] pathForResource:@"temp_license_2016-05-18" ofType:nil];
    paramObj.datFilePath = [[NSBundle mainBundle] pathForResource:@"s_1" ofType:@""];
    if ([[BDVRSConfig sharedInstance].recognitionProperty intValue] == EVoiceRecognitionPropertyMap) {
        paramObj.LMDatFilePath = [[NSBundle mainBundle] pathForResource:@"s_2_Navi" ofType:@""];
    } else if ([[BDVRSConfig sharedInstance].recognitionProperty intValue] == EVoiceRecognitionPropertyInput) {
        paramObj.LMDatFilePath = [[NSBundle mainBundle] pathForResource:@"s_2_InputMethod" ofType:@""];
    }
    
    paramObj.recogGrammSlot = self.voiceDic;
    
    [_recognizerViewController startWithParams:paramObj];
}

#pragma mark - BDRecognizerViewDelegate
- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerViewController withResults:(NSArray *)aResults{
    NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aResults];
    NSLog(@"%@", tmpString);
    [self sendJson:tmpString];
    [_recognizerViewController removeFromParentViewController];
    _recognizerViewController = nil;
}

#pragma mark - json格式发送
- (void)sendJson:(NSString *)string {
    NSArray *source = [string componentsSeparatedByString:@"]"];
    NSString *sourceStr = nil;
    if (source.count > 1) {
        sourceStr = source[1];
    } else {
        sourceStr = source[0];
    }
    
    NSString *typStr = [self.typDic objectForKey:sourceStr];
    NSString *msgStr = [self.msgDic objectForKey:sourceStr];

    XYQHandleModel *handle = [[XYQHandleModel alloc] init];
    
    if (typStr == nil || msgStr == nil) {
        [handle setTyp:@"Search" Msg:[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@", sourceStr]];
    } else {
        [handle setTyp:typStr Msg:msgStr];
    }
    NSString *resultStr = [handle toJSONString];
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"1" Msg:resultStr];
    NSString *comStr = [comm toJSONString];
    NSString *jsonStr = [NSString stringWithFormat:@"XiYou#%@",comStr];
    
    [self.socketManager.socketCmd sendMessage:jsonStr];
}

@end
