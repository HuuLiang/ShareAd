//
//  SARankDetailVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARankDetailVC.h"
#import "SARankDetailCell.h"
#import "SAReqManager.h"
#import "SARankingModel.h"

static NSString *const kSARankDetailCellReusableIdentifier = @"kSARankDetailCellReusableIdentifier";

@interface SARankDetailVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SARankingListType type;
@property (nonatomic) SARankingModel *response;
@end

@implementation SARankDetailVC
QBDefineLazyPropertyInitialization(SARankingModel, response)

- (instancetype)initWithType:(SARankingListType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SARankDetailCell class] forCellReuseIdentifier:kSARankDetailCellReusableIdentifier];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kWidth(80));
        }];
    }
    
    @weakify(self);
    [_tableView SA_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self fetchRankingListInfo];
    }];
    
    [_tableView SA_triggerPullToRefresh];

}

- (void)fetchRankingListInfo {
    @weakify(self);
    [[SAReqManager manager] fetchRankingListWithType:self.type
                                               class:[SARankingModel class]
                                             handler:^(BOOL success, id obj)
    {
        @strongify(self);
        [self.tableView SA_endPullToRefresh];
        if (success) {
            self.response = obj;
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.response.ranking.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SARankDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:kSARankDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.response.ranking.count) {
        SARankDetailModel *detailModel = self.response.ranking[indexPath.row];
        cell.portraitUrl = detailModel.portraitUrl;
        cell.nickName = detailModel.nickName;
        cell.count = [NSString stringWithFormat:@"%ld",(long)detailModel.value];
        if (self.type == SARankingListTypeIncome) {
            cell.title = @"累计收益";
        } else if (self.type == SARankingListTypeRecruit) {
            cell.title = @"累计收徒";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(130);
}


@end
