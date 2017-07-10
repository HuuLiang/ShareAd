//
//  SALoginViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SALoginViewController.h"
#import "SALoginInfoView.h"
#import "SARegisterViewController.h"

@interface SALoginViewController ()
@property (nonatomic) SALoginInfoView *loginInfoView;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UILabel *forgotLabel;
@property (nonatomic) UILabel *registerLabel;
@end

@implementation SALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#efefef");
    
    [self configLoginInfo];
    
    [self configLoginButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"account_return"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
}

- (void)configLoginInfo {
    self.loginInfoView = [[SALoginInfoView alloc] init];
    [self.view addSubview:_loginInfoView];
    
    {
        [_loginInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset (kWidth(32));
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(303)));
        }];
    }
}

- (void)configLoginButton {
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
    _loginButton.titleLabel.font = kFont(14);
    _loginButton.layer.cornerRadius = 3.0f;
    _loginButton.backgroundColor = kColor(@"#ff3366");
    [self.view addSubview:_loginButton];
    
    self.forgotLabel = [[UILabel alloc] init];
    _forgotLabel.text = @"忘记密码";
    _forgotLabel.textColor = kColor(@"#444A59");
    _forgotLabel.font = kFont(14);
    [self.view addSubview:_forgotLabel];
    
    self.registerLabel = [[UILabel alloc] init];
    _registerLabel.text = @"立即注册";
    _registerLabel.textColor = kColor(@"#ff3366");
    _registerLabel.font = kFont(14);
    _registerLabel.textAlignment = NSTextAlignmentRight;
    _registerLabel.userInteractionEnabled = YES;
    [self.view addSubview:_registerLabel];
    
    @weakify(self);
    [_loginButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_forgotLabel bk_whenTapped:^{
        @strongify(self);
        
    }];
    
    [_registerLabel bk_whenTapped:^{
        @strongify(self);
        SARegisterViewController *registerVC = [[SARegisterViewController alloc] initWithTitle:@"注册"];
        [self.navigationController pushViewController:registerVC animated:YES];
    }];
    
    {
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_loginInfoView.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(690), kWidth(90)));
        }];
        
        [_forgotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(kWidth(30));
            make.top.equalTo(_loginButton.mas_bottom).offset(kWidth(35));
            make.height.mas_equalTo(_forgotLabel.font.lineHeight);
        }];
        
        [_registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-kWidth(30));
            make.centerY.equalTo(_forgotLabel);
            make.height.mas_equalTo(_registerLabel.font.lineHeight);
        }];
    }
}


@end
