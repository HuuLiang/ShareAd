//
//  QBEncryptedURLRequest.h
//  QBNetworking
//
//  Created by Sean Yue on 15/9/14.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "QBURLRequest.h"

@interface QBEncryptedURLRequest : QBURLRequest

- (NSDictionary *)encryptWithParams:(NSDictionary *)params;
- (id)decryptResponse:(id)encryptedResponse;

@end
