//
//  SARankDetailVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARankDetailVC.h"
#import "SARankDetailCell.h"

static NSString *const kSARankDetailCellReusableIdentifier = @"kSARankDetailCellReusableIdentifier";

@interface SARankDetailVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@end

@implementation SARankDetailVC

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SARankDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:kSARankDetailCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < 10) {
        cell.portraitUrl = @"";
        cell.nickName = @"Liang";
        cell.count = @"123";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(130);
}


@end
