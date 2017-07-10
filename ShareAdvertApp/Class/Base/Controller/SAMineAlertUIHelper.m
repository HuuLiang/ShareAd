//
//  SAMineAlertUIHelper.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAMineAlertUIHelper.h"

@interface SAMineAlertUIHelper ()
@property (nonatomic) SAMineAlertType type;
@end

@implementation SAMineAlertUIHelper

+ (void)showAlertUIWithType:(SAMineAlertType)type onCurrentVC:(UIViewController *)currentViewController{
    SAMineAlertUIHelper * alertVC = [[SAMineAlertUIHelper alloc] initWithAlertType:type];
    [alertVC showAlertUIOnCurrentVC:currentViewController];
}

- (instancetype)initWithAlertType:(SAMineAlertType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_type) {
        case SAMineAlertTypeNetworkError:
            [self showNetworkError];
            break;
            
        case SAMineAlertTypeRecruitOffline:
        case SAMineAlertTypeMineCenterOffline:
            [self showOfflineError];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showAlertUIOnCurrentVC:(UIViewController *)currentVC {
    
    BOOL anySpreadBanner = [currentVC.childViewControllers bk_any:^BOOL(id obj) {
        if ([obj isKindOfClass:[self class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (anySpreadBanner) {
        return ;
    }
    
    if ([currentVC.view.subviews containsObject:self.view]) {
        return ;
    }
    
    [currentVC addChildViewController:self];
    self.view.frame = currentVC.view.bounds;
    self.view.alpha = 0;
    [currentVC.view addSubview:self.view];
    [self didMoveToParentViewController:currentVC];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self hide];
}

- (void)dealloc {
    
}

- (void)hide {
    if (!self.view.superview) {
        return ;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark - type

- (void)showNetworkError {
    [UIAlertView bk_showAlertViewWithTitle:@"系统提示"
                                   message:@"网络连接发生错误!"
                         cancelButtonTitle:nil
                         otherButtonTitles:@[@"确定"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        
    }];
}

- (void)showOfflineError {
    NSString *notice = nil;
    switch (_type) {
        case SAMineAlertTypeRecruitOffline:
            notice = @"您还没登录，登录后才能招募徒弟";
            break;
        case SAMineAlertTypeMineCenterOffline:
            notice = @"您还没登录，登录后才能进入个人中心";
            break;
            
        default:
            break;
    }
    UIAlertView *alertView = [UIAlertView bk_showAlertViewWithTitle:@"温馨提示"
                                                            message:notice
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@[@"知道了"]
                                                            handler:^(UIAlertView *alertView, NSInteger buttonIndex)
                              {
                                  if (buttonIndex == 1) {
                                      [self hide];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:kSAUserLoginNotification object:nil];
                                  }
                              }];
    [alertView show];
}

@end
