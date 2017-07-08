//
//  SAShareContentModel.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareContentModel.h"

@implementation SAShareContentProgramModel

@end

@implementation SAShareContentResponse

- (Class)programsElementClass {
    return [SAShareContentProgramModel class];
}

@end


@implementation SAShareContentModel

+ (Class)responseClass {
    return [SAShareContentResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (void)fetchColumnContentWithColumnId:(NSString *)columId CompletionHandler:(SACompletionHandler)handler {
    NSDictionary *params = @{};
    
    [self requestURLPath:nil
          standbyURLPath:nil
              withParams:params
         responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SAShareContentResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp.programs);
        }
    }];
}


@end
