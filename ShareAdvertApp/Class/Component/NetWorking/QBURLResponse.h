//
//  QBURLResponse.h
//  QBNetworking
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBURLResponse : NSObject
@property (nonatomic) NSInteger code;

- (void)parseResponseWithDictionary:(NSDictionary *)dic;
@end
