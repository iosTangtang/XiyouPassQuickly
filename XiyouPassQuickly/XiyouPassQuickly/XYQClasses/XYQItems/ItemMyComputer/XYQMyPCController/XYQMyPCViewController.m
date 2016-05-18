//
//  XYQMyPCViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQMyPCViewController.h"
#import "XYQSocketManager.h"
#import "XYQMyPCCollectionViewCell.h"
#import "XYQDiskModel.h"
#import "XYQCommomModel.h"
#import "XYQFileListViewController.h"
#import "XYQFileModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

static NSString *const kCollectionCellIdentifity = @"XYQMyPCCollectionViewCell";

@interface XYQMyPCViewController ()<SocketCmdDelegate, UICollectionViewDataSource, UICollectionViewDelegate,
                                    UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView   *activity;
@property (nonatomic, strong) NSMutableArray            *jsonArray;
@property (nonatomic, strong) UICollectionView          *collectionView;

@end

@implementation XYQMyPCViewController

#pragma mark - lazy load
- (NSMutableArray *)jsonArray {
    if (_jsonArray == nil) {
        _jsonArray = [NSMutableArray array];
    }
    return _jsonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的电脑";
    
    //添加背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XYQWidth, XYQHeight)];
    imageView.image = [UIImage imageNamed:@"Rectangle 1"];
    [self.view addSubview:imageView];
    
    [self p_initWithCollection];
    [self p_initWithView];
    [self p_sendMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private method
- (void)p_initWithCollection {
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, XYQWidth, XYQHeight - 64)
                                             collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[XYQMyPCCollectionViewCell class]
            forCellWithReuseIdentifier:kCollectionCellIdentifity];
}

- (void)p_initWithView {
    //初始化缓冲控件
    self.activity = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.frame = CGRectMake(0, 0, XYQWidth / 6, XYQWidth / 6);
    self.activity.center = self.view.center;
    self.activity.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.activity];
}

- (void)p_sendMessage {
    XYQSocketManager *socketServer = [XYQSocketManager socketManager];
    socketServer.socketCmd.socketDelegate = self;
    
    XYQDiskModel *disk = [[XYQDiskModel alloc] init];
    [disk setName:@"我的电脑" VolLable:@"我的电脑" FullName:@"我的电脑" FileTyp:nil];
    NSString *string = [disk toJSONString];
    XYQCommomModel *comm = [[XYQCommomModel alloc] initWithFlag:@"2" Msg:string];
    NSString *comStr = [comm toJSONString];
    
    NSString *sendStr = [NSString stringWithFormat:@"XiYou#%@", comStr];
    
    [socketServer.socketCmd sendMessage:sendStr];
    [self.activity startAnimating];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.jsonArray.count > 0 ? self.jsonArray.count + 2 : 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XYQMyPCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifity forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        cell.detailLabel.text = @"桌面";
        cell.diskLabel.text = @"Desktop";
    } else if (indexPath.row == 1) {
        cell.detailLabel.text = @"上传文件";
        cell.diskLabel.text = @"文件";
    } else {
        XYQDiskModel *dis = self.jsonArray[indexPath.row - 2];
        cell.detailLabel.text = [dis.Lable isEqualToString:@""] ? @"无" : dis.Lable;
        cell.diskLabel.text = dis.Name;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(XYQWidth / 2 - 25, XYQWidth / 2 - 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        XYQFileListViewController *fileVC = [[XYQFileListViewController alloc] init];
        fileVC.disk = [[XYQDiskModel alloc] init];
        fileVC.rootDisk = [[XYQChildDiskModel alloc] init];
        [fileVC.disk setName:nil VolLable:self.PPTOpera FullName:@"Desktop" FileTyp:nil];
        [fileVC.rootDisk setName:@"Desktop" VolLable:self.PPTOpera FullName:nil FileTyp:nil];
        [self.navigationController pushViewController:fileVC animated:YES];
        
    } else if (indexPath.row == 1) {
        [self upFile];
        
    } else {
        XYQFileListViewController *file = [[XYQFileListViewController alloc] init];
        XYQDiskModel *dis = self.jsonArray[indexPath.row - 2];
        file.disk = [[XYQDiskModel alloc] init];
        file.rootDisk = [[XYQChildDiskModel alloc] init];
        [file.disk setName:nil VolLable:self.PPTOpera FullName:dis.Name FileTyp:nil];
        [file.rootDisk setName:dis.Name VolLable:nil FullName:nil FileTyp:nil];
        [self.navigationController pushViewController:file animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark SocketCmdDelegate
- (void)getCmdDataMessage:(NSData *)data {
    
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string.length < 10) {
        return;
    }
    
    NSArray *codeArray = [string componentsSeparatedByString:@"#"];
    NSString *codeString = codeArray[1];
    
    codeString = [codeString substringWithRange:NSMakeRange(1, codeString.length - 3)];
    NSArray *jsonArray = [codeString componentsSeparatedByString:@"},"];
    
    for (int i = 0; i < jsonArray.count; i++) {
        NSString *temp = [jsonArray[i] stringByAppendingString:@"}"];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[temp dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingMutableContainers error:nil];
        XYQDiskModel *dis = [[XYQDiskModel alloc] init];
        [dis setName:[dic objectForKey:@"Name"]
            VolLable:[dic objectForKey:@"Lable"]
            FullName:[dic objectForKey:@"FullName"]
             FileTyp:[dic objectForKey:@"FileTyp"]];
        
        [self.jsonArray addObject:dis];
    }
    
    [self.activity stopAnimating];
    [self.collectionView reloadData];
    
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

#pragma mark - UpFileOperation
- (void)upFile {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选取照片"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *pikerAction = [UIAlertAction actionWithTitle:@"相册"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                            [self presentViewController:imagePicker animated:YES completion:NULL];
                                                        }];
    [alertC addAction:pikerAction];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"摄像头"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
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
            NSLog(@"%lu", (unsigned long)data.length);
            [socket.socketFile writeData:data withTimeout:WRITE_TIME_OUT tag:0];
            
        };
        
        ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showMessage:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
