//
//  SAUser.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SAUser : JKDBModel

+ (instancetype)user;

@property (nonatomic) NSString *userId;

@property (nonatomic) NSString *nickName;

@property (nonatomic) NSString *portraitUrl;

@property (nonatomic) NSString *sex;

@property (nonatomic) NSString *city;

@property (nonatomic) NSString *weixin;

@property (nonatomic) NSString *account;

@property (nonatomic) NSString *password;

@property (nonatomic) NSString *code;

@end
