//
//  SAShareManager.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBDataResponse.h"

@class BaseResp;
@class SAShareContentProgramModel;

@interface SAShareManager : QBDataResponse

+ (instancetype)manager;

- (void)startToShareWithModel:(SAShareContentProgramModel *)programModel;

- (void)receiveWxResp:(BaseResp *)resp;

- (void)startToRecruitUrlWoWx;


@end
