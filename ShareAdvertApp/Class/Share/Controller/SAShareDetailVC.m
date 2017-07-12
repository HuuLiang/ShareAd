//
//  SAShareDetailVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/7.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareDetailVC.h"
#import "SADetailFooterView.h"
#import "SAMineAlertUIHelper.h"

@interface SAShareDetailVC () <UIWebViewDelegate>
@property (nonatomic) UIWebView *shareDetailView;
@property (nonatomic) NSString *urlStr;
@property (nonatomic) SADetailFooterView *footerView;
@end

@implementation SAShareDetailVC

- (instancetype)initWithUrl:(NSString *)urlStr {
    self = [super init];
    if (self) {
        _urlStr = urlStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文章详情";
    
    self.shareDetailView = [[UIWebView alloc] init];
    _shareDetailView.delegate = self;
    [self.view addSubview:_shareDetailView];
    {
        [_shareDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    if (_urlStr.length > 0) {
        [_shareDetailView loadHTMLString:_urlStr baseURL:nil];
    } else {
        [self showError];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showError {
    [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeNetworkError onCurrentVC:self];
}

- (void)configShareModel {
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self startToShareContent];
    }];
    
    self.footerView = [[SADetailFooterView alloc] init];
    [self.view addSubview:_footerView];
    
    _footerView.ruleAction = ^{
        @strongify(self);
        
    };
    
    _footerView.shareAction = ^{
        @strongify(self);
        [self startToShareContent];
    };
    
    {
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(kWidth(90));
        }];
    }
}

- (void)startToShareContent {
    if (![SAUtil checkUserIsLogin]) {
        [SAMineAlertUIHelper showAlertUIWithType:SAMineAlertTypeShareOffline onCurrentVC:self];
    } else {
        
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    [self configShareModel];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showError];
}

@end
