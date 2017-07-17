//
//  SAShareManager.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/14.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareManager.h"
#import "SAShareContentModel.h"
#import <WXApi.h>
#import "SAReqManager.h"
#import "SAConfigModel.h"

@interface SAShareManager ()
@property (nonatomic) SAShareContentProgramModel *programModel;
@end

@implementation SAShareManager

+ (instancetype)manager {
    static SAShareManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[SAShareManager alloc] init];
    });
    return _manager;
}

- (void)startToShareWithModel:(SAShareContentProgramModel *)programModel {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:programModel.coverImg]
                                                          options:SDWebImageDownloaderHighPriority
                                                         progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
    {
        self.programModel = programModel;
        
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;
        sendReq.scene = WXSceneSession;
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = programModel.title;//分享标题
        urlMessage.description = programModel.title;//分享描述
        [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = programModel.shUrl;//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
    }];
}

- (void)startToRecruitUrlWoWx {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[SAConfigModel defaultConfig].config.AP_IMG]
                                                          options:SDWebImageDownloaderHighPriority
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
    {
        
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;
        sendReq.scene = WXSceneSession;
        
        
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [SAConfigModel defaultConfig].config.AP_TITLE;//分享标题
        urlMessage.description = [SAConfigModel defaultConfig].config.AP_SUBTITLE;//分享描述
        [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [NSString stringWithFormat:@"%@?userId=%@",[SAConfigModel defaultConfig].config.AP_URL,[SAUser user].userId];//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
    }];
}

- (void)receiveWxResp:(BaseResp *)resp {
    SendMessageToWXResp *msgResp = (SendMessageToWXResp *)resp;
    if (msgResp.errCode == 0 && self.programModel) {
        //分享成功
        [[SAReqManager manager] updateShareBountyWithPrice:[self.programModel.shAmount integerValue] shareId:self.programModel.shareId class:[self class] handler:^(BOOL success, id obj) {
            if (success) {
                [[SAHudManager manager] showHudWithText:@"分享成功"];
            }
            self.programModel = nil;
        }];
    }
}

@end
