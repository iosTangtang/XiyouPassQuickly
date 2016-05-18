//
//  XYQSideViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQSideViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "XYQSideTableViewCell.h"
#import "XYQConServerViewController.h"
#import "XYQHandleModel.h"
#import "XYQCommomModel.h"
#import "XYQSocketManager.h"
#import "XYQFileModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

static NSString *const cellIdentifity = @"XYQSideViewCell";

@interface XYQSideViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, copy)   NSArray               *arrayWithSide;
@property (nonatomic, strong) XYQSocketManager      *socketManager;

@end

@implementation XYQSideViewController

#pragma mark - lazyLoad
- (NSArray *)arrayWithSide {
    if (_arrayWithSide == nil) {
        _arrayWithSide = @[@"下载管理", @"上传文件", @"设置", @"反馈", @"关于我们"];
    }
    return _arrayWithSide;
}

- (XYQSocketManager *)socketManager {
    if (_socketManager == nil) {
        _socketManager = [XYQSocketManager socketManager];
        [_socketManager initSocket];
    }
    return _socketManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:43.0 / 255 green:43.0 / 255 blue:49.0 / 255 alpha:1];
    
    [self p_initTableView];
    [self p_initWithView];
}

#pragma mark - private method
- (void)p_initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, XYQHeight / 6,
                                                                   LEFTSIDE_WIDTH, XYQHeight / 2)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[XYQSideTableViewCell class] forCellReuseIdentifier:cellIdentifity];
}

- (void)p_initWithView {
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(XYQWidth / 6, XYQHeight / 2 + XYQHeight / 8,
                                                                          XYQWidth / 3, XYQHeight / 4)];
    logoView.image = [UIImage imageNamed:@"Logo"];
    [self.view addSubview:logoView];
    
    UIImageView *computer = [[UIImageView alloc] initWithFrame:CGRectMake(XYQWidth / 15, XYQHeight / 26, XYQWidth / 6, XYQWidth / 6)];
    computer.image = [UIImage imageNamed:@"computer"];
    [self.view addSubview:computer];
    
    UIButton *connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    connectButton.frame = CGRectMake(LEFTSIDE_WIDTH - XYQWidth / 3, XYQHeight / 16, XYQWidth / 6, XYQHeight / 20);
    [connectButton setTitle:@"链接" forState:UIControlStateNormal];
    [connectButton setTintColor:[UIColor whiteColor]];
    [connectButton setBackgroundColor:[UIColor darkGrayColor]];
    [connectButton.layer setCornerRadius:4];
    [connectButton addTarget:self action:@selector(connectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectButton];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYQSideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
    
    NSDictionary *dic = @{ @"cellText" : self.arrayWithSide[indexPath.row] };
    [cell congigItemMessages:dic];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return XYQHeight / 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if (indexPath.row != 1) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            NSLog(@"%ld", (long)indexPath.row);
        }];
    } else {
        XYQSocketManager *socket = [XYQSocketManager socketManager];
        if ([socket.socketFile isConnected]) {
            [self upFile];
        } else {
            [self showMessage:@"还未连接服务器"];
        }
    }
    
}

#pragma mark CutButtonAction
- (void)connectButtonAction {
     __weak typeof(self) weakSelf = self;
    
    if ([self.socketManager.socketCmd isConnected] || [self.socketManager.socketFile isConnected]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前已在线，是否更换网络？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            XYQHandleModel *handle = [[XYQHandleModel alloc] init];
            [handle setTyp:@"Cmd" Msg:@"DisConnect"];
            NSString *string = [handle toJSONString];
            XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"1" Msg:string];
            NSString *comStr = [comm toJSONString];
            
            NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
            
            [weakSelf.socketManager.socketCmd sendMessage:sendStr];
            
            [weakSelf.socketManager.socketCmd cutOffServer];
            [weakSelf.socketManager.socketFile cutOffServer];
            XYQConServerViewController *conSevVC = [[XYQConServerViewController alloc] init];
            [weakSelf presentViewController:conSevVC animated:YES completion:nil];
        }];
        [alert addAction:yesAction];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:noAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        XYQConServerViewController *conSevVC = [[XYQConServerViewController alloc] init];
        [self presentViewController:conSevVC animated:YES completion:nil];
    }
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
   
}

#pragma mark - UpFileOperation
- (void)upFile {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选取照片"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *pikerAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }];
    [alertC addAction:pikerAction];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (isCamera) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else{
            NSLog(@"没有摄像头");
        }
    }];
    [alertC addAction:cameraAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    __block NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        int nameNumber = arc4random() % 10000000;
        NSString *fileName = [NSString stringWithFormat:@"%d.JPG", nameNumber];
        XYQFileModel *file = [[XYQFileModel alloc] init];
        [file setSize:[imageData length]
                 Name:fileName Type:@"FileUpload" Msg:nil];
        NSString *string = [file toJSONString];
        
        XYQSocketManager *socket = [XYQSocketManager socketManager];
        [socket.socketFile sendMessage:string];
        
        int size = [imageData length];
        int send = size / 5;
        
        Byte *byte = (Byte *)[imageData bytes];
        Byte lengthByte[send];
        
        int i = 0;
        while (size > send) {
            memcpy(&lengthByte, &byte[i * send], send);
            NSData *data = [NSData dataWithBytes:&lengthByte length:send];
            [socket.socketFile writeData:data withTimeout:WRITE_TIME_OUT tag:0];
            size = size - send;
            i++;
        }
        
        Byte lastByte[size];
        memcpy(&lastByte, &byte[i * send], size);
        NSData *data = [NSData dataWithBytes:&lastByte length:size];
        [socket.socketFile writeData:data withTimeout:WRITE_TIME_OUT tag:0];
        
    } else {
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            
            XYQFileModel *file = [[XYQFileModel alloc] init];
            [file setSize:[imageData length]
                     Name:fileName Type:@"FileUpload" Msg:nil];
            NSString *string = [file toJSONString];
            
            int size = [imageData length];
            int send = size / 5;
            
            XYQSocketManager *socket = [XYQSocketManager socketManager];
            [socket.socketFile sendMessage:string];
            
            Byte *byte = (Byte *)[imageData bytes];
            Byte lengthByte[send];
            
            int i = 0;
            while (size > send) {
                memcpy(&lengthByte, &byte[i * send], send);
                NSData *data = [NSData dataWithBytes:&lengthByte length:send];
                [socket.socketFile writeData:data withTimeout:WRITE_TIME_OUT tag:0];
                size = size - send;
                i++;
            }
            
            Byte lastByte[size];
            memcpy(&lastByte, &byte[i * send], size);
            NSData *data = [NSData dataWithBytes:&lastByte length:size];
            [socket.socketFile writeData:data withTimeout:WRITE_TIME_OUT tag:0];
            
        };
        
        ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - show message
- (void)showMessage:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
