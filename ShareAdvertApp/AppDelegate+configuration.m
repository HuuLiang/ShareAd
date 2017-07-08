//
//  AppDelegate+configuration.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "AppDelegate+configuration.h"
#import "QBNetworkingConfiguration.h"
#import "QBNetworkInfo.h"
#import <UMMobClick/MobClick.h>
#import "SATabBarController.h"
#import "QBImageUploadManager.h"


@implementation AppDelegate (configuration)

- (void)showHomeViewController {
    SATabBarController *rootVC = [[SATabBarController alloc] init];
    self.window.rootViewController = rootVC;
}

- (void)defaultConfiguration {
    [self setupMobStatistics];
    
    [QBImageUploadManager registerWithSecretKey:SA_UPLOAD_SECRET_KEY accessKey:SA_UPLOAD_ACCESS_KEY scope:SA_UPLOAD_SCOPE];
}


- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    if (XcodeAppVersion) {
        [MobClick setAppVersion:XcodeAppVersion];
    }
    UMConfigInstance.appKey = SA_UMENG_APP_ID;
    UMConfigInstance.channelId = SA_CHANNEL_NO;
    [MobClick startWithConfigure:UMConfigInstance];
}


- (void)setCommonStyle {
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#FAFAFA"]];
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor(@"#999999")} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor(@"#FF3366")} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#ffffff"]];
    [[UINavigationBar appearance] setBarTintColor:kColor(@"#FF3366")];
    [[UINavigationBar appearance] setBackgroundColor:kColor(@"#FF3366")];
    [[UINavigationBar appearance] setTranslucent:NO];
    
//    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
//                                withOptions:AspectPositionInstead
//                                 usingBlock:^(id<AspectInfo> aspectInfo){
//                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
//                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
//                                     
//                                     BOOL autoRotate = NO;
//                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
//                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
//                                     } else {
//                                         autoRotate = [selectedVC shouldAutorotate];
//                                     }
//                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
//                                 } error:nil];
//    
//    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
//                                withOptions:AspectPositionInstead
//                                 usingBlock:^(id<AspectInfo> aspectInfo){
//                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
//                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
//                                     
//                                     NSUInteger result = 0;
//                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
//                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
//                                     } else {
//                                         result = [selectedVC supportedInterfaceOrientations];
//                                     }
//                                     [[aspectInfo originalInvocation] setReturnValue:&result];
//                                 } error:nil];
//    
//    [UIViewController aspect_hookSelector:@selector(hidesBottomBarWhenPushed)
//                              withOptions:AspectPositionInstead
//                               usingBlock:^(id<AspectInfo> aspectInfo)
//     {
//         UIViewController *thisVC = [aspectInfo instance];
//         BOOL hidesBottomBar = NO;
//         if (thisVC.navigationController.viewControllers.count > 1) {
//             hidesBottomBar = YES;
//         }
//         [[aspectInfo originalInvocation] setReturnValue:&hidesBottomBar];
//     } error:nil];
//    
//    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
//                          withOptions:AspectPositionInstead
//                           usingBlock:^(id<AspectInfo> aspectInfo)
//     {
//         BOOL bShow = NO;
//         [[aspectInfo originalInvocation] setReturnValue:&bShow];
//     } error:nil];
}

- (void)checkNetworkInfoState {
    
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = SA_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([SA_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = SA_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = SA_BASE_URL;
    [QBNetworkingConfiguration defaultConfiguration].useStaticBaseUrl = NO;
    [QBNetworkingConfiguration defaultConfiguration].encryptedType = QBURLEncryptedTypeNew;
    [QBNetworkingConfiguration defaultConfiguration].encryptionPasssword = SA_ENCRYPT_PASSWORD;
#ifdef DEBUG
    //    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
#endif
    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^ (BOOL reachable) {
        
        if (reachable && [SAUtil isRegisteredUUID]) {
            
        } else {
            
        }
        
        //网络错误提示
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![SAUtil isRegisteredUUID])) {
            if ([SAUtil isIpad]) {
                [UIAlertView bk_showAlertViewWithTitle:@"请检查您的网络连接!" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil handler:nil];
            }else{
                [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"您的应用未连接到网络,请检查您的网络设置" cancelButtonTitle:@"稍后" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
            }
        }
    };
}


@end
