//
//  SADrawMoneyDetailVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SADrawMoneyDetailVC.h"
#import "SADrawMoneyCell.h"

static NSString *const kSADrawMoneyCellReusableIdentifier = @"kSADrawMoneyCellReusableIdentifier";

@interface SADrawMoneyDetailVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@end

@implementation SADrawMoneyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = kColor(@"#efefef");
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SADrawMoneyCell class] forCellReuseIdentifier:kSADrawMoneyCellReusableIdentifier];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SADrawMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:kSADrawMoneyCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < 10) {
        cell.drawStatus = 1;
        cell.count = @"10.00";
        cell.timeStr = @"2017-07-04";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(120);
}

@end
