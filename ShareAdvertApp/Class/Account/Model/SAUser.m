//
//  SAUser.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAUser.h"

#define CurrentUserId 1

@implementation SAUser

+ (instancetype)user {
    static SAUser *_user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [SAUser findByPK:CurrentUserId];;
        if (!_user) {
            _user = [[SAUser alloc] init];
            _user.pk = CurrentUserId;
            [_user saveOrUpdate];
        }
    });
    return _user;
}

- (void)setValueWithObj:(SAUser *)responseUser {
    [responseUser.allProperties enumerateObjectsUsingBlock:^(NSString *  _Nonnull keyName , NSUInteger idx, BOOL * _Nonnull stop) {
        [self.allProperties enumerateObjectsUsingBlock:^(NSString *  _Nonnull propertyName, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([keyName isEqualToString:propertyName]) {
                [self setValue:[responseUser valueForKey:keyName] forKey:propertyName];
            }
        }];
    }];
}

@end
