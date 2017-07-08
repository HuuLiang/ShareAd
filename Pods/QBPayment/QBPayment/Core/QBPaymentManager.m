//
//  QBPaymentManager.m
//  Pods
//
//  Created by Sean Yue on 2017/6/1.
//
//

#import "QBPaymentManager.h"
#import "QBPaymentNetworkingManager.h"
#import "QBPaymentPlugin.h"
#import "QBPaymentPluginManager.h"
#import <NSObject+BaseRepresentation.h>

NSString *const kQBPaymentWillBeginPaymentNotification = @"com.qbpayment.notification.willbeginpayment";
NSString *const kQBPaymentDidFetchPaymentConfigNotification = @"com.qbpayment.notification.didfetchpaymentconfig";

NSString *const kQBPaymentSettingChannelNo = @"com.qbpayment.settings.channelNo";
NSString *const kQBPaymentSettingAppId = @"com.qbpayment.settings.appId";
NSString *const kQBPaymentSettingPv = @"com.qbpayment.settings.pv";
NSString *const kQBPaymentSettingUrlScheme = @"com.qbpayment.settings.urlscheme";
NSString *const kQBPaymentSettingDefaultTimeount = @"com.qbpayment.settings.defaulttimeout";
NSString *const kQBPaymentSettingUseConfigInTestServer = @"com.qbpayment.settings.useconfigintestserver";
NSString *const kQBPaymentSettingDefaultConfig = @"com.qbpayment.settings.defaultconfig";

@interface QBPaymentManager ()
@property (nonatomic) BOOL useConfigInTestServer;
@property (nonatomic,weak) QBPaymentPlugin *payingPlugin;
@property (nonatomic,retain) NSTimer *commitOrdersTimer;
@end

@implementation QBPaymentManager

+ (instancetype)sharedManager {
    static QBPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)registerPaymentWithSettings:(NSDictionary *)settings {
    
    NSString *channelNo = settings[kQBPaymentSettingChannelNo];
    NSString *appId = settings[kQBPaymentSettingAppId];
    NSNumber *pv = settings[kQBPaymentSettingPv];
    
    NSAssert(QBP_STRING_IS_NOT_EMPTY(channelNo) && QBP_STRING_IS_NOT_EMPTY(appId) && pv, @"‼️ChannelNo/AppId/pv must NOT be empty in the settings‼️");
    
    [QBPaymentNetworkingManager defaultManager].channelNo = channelNo;
    [QBPaymentNetworkingManager defaultManager].appId = appId;
    [QBPaymentNetworkingManager defaultManager].pv = pv;
    
    [[QBPaymentPluginManager sharedManager] loadAllPlugins];
    
    // For default payment configuration
    QBPaymentConfiguration *defaultConfiguration;
    if (settings[kQBPaymentSettingDefaultConfig]) {
        id defaultConfig = settings[kQBPaymentSettingDefaultConfig];
        
        if ([defaultConfig isKindOfClass:[NSString class]]) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:defaultConfig ofType:@"plist"];
            defaultConfig = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        }
        
        if ([defaultConfig isKindOfClass:[NSDictionary class]]) {
            defaultConfiguration = [QBPaymentConfiguration objectFromDictionary:defaultConfig];
            
        } else if ([defaultConfig isKindOfClass:[QBPaymentConfiguration class]]) {
            defaultConfiguration = defaultConfig;
        }
    }
    
    if (defaultConfiguration) {
        [QBPaymentPluginManager sharedManager].paymentConfiguration = defaultConfiguration;
    }
    // End
    
    [QBPaymentPluginManager sharedManager].urlScheme = settings[kQBPaymentSettingUrlScheme];
    
    if (settings[kQBPaymentSettingUseConfigInTestServer]) {
        self.useConfigInTestServer = [settings[kQBPaymentSettingUseConfigInTestServer] boolValue];
    }
    
    [self refreshPaymentConfigurationWithCompletionHandler:nil];
    [self startRetryingToCommitUnprocessedOrders];
}

