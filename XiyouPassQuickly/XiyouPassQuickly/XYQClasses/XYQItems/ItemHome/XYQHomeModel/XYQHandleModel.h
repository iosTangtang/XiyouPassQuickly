//
//  XYQHandleModel.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "JSONModel.h"

@interface XYQHandleModel : JSONModel

@property (nonatomic, strong) NSString *Typ;
@property (nonatomic, strong) NSString *Msg;

- (instancetype)initWithTyp:(NSString *)typ Msg:(NSString *)msg;

- (void)setTyp:(NSString *)typ Msg:(NSString *)msg;

@end
