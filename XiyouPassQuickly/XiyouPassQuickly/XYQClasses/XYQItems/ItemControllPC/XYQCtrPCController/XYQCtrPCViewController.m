//
//  XYQCtrPCViewController.m
//  XiyouPassQuickly
//
//  Created by Tangtang on 16/5/18.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYQCtrPCViewController.h"
#import "XYQTouchPadViewController.h"
#import "XYQShotScreenViewController.h"
#import "XYQShutdownPCViewController.h"
#import "XYQCtrPPTViewController.h"

@interface XYQCtrPCViewController ()

@end

@implementation XYQCtrPCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_initButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)p_initButton {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XYQWidth, XYQHeight)];
    imageView.image = [UIImage imageNamed:@"Rectangle 1"];
    [self.view addSubview:imageView];
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(i % 2 == 0 ? XYQWidth / 6 : XYQWidth / 2 + XYQWidth / 10,
                                  i % 2 == 0 ? XYQHeight / 4 + XYQHeight / 4 * (i / 2) :
                                  XYQHeight / 4 + XYQHeight / 4 * ((i - 1) / 2),
                                  XYQWidth / 5, XYQHeight / 6);
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d", i]]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)ButtonAction:(UIButton *)button {
    if (button.tag == 0) {
        
    } else if (button.tag == 1) {
        XYQShotScreenViewController *scrVC = [[XYQShotScreenViewController alloc] init];
        [self.navigationController pushViewController:scrVC animated:YES];
    } else if (button.tag == 2) {
        XYQShutdownPCViewController *conVC = [[XYQShutdownPCViewController alloc] init];
        [self.navigationController pushViewController:conVC animated:YES];
    } else if (button.tag == 3) {
        XYQTouchPadViewController *touchVC = [[XYQTouchPadViewController alloc] init];
        [self.navigationController pushViewController:touchVC animated:YES];
    } else if (button.tag == 4) {
        XYQCtrPPTViewController *pptVC = [[XYQCtrPPTViewController alloc] init];
        [self.navigationController pushViewController:pptVC animated:YES];
    }
}

@end
