//
//  XYQChildDiskModel.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQDiskModel.h"

@interface XYQChildDiskModel : XYQDiskModel

@property (nonatomic, strong) NSMutableArray <XYQDiskModel *>    *childDisk;

- (void)addDisk:(XYQDiskModel *)disk;

@end
