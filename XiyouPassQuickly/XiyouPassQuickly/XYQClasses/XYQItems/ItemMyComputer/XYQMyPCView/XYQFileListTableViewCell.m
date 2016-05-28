//
//  XYQFileListTableViewCell.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQFileListTableViewCell.h"
#import "XYQFileListViewController.h"

@interface XYQFileListTableViewCell ()

@property (nonatomic, strong) UILabel           *label;
@property (nonatomic, strong) UIImageView       *fileImageView;
@property (nonatomic, strong) UIButton          *button;
@property (nonatomic, strong) UIButton          *downLoadButton;

@end

@implementation XYQFileListTableViewCell

- (void)initView {
    
    self.fileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XYQWidth / 20,
                                                                       self.contentView.frame.size.height / 10 * 2,
                                                                       self.contentView.frame.size.height / 10 * 6,
                                                                       self.contentView.frame.size.height / 10 * 6)];
    
    [self.contentView addSubview:self.fileImageView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(XYQWidth / 20 + self.contentView.frame.size.height / 10 * 8 + 10,
                                                           XYQHeight / 24 - XYQHeight / 40,
                                                           XYQWidth / 4 * 3,
                                                           XYQHeight / 60 * 2)];
    self.label.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.label];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XYQWidth, self.contentView.frame.size.height)];
    [self.button addTarget:self
                    action:@selector(buttonEvent)
          forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button];
    
    self.downLoadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.downLoadButton.frame = CGRectMake(self.contentView.frame.size.width -
                                           self.contentView.frame.size.height / 10 * 6 - 10,
                                           self.contentView.frame.size.height / 10 * 1,
                                           self.contentView.frame.size.height / 10 * 6,
                                           self.contentView.frame.size.height / 10 * 6);
//    self.downLoadButton.backgroundColor = [UIColor redColor];
    [self.downLoadButton setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [self.downLoadButton addTarget:self action:@selector(downLoadButtonEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.downLoadButton];
}

- (void)loadContent {
    
    XYQDiskModel *dis = self.data;
    self.label.text = dis.Name;
    
    if ([dis.Lable isEqualToString:@"PPTDO"]) {
        [self.downLoadButton removeFromSuperview];
    }
    
    if ([dis.FileTyp isEqualToString:@"Directory"]) {
        self.fileImageView.image = [UIImage imageNamed:@"Folder"];
        [self.downLoadButton removeFromSuperview];
    } else {
        NSRange rang = [dis.Name rangeOfString:@"." options:NSBackwardsSearch];
        
        NSString *last = nil;
        
        if (rang.location != NSNotFound) {
            last = [dis.Name substringFromIndex:rang.location];
        }
        
        if ([last isEqualToString:@".mp3"] || [last isEqualToString:@".mp4"] || [last isEqualToString:@".avi"]) {
            self.fileImageView.image = [UIImage imageNamed:@"fa-file-video-o"];
        } else if ([last isEqualToString:@".pdf"]) {
            self.fileImageView.image = [UIImage imageNamed:@"fa-file-pdf-o"];
        } else if ([last isEqualToString:@".ppt"] || [last isEqualToString:@".pptx"]) {
            self.fileImageView.image = [UIImage imageNamed:@"fa-file-powerpoint-o"];
        } else if ([last isEqualToString:@".zip"] || [last isEqualToString:@".tar"] || [last isEqualToString:@".rar"]) {
            self.fileImageView.image = [UIImage imageNamed:@"fa-file-archive-o"];
        } else if ([last isEqualToString:@".jpg"] || [last isEqualToString:@".png"] || [last isEqualToString:@".JPG"]
                   || [last isEqualToString:@".jepg"] || [last isEqualToString:@".PNG"]) {
            self.fileImageView.image = [UIImage imageNamed:@"fa-file-image-o"];
        } else {
            self.fileImageView.image = [UIImage imageNamed:@"file"];
        }
        
    }
    
}


- (void)buttonEvent {
    
    XYQChildDiskModel *dis = self.data;
    
    if ([dis.FileTyp isEqualToString:@"Directory"]) {
        XYQFileListViewController *fvc = [[XYQFileListViewController alloc] init];
        fvc.rootDisk = dis;
        XYQDiskModel *disOp = [[XYQDiskModel alloc] init];
        [disOp setName:dis.Name VolLable:dis.Lable FullName:dis.FullName FileTyp:dis.FileTyp];
        fvc.disk = disOp;
        [self.controller.navigationController pushViewController:fvc animated:YES];
    } else if ([dis.FileTyp isEqualToString:@"Archive"]) {
        XYQDiskModel *disOp = [[XYQDiskModel alloc] init];
        [disOp setName:nil VolLable:dis.Lable FullName:dis.FullName FileTyp:dis.FileTyp];
        [self.cellDelegate getFileMessage:disOp];
    }
    
}

- (void)downLoadButtonEvent:(UIButton *)sender {
    XYQChildDiskModel *dis = self.data;
    [self.cellDelegate downFileMessage:dis];
}

@end
