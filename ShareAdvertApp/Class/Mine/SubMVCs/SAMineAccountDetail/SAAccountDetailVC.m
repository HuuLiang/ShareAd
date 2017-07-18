//
//  SAAccountDetailVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAAccountDetailVC.h"
#import "SAAccountDetailCell.h"
#import "SAAccountDetailModel.h"
#import "SAReqManager.h"

static NSString *const kSAAccountDetailCellReusableIdentifier = @"kSAAccountDetailCellReusableIdentifier";

@interface SAAccountDetailVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSInteger page;
@property (nonatomic) SAAccountDetailModel *response;
@end

@implementation SAAccountDetailVC
QBDefineLazyPropertyInitialization(SAAccountDetailModel, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SAAccountDetailCell class] forCellReuseIdentifier:kSAAccountDetailCellReusableIdentifier];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_tableView SA_addPullToRefreshWithHandler:^{
        @strongify(self);
        self.page = 0;
        [self fetchAccountDetailWithPage:self.page];
    }];
    
    [_tableView SA_addPagingRefreshWithHandler:^{
        @strongify(self);
        self.page++;
        [self fetchAccountDetailWithPage:self.page];
    }];
    
    [_tableView SA_triggerPullToRefresh];
}

- (void)fetchAccountDetailWithPage:(NSInteger)page {
    @weakify(self);
    [[SAReqManager manager] fetchAccountDetailWithPage:self.page class:[SAAccountDetailModel class] handler:^(BOOL success, id obj) {
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
    return self.response.accounting.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAAccountDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:kSAAccountDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.response.accounting.count) {
        SADetailModel *detailModel = self.response.accounting[indexPath.row];
        cell.type = detailModel.type;
        cell.count = [NSString stringWithFormat:@"%.2f",(float)detailModel.amount/100];
        cell.timeStr = detailModel.createTime;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(120);
}


@end
