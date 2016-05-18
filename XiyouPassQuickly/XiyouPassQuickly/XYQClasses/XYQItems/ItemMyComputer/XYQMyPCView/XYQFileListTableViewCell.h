//
//  XYQFileListTableViewCell.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileTableViewCellDelegate <NSObject>

@required
- (void)getFileMessage:(id)sender;
- (void)downFileMessage:(id)sender;

@end

@interface XYQFileListTableViewCell : UITableViewCell

@property (nonatomic, weak) id                              data;
@property (nonatomic, weak) id<FileTableViewCellDelegate>   cellDelegate;
@property (nonatomic, weak) UITableView                     *tableView;
@property (nonatomic, weak) UIViewController                *controller;

- (void)initView;

- (void)loadContent;

@end
