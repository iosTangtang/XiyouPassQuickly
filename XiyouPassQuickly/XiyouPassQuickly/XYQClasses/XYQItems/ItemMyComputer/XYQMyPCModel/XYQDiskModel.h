//
//  XYQDiskModel.h
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "JSONModel.h"

@interface XYQDiskModel : JSONModel

@property (nonatomic, strong) NSString                          *FullName;
@property (nonatomic, strong) NSString                          *Name;
@property (nonatomic, strong) NSString                          *Lable;
@property (nonatomic, strong) NSString                          *FileTyp;

- (instancetype)initWithFullName:(NSString *)fullName Name:(NSString *)name Label:(NSString *)label FileTyp:(NSString *)fileTyp;
- (void)setName:(NSString *)name VolLable:(NSString *)volLable FullName:(NSString *)fullName FileTyp:(NSString *)fileTyp;

@end
