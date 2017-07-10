//
//  SAAccountDetailCell.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAAccountDetailCell.h"

@interface SAAccountDetailCell ()
@property (nonatomic) UILabel *statusLabel;
@property (nonatomic) UILabel *moneyLabel;
@property (nonatomic) UILabel *timeLabel;
@end

@implementation SAAccountDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = kColor(@"#333333");
        _moneyLabel.font = kFont(16);
        [self.contentView addSubview:_moneyLabel];
        
        self.statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = kColor(@"#666666");
        _statusLabel.font = kFont(14);
        [self.contentView addSubview:_statusLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kColor(@"#999999");
        _timeLabel.font = kFont(12);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        {
            [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(50));
                make.height.mas_equalTo(_moneyLabel.font.lineHeight);
            }];

            [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView.mas_left).offset(kWidth(266));
                make.height.mas_equalTo(_statusLabel.font.lineHeight);
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(50));
                make.height.mas_equalTo(_timeLabel.font.lineHeight);
            }];
        }
    }
    return self;
}

- (void)setIncomeStatus:(SAMineAccountDetailStatus)incomeStatus {
    switch (incomeStatus) {
        case SAMineAccountDetailStatusRegister:
            _statusLabel.text = @"注册奖励";
            break;
        case SAMineAccountDetailStatusSignIn:
            _statusLabel.text = @"签到奖励";
            break;
        case SAMineAccountDetailStatusShare:
            _statusLabel.text = @"分享奖励";
            break;
        case SAMineAccountDetailStatusRecruit:
            _statusLabel.text = @"招募奖励";
            break;
        case SAMineAccountDetailStatusRevenue:
            _statusLabel.text = @"分成奖励";
            break;
            
        default:
            break;
    }
}

- (void)setCount:(NSString *)count {
    _moneyLabel.text = [NSString stringWithFormat:@"+%@",count];
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

@end
