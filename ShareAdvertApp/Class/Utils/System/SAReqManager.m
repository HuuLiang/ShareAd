//
//  SAReqManager.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAReqManager.h"
#import "QBDataManager.h"
#import "QBDataResponse.h"

@implementation SAReqManager

+ (instancetype)manager {
    static SAReqManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[SAReqManager alloc] init];
    });
    return _manager;
}

- (NSDictionary *)params {
    NSDictionary *baseParams = @{@"appId":SA_REST_APPID,
                                 @"channelNo":SA_CHANNEL_NO,
                                 @"appVersion":SA_REST_APP_VERSION,
                                 @"cVersion":SA_CONTENT_VERSION};
    return baseParams;
}

- (BOOL)checkResponseCodeObject:(id)obj error:(NSError *)error {
    QBLog(@"obj=%@ error = %@",obj,error);
    
    if (!obj || error) {
        return NO;
    }
    
    QBDataResponse *resp = obj;
    NSInteger respCode = [resp.code integerValue];
    switch (respCode) {
        case 200:
            return YES;
            break;
            
        default:
            return NO;
            break;
    }
}

- (void)fetchColumnContentWithClass:(Class)modelClass CompletionHandler:(SACompletionHandler)handler {
    [[QBDataManager manager] requestUrl:SA_SHARECOLUMN_URL
                             withParams:[self params]
                                  class:modelClass
                                handler:^(id obj, NSError *error)
    {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)fetchShareListWithColumnId:(NSString *)columnId class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params setObject:columnId forKey:@"columnId"];
    
    [[QBDataManager manager] requestUrl:SA_SHARELIST_URL
                             withParams:params
                                  class:modelClass handler:^(id obj, NSError *error)
    {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)fetchActivateInfoWithClass:(Class)modelClass Handler:(SACompletionHandler)handler {
    [[QBDataManager manager] requestUrl:SA_ACTIVATE_URL
                             withParams:[self params]
                                  class:modelClass
                                handler:^(id obj, NSError *error)
    {
        handler([self checkResponseCodeObject:obj error:error],obj);
    }];
}

- (void)registerUserWithInfo:(NSDictionary *)userInfo class:(Class)modelClass handler:(SACompletionHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    [params addEntriesFromDictionary:userInfo];
    
    [[QBDataManager manager] requestUrl:SA_REGISTER_URL
                             withParams:params
                                  class:modelClass
                                handler:^(id obj, NSError *error)
    {
        
    }];
}

@end
