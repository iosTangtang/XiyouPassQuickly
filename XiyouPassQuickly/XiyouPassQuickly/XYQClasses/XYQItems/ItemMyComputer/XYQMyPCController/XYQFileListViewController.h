//
//  XYQFileListViewController.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYQDiskModel.h"
#import "XYQChildDiskModel.h"

@interface XYQFileListViewController : UIViewController

@property (nonatomic, strong) XYQDiskModel          *disk;
@property (nonatomic, strong) XYQChildDiskModel     *rootDisk;

@end
