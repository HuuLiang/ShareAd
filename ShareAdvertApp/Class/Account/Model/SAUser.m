//
//  SAUser.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAUser.h"

@implementation SAUser

+ (instancetype)user {
    static SAUser *_user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[SAUser findAll] firstObject];;
        if (!_user) {
            _user = [[SAUser alloc] init];
        }
    });
    return _user;
}



@end
