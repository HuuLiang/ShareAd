//
//  SAShareModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBEncryptedURLRequest.h"

@interface SAShareColumnModel : NSObject
@property (nonatomic) NSString *columnId;
@property (nonatomic) NSString *columnName;
@end

@interface SAShareResponse : QBURLResponse
@property (nonatomic) NSArray *columns;
@end

@interface SAShareModel : QBEncryptedURLRequest

- (void)fetchShareColumnContent:(SACompletionHandler)handler;

@end
