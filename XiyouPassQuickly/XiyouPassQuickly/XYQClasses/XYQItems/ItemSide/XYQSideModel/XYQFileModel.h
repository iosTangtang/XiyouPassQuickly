//
//  XYQFileModel.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "JSONModel.h"

@interface XYQFileModel : JSONModel

@property (nonatomic, assign) long      Size;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Typ;
@property (nonatomic, strong) NSString *Msg;

- (instancetype)initWithSize:(long)size Name:(NSString *)name Typ:(NSString *)typ Msg:(NSString *)msg;
- (void)setSize:(long)Size Name:(NSString *)Name Type:(NSString *)Type Msg:(NSString *)Msg;

@end
