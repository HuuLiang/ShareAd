//
//  SARegisterViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARegisterViewController.h"
#import "SARegisterInfoView.h"

@interface SARegisterViewController ()
@property (nonatomic) SARegisterInfoView *registerInfoView;
@property (nonatomic) UIButton *confirmButton;
@property (nonatomic) UILabel *haveLabel;
@end

@implementation SARegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configRegisterInfoView];
    
    [self configConfirmView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configRegisterInfoView {
    self.registerInfoView = [[SARegisterInfoView alloc] init];
    [self.view addSubview:_registerInfoView];
    
    {
        [_registerInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(kWidth(32));
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(534)));
        }];
    }
}

- (void)configConfirmView {
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = kFont(14);
    _confirmButton.layer.cornerRadius = 3.0f;
    _confirmButton.backgroundColor = kColor(@"#ff3366");
    [self.view addSubview:_confirmButton];
    
    self.haveLabel = [[UILabel alloc] init];
    _haveLabel.text = @"已有账号";
    _haveLabel.font = kFont(14);
    _haveLabel.textColor = kColor(@"#ff3366");
    _haveLabel.textAlignment = NSTextAlignmentRight;
    _haveLabel.userInteractionEnabled = YES;
    [self.view addSubview:_haveLabel];
    
    @weakify(self);
    [_confirmButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_haveLabel bk_whenTapped:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    {
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_registerInfoView.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(90)));
        }];
        
        [_haveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_confirmButton.mas_right);
            make.top.equalTo(_confirmButton.mas_bottom).offset(kWidth(35));
            make.height.mas_equalTo(_haveLabel.font.lineHeight);
        }];
    }
}

@end
