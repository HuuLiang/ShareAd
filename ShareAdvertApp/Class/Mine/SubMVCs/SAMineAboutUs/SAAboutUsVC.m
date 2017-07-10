//
//  SAAboutUsVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAAboutUsVC.h"
#import "SAMineAlertUIHelper.h"

@interface SAAboutUsVC () <UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@end

@implementation SAAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [_webView loadHTMLString:@"" baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SAMineAlertUIHelper showAlertUIWithType:1 onCurrentVC:self];
}

@end
