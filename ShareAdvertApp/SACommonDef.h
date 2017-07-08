//
//  SACommonDef.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#ifndef SACommonDef_h
#define SACommonDef_h


typedef void (^SAAction)(void);
typedef void (^SACompletionHandler)(BOOL success, id obj);

typedef NS_ENUM(NSUInteger, SADeviceType) {
    SADeviceTypeUnknown,
    SADeviceType_iPhone4,
    SADeviceType_iPhone4S,
    SADeviceType_iPhone5,
    SADeviceType_iPhone5C,
    SADeviceType_iPhone5S,
    SADeviceType_iPhone6,
    SADeviceType_iPhone6P,
    SADeviceType_iPhone6S,
    SADeviceType_iPhone6SP,
    SADeviceType_iPhoneSE,
    SADeviceType_iPhone7,
    SADeviceType_iPhone7P,
    SADeviceType_iPad = 100
};

#define kWidth(width)                     kScreenWidth  * width  / 750.
#define kHeight(height)                   kScreenHeight * height / 1334.
#define kColor(hexString)                 [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",hexString]]
#define kFont(font)                       [UIFont systemFontOfSize:kWidth(font*2)]

#define KDateFormatLong                   @"yyyyMMddHHmmss"


#define kSAUserIsLoginNotification          @"ShareAd_user_isLogin_notification"



#endif /* SACommonDef_h */
