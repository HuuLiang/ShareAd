//
//  SAConfig.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#ifndef SAConfig_h
#define SAConfig_h

//baseInfo
#define SA_CHANNEL_NO               [SAConfiguration sharedConfig].channelNo
#define SA_REST_APPID               @"QUBA_2029"
#define SA_REST_PV                  @"100"
#define SA_PAYMENT_PV               @"100"
#define SA_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."

#define SA_REST_APP_VERSION         ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define SA_BUNDLE_IDENTIFIER        ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"]))
#define SA_PAYMENT_RESERVE_DATA     [NSString stringWithFormat:@"%@$%@", SA_REST_APPID, SA_CHANNEL_NO]
#define SA_PAYMENT_ORDERID          [NSString stringWithFormat:@"%@_%@", [SA_CHANNEL_NO substringFromIndex:SA_CHANNEL_NO.length-14], [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)]]



//URL
#define SA_BASE_URL                    @""
#define SA_STANDBY_BASE_URL            @""

//secret
#define SA_ENCRYPT_PASSWORD            @"qb%Fr@2016_&"

//友盟
#define SA_UMENG_APP_ID                @"5914208be88bad6c13000e6e"

//微信
#define SA_WEXIN_APP_ID                @"wx2b2846687e296e95"
#define SA_WECHAT_TOKEN                @"https://api.weixin.qq.com/sns/oauth2/access_token?"
#define SA_WECHAT_SECRET               @"0a4e146c0c399b706514f22ad2f1e078"
#define SA_WECHAT_USERINFO             @"https://api.weixin.qq.com/sns/userinfo?"

//七牛图片
#define SA_UPLOAD_SCOPE                @"mfw-image"
#define SA_UPLOAD_SECRET_KEY           @"9mmo2Dd9oca-2SJ5Uou9qQ1d2XjNIoX9EdrPQ6Xj"
#define SA_UPLOAD_ACCESS_KEY           @"JIWlLAM3_bGrfTyU16XKjluzYKcsHOB--yDFB4zt"

#endif /* SAConfig_h */
