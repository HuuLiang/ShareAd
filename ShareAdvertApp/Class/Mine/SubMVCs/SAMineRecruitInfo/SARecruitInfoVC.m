//
//  SARecruitInfoVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARecruitInfoVC.h"
#import "SARecruitHeaderView.h"
#import "SARecruitInfoCell.h"

static NSString *const kSAMineRecruitCellReusableIdentifier = @"kSAMineRecruitCellReusableIdentifier";

@interface SARecruitInfoVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SARecruitHeaderView *headerView;
@end

@implementation SARecruitInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#ffffff");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[SARecruitInfoCell class] forCellReuseIdentifier:kSAMineRecruitCellReusableIdentifier];
    [self.view addSubview:_tableView];
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self configHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configHeaderView {
    self.headerView = [[SARecruitHeaderView alloc] init];
    _headerView.recruitCount = @"2";
    _headerView.revenueCount = @"5";
    _headerView.incomeCount = @"0";
    _headerView.size = CGSizeMake(kScreenWidth, kWidth(100));
    _tableView.tableHeaderView = _headerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SARecruitInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kSAMineRecruitCellReusableIdentifier forIndexPath:indexPath];
    if (cell) {
        cell.nickName = @"Liang";
        cell.userId = @"93867";
        cell.recruitTime = @"2017-7-17 14:55:55";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(80);
}

@end
