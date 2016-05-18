//
//  XYQSignalModel.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "JSONModel.h"

@interface XYQSignalModel : JSONModel

@property (nonatomic, assign) double    x;
@property (nonatomic, assign) double    y;
@property (nonatomic, strong) NSString  *mode;

- (instancetype)initWithX:(double)x Y:(double)y Mode:(NSString *)mode;
- (void)setX:(double)x Y:(double)y Mode:(NSString *)mode;

@end
