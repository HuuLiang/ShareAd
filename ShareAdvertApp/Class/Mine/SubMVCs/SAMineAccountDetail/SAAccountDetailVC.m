//
//  SAAccountDetailVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAAccountDetailVC.h"
#import "SAAccountDetailCell.h"

static NSString *const kSAAccountDetailCellReusableIdentifier = @"kSAAccountDetailCellReusableIdentifier";

@interface SAAccountDetailVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@end

@implementation SAAccountDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAAccountDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:kSAAccountDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < 10) {
        cell.incomeStatus = 1;
        cell.count = @"10.00";
        cell.timeStr = @"2017-07-04";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(120);
}


@end
