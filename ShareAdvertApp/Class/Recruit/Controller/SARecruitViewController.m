//
//  SARecruitViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARecruitViewController.h"
#import "SARecruitScrollView.h"

@interface SARecruitViewController ()
@property (nonatomic) SARecruitScrollView *recruitScrollView;
@end

@implementation SARecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([SAUtil checkUserIsLogin]) {
        [self configLoginNotice];
    } else {
        [self configRecruitContent];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)configLoginNotice {
    UIAlertView *alertView = [UIAlertView bk_showAlertViewWithTitle:@"温馨提示"
                                                            message:@"您还没登录，登录后才能招募徒弟"
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@[@"知道了"]
                                                            handler:^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == 1) {
            [self registerLogin];
        }
    }];
    [alertView show];
}

- (void)configRecruitContent {
    self.recruitScrollView = [[SARecruitScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_recruitScrollView];
    
    @weakify(self);
    _recruitScrollView.startRecruitAction = ^{
        @strongify(self);
    };
    
    _recruitScrollView.QRCodeRecruitAction = ^{
        @strongify(self);
    };
}

@end
