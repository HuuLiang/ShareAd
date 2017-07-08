//
//  SAShareContentModel.h
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/6.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBEncryptedURLRequest.h"

@interface SAShareContentProgramModel : NSObject
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *title;
@end

@interface SAShareContentResponse : QBURLResponse
@property (nonatomic) NSArray <SAShareContentProgramModel *> *programs;
@end

@interface SAShareContentModel : QBEncryptedURLRequest

- (void)fetchColumnContentWithColumnId:(NSString *)columId CompletionHandler:(SACompletionHandler)handler;

@end
