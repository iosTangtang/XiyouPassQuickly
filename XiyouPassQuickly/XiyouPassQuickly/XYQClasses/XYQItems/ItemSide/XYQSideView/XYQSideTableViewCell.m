//
//  XYQSideTableViewCell.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQSideTableViewCell.h"

@interface XYQSideTableViewCell ()

@property (nonatomic, strong) UILabel       *label;
@property (nonatomic, strong) UIImageView   *angleView;

@end

@implementation XYQSideTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        [self p_initView];
    }
    
    return self;
}

- (void)p_initView {
    self.backgroundColor = [UIColor clearColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width / 10,
                                                           XYQHeight / 24 - XYQHeight / 60,
                                                           self.contentView.frame.size.width / 3,
                                                           XYQHeight / 60 * 2)];
    self.label.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.label];
    
    self.angleView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFTSIDE_WIDTH - XYQWidth / 20,
                                                                   XYQHeight / 24 - XYQHeight / 80,
                                                                   XYQWidth / 40,
                                                                   XYQHeight / 40)];
    self.angleView.image = [UIImage imageNamed:@"angle"];
    [self.contentView addSubview:self.angleView];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 2)];
    headView.image = [UIImage imageNamed:@"Line"];
    [self.contentView addSubview:headView];
    
    UIImageView *footView = [[UIImageView alloc] initWithFrame:CGRectMake(0, XYQHeight / 12,
                                                                          self.contentView.frame.size.width, 2)];
    footView.image = [UIImage imageNamed:@"Line"];
    [self.contentView addSubview:footView];
}

- (void)congigItemMessages:(NSDictionary *)dic {
    self.label.text = [dic objectForKey:@"cellText"];
}

@end
