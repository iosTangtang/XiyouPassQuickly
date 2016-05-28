//
//  XYQFileListViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQFileListViewController.h"
#import "XYQFileListTableViewCell.h"
#import "XYQSocketManager.h"
#import "XYQCommomModel.h"
#import "XYQDownFileViewController.h"

static NSString *const kFileListTableViewCell = @"XYQFileListTableViewCell.h";

@interface XYQFileListViewController ()<UITableViewDelegate, UITableViewDataSource, SocketCmdDelegate,
                                        FileTableViewCellDelegate, SocketFileDelegate>{
    int _icount;
    int _length;
}

@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) NSMutableArray            *jsonArray;
@property (nonatomic, strong) UIActivityIndicatorView   *activity;
@property (nonatomic, assign) BOOL                      haveFolder;
@property (nonatomic, strong) NSMutableData             *muData;

@end

@implementation XYQFileListViewController

#pragma mark lazy load
- (NSMutableArray *)jsonArray {
    if (_jsonArray == nil) {
        _jsonArray = [NSMutableArray array];
    }
    return _jsonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.haveFolder = YES;
    _icount = 0;
    self.muData = [NSMutableData data];
    
    self.title = self.rootDisk.Name;
    
    [self p_initWithActivity];
    [self p_sendMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pravite method
- (void)p_initWithTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XYQWidth, XYQHeight - 64)
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[XYQFileListTableViewCell class] forCellReuseIdentifier:kFileListTableViewCell];
}

- (void)p_initWithActivity {
    //初始化缓冲控件
    self.activity = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.frame = CGRectMake(0, 0, XYQWidth / 6, XYQWidth / 6);
    self.activity.center = self.view.center;
    self.activity.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.activity];
}

- (void)p_sendMessage {
    XYQSocketManager *socketManager = [XYQSocketManager socketManager];
    socketManager.socketCmd.socketDelegate = self;
    
    NSString *string = [self.disk toJSONString];
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"2" Msg:string];
    NSString *comStr = [comm toJSONString];
    
    NSString *sendStr = [[NSString alloc] initWithFormat:@"XiYou#%@", comStr];
    
    [self.activity startAnimating];
    [socketManager.socketCmd sendMessage:sendStr];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rootDisk.childDisk.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XYQFileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFileListTableViewCell];
    while ([[cell.contentView subviews] lastObject] != nil) {
        [[[cell.contentView subviews] lastObject] removeFromSuperview];
    }
    
    [cell initView];
    cell.tableView = tableView;
    cell.controller = self;
    cell.cellDelegate = self;
    cell.data = self.rootDisk.childDisk[indexPath.row];
    
    [cell loadContent];
    
    return cell;
}

#pragma mark - tableView的刷新及数据解析
- (void)reloadData {
    if (self.haveFolder == NO) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(XYQWidth / 4, XYQHeight / 6,
                                                                           XYQWidth / 2, XYQHeight / 3)];
        image.image = [UIImage imageNamed:@"Cry"];
        [self.view addSubview:image];
    } else {
        [self p_initWithTableView];
    }
}

- (void)getTableViewMessage {
    Byte *byte = (Byte *)[self.muData bytes];
    NSString *string = [[NSString alloc] initWithBytes:byte length:self.muData.length encoding:NSUTF8StringEncoding];
    
    NSArray *codeArray = [string componentsSeparatedByString:@"#"];
    NSString *codeString = codeArray[1];
    
    self.rootDisk.childDisk = [NSMutableArray array];
    
    if (codeString.length < 3 && codeString != nil) {
        self.haveFolder = NO;
    } else {
        codeString = [codeString substringWithRange:NSMakeRange(1, codeString.length - 3)];
        NSArray *jsonArray = [codeString componentsSeparatedByString:@"},"];
        
        for (int i = 0; i < jsonArray.count; i++) {
            NSString *temp = [jsonArray[i] stringByAppendingString:@"}"];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingMutableContainers error:nil];
            XYQChildDiskModel *dis = [[XYQChildDiskModel alloc] init];
            [dis setName:[dic objectForKey:@"Name"]
                VolLable:[dic objectForKey:@"Lable"]
                FullName:[dic objectForKey:@"FullName"]
                 FileTyp:[dic objectForKey:@"FileTyp"]];
            
            [self.rootDisk addDisk:dis];
        }
    }
    
    [self.activity stopAnimating];
    [self reloadData];
}

#pragma mark SocketDiskDelegate
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
            [self getTableViewMessage];
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

#pragma mark - FileTableViewCellDelegate
- (void)getFileMessage:(id)sender {
    
    NSString *jsonStr = [sender toJSONString];
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"2" Msg:jsonStr];
    NSString *sendStr = [comm toJSONString];
    NSString *jsonFile = [NSString stringWithFormat:@"XiYou#%@", sendStr];
    
    XYQSocketManager *socketServer = [XYQSocketManager socketManager];
    socketServer.socketFile.fileDelegate = self;
    [socketServer.socketCmd sendMessage:jsonFile];
    XYQDiskModel *dis = (XYQDiskModel *)sender;
    if ([dis.Lable isEqualToString:@"PPTDO"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)downFileMessage:(id)sender {
    XYQDownFileViewController *down = [[XYQDownFileViewController alloc] init];
    [self presentViewController:down animated:YES completion:^{
        NSNotification *center = [NSNotification notificationWithName:@"Down" object:nil userInfo:sender];
        [[NSNotificationCenter defaultCenter] postNotification:center];
    }];
}

#pragma mark - SocketFileDelegate
- (void)getFileDataMessage:(NSData *)data {
    
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

@end