- (void)payWithOrderInfo:(QBOrderInfo *)orderInfo
             contentInfo:(QBContentInfo *)contentInfo
       completionHandler:(QBPaymentCompletionHandler)completionHandler
{
    // 0. Validate the conditions
    if (orderInfo.payType == QBPaymentTypeNone || QBP_STRING_IS_EMPTY(orderInfo.orderId) || orderInfo.orderPrice == 0) {
        QBLog(@"‼️Invalid order!‼️");
        return ;
    }
    
    QBPluginType pluginType = [self pluginTypeForPaymentType:orderInfo.payType];
    if (pluginType == QBPluginTypeNone) {
        QBLog(@"‼️No configured plugin type for payment type: %ld‼️", (unsigned long)orderInfo.payType);
        QBSafelyCallBlock(completionHandler, NO, nil);
        return ;
    }
    
    // 1. Build payment info from orderInfo and contentInfo
    QBPaymentInfo *paymentInfo = [[QBPaymentInfo alloc] initWithOrderInfo:orderInfo contentInfo:contentInfo];
    paymentInfo.pluginType = pluginType;
    [paymentInfo save];
    
    // 2. Find the plugin to process this order
    QBPaymentPlugin *plugin = [[QBPaymentPluginManager sharedManager] pluginWithType:paymentInfo.pluginType];
    if (!plugin) {
        QBSafelyCallBlock(completionHandler, QBPayResultFailure, paymentInfo);
        return ;
    } else {
        self.payingPlugin = plugin;
    }
    
    // 3. Do payment
    [plugin payWithPaymentInfo:paymentInfo completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
        self.payingPlugin = nil;
        QBSafelyCallBlock(completionHandler, payResult, paymentInfo);
    }];
}

- (void)activatePaymentInfos:(NSArray<QBPaymentInfo *> *_Nonnull)paymentInfos
       withCompletionHandler:(QBCompletionHandler _Nullable )completionHandler {
    
    NSMutableString *orders = [NSMutableString string];
    [paymentInfos enumerateObjectsUsingBlock:^(QBPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (orders.length > 0) {
            [orders appendString:@"|"];
        }
        
        if (obj.orderId.length > 0) {
            [orders appendString:obj.orderId];
        }

    }];
    
    [[QBPaymentNetworkingManager defaultManager] request_queryOrders:orders
                                               withCompletionHandler:^(BOOL success, id obj)
    {
        __block QBPaymentInfo *paymentInfo;
        if (success) {
            NSString *orderId = obj;
            
            if ([orderId isKindOfClass:[NSString class]]) {
                
                NSArray<NSString *> *paidOrders = [orderId componentsSeparatedByString:@"|"];
                [paymentInfos enumerateObjectsUsingBlock:^(QBPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([paidOrders containsObject:obj.orderId]) {
                        paymentInfo = obj;
                        *stop = YES;
                    }
                }];
            }
            
            if (paymentInfo) {
                [QBPaymentPlugin commitPayment:paymentInfo withResult:QBPayResultSuccess];
            }
        }
        
        QBSafelyCallBlock(completionHandler, success, paymentInfo);
    }];
}

- (void)refreshPaymentConfigurationWithCompletionHandler:(QBCompletionHandler)completionHandler {
    [[QBPaymentNetworkingManager defaultManager] request_fetchPaymentConfigurationWithURLString:self.useConfigInTestServer?kQBPaymentConfigurationTestURL:kQBPaymentConfigurationProducationURL completionHandler:^(BOOL success, id obj) {
        if (success) {
            [QBPaymentPluginManager sharedManager].paymentConfiguration = obj;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kQBPaymentDidFetchPaymentConfigNotification object:obj];
        }
        
        QBSafelyCallBlock(completionHandler, success, obj);
    }];
}

- (void)startRetryingToCommitUnprocessedOrders {
    if (!self.commitOrdersTimer) {
        self.commitOrdersTimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(onTimerToCommitUnprocessedOrders:) userInfo:nil repeats:YES];
        [self.commitOrdersTimer fire];
    }
}

- (void)onTimerToCommitUnprocessedOrders:(NSTimer *)timer {
    if (!self) {
        [timer invalidate];
        return ;
    }
    
    QBLog(@"Payment: on retrying to commit unprocessed orders!");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[QBPaymentInfo allPaymentInfos] enumerateObjectsUsingBlock:^(QBPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.paymentStatus == QBPayStatusNotProcessed) {
                [[QBPaymentNetworkingManager defaultManager] request_commitPaymentInfo:obj withCompletionHandler:nil];
            }
        }];
    });
}
@end

@implementation QBPaymentManager (PluginQueries)

- (BOOL)pluginIsEnabled:(QBPluginType)pluginType {
    return [[QBPaymentPluginManager sharedManager] pluginIsEnabled:pluginType];
}

- (QBPluginType)pluginTypeForPaymentType:(QBPaymentType)paymentType {
    QBPaymentConfiguration *configuration = [QBPaymentPluginManager sharedManager].paymentConfiguration;
    
    NSNumber *pluginType;
    if (paymentType == QBPaymentTypeWeChat) {
        pluginType = configuration.weixin.type;
    } else if (paymentType == QBPaymentTypeAlipay) {
        pluginType = configuration.alipay.type;
    }
    return pluginType.unsignedIntegerValue;
}

@end

@implementation QBPaymentManager (ApplicationCallback)

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self.payingPlugin applicationWillEnterForeground:application];
}

- (void)handleOpenUrl:(NSURL *)url {
    [self.payingPlugin handleOpenURL:url];
}

@end
