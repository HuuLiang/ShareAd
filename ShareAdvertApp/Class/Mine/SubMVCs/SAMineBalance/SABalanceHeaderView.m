//
//  SABalanceHeaderView.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SABalanceHeaderView.h"

@interface SABalanceHeaderView ()
@property (nonatomic) UILabel *typeLabel;
@property (nonatomic) UILabel *modeLabel;
@property (nonatomic) UILabel *noticeLabel;
@end

@implementation SABalanceHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kColor(@"#ffffff");
        
        self.typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = kColor(@"#666666");
        _typeLabel.font = kFont(13);
        _typeLabel.numberOfLines = 0;
        _typeLabel.text = @"提现类型：目前支付微信提现";
        [self addSubview:_typeLabel];
        
        self.modeLabel = [[UILabel alloc] init];
        _modeLabel.textColor = kColor(@"#666666");
        _modeLabel.font = kFont(13);
        _modeLabel.numberOfLines = 0;
        _modeLabel.text = @"提现方式：需绑定含有您实名认证银行卡的微信号";
        [self addSubview:_modeLabel];

        self.noticeLabel = [[UILabel alloc] init];
        _noticeLabel.textColor = kColor(@"#666666");
        _noticeLabel.font = kFont(13);
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.text = @"提现到账时间：每周四进行提现金额发放，打款后请在24小时左右对账核实";
        [self addSubview:_noticeLabel];
        
        {
            [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(34));
                make.top.equalTo(self).offset(kWidth(36));
                make.height.mas_equalTo(_typeLabel.font.lineHeight);
            }];
            
            [_modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_typeLabel);
                make.top.equalTo(_typeLabel.mas_bottom).offset(kWidth(18));
                make.height.mas_equalTo(_modeLabel.font.lineHeight);
            }];
            
            [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_modeLabel);
                make.top.equalTo(_modeLabel.mas_bottom).offset(kWidth(16));
                make.right.equalTo(self.mas_right).offset(-kWidth(18));
                make.height.mas_equalTo(_noticeLabel.font.lineHeight*2);
            }];
        }
        
        
    }
    return self;
}

@end
