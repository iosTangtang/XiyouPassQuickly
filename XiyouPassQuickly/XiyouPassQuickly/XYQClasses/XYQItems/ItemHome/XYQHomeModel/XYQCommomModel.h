//
//  XYQCommomModel.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "JSONModel.h"

@interface XYQCommomModel : JSONModel

@property (nonatomic, copy) NSString    *Flag;
@property (nonatomic, copy) NSString    *Msg;

- (instancetype)initWithFlag:(NSString *)flag Msg:(NSString *)msg;
- (void)setFlag:(NSString *)flag Msg:(NSString *)msg;

@end
