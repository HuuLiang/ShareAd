//
//  SARecruitViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARecruitViewController.h"
#import "SARecruitScrollView.h"
#import "SAMineAlertUIHelper.h"

@interface SARecruitViewController ()
@property (nonatomic) SARecruitScrollView *recruitScrollView;
@end

@implementation SARecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([SAUtil checkUserIsLogin]) {
        [self configRecruitContent];
    } else {
        [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeRecruitOffline onCurrentVC:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
