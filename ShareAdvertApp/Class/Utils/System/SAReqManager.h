//
//  SAReqManager.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAReqManager : NSObject

+ (instancetype)manager;

/** 获取栏目列表 */
- (void)fetchColumnContentWithClass:(Class)modelClass CompletionHandler:(SACompletionHandler)handler;

/** 根据栏目id获取节目列表 */
- (void)fetchShareListWithColumnId:(NSString *)columnId class:(Class)modelClass handler:(SACompletionHandler)handler;

/** 激活 */
- (void)fetchActivateInfoWithClass:(Class)modelClass Handler:(SACompletionHandler)handler;

/** 注册 */
- (void)registerUserWithInfo:(NSDictionary *)userInfo class:(Class)modelClass handler:(SACompletionHandler)handler;
@end
