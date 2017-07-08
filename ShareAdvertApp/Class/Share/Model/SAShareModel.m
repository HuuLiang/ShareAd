//
//  SAShareModel.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareModel.h"

@implementation SAShareColumnModel

@end


@implementation SAShareResponse

- (Class)columnsElementClass {
    return [SAShareColumnModel class];
}

@end


@implementation SAShareModel

+ (Class)responseClass {
    return [SAShareResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (void)fetchShareColumnContent:(SACompletionHandler)handler {
    
    NSDictionary *params = @{};
    
    [self requestURLPath:nil
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (respStatus == QBURLResponseSuccess) {
            
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,nil);
        }
    }];
}

@end
