//
//  SAShareContentVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareContentVC.h"
#import "SAShareContentCell.h"
#import "SAShareContentModel.h"

static NSString *const kSAShareContentCellReusableIdentifier = @"kSAShareContentCellReusableIdentifier";

@interface SAShareContentVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) NSString *columnId;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) SAShareContentModel *contentModel;
@end

@implementation SAShareContentVC
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(SAShareContentModel, contentModel)

- (instancetype)initWithColumnId:(NSString *)columnId
{
    self = [super init];
    if (self) {
        _columnId = columnId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#ffffff");
    [_tableView registerClass:[SAShareContentCell class] forCellReuseIdentifier:kSAShareContentCellReusableIdentifier];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setSeparatorColor:kColor(@"#efefef")];
//    _tableView.scrollEnabled = NO;
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
        [self fetchSourceWithColumnId:self.columnId];
    }];
    
    [_tableView SA_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setEnableScroll:(BOOL)enableScroll {
    _tableView.scrollEnabled = enableScroll;
}

- (void)fetchSourceWithColumnId:(NSString *)columnId {
    [self.dataSource removeAllObjects];
    for (NSInteger i = 0; i < 10; i++) {
        SAShareContentProgramModel *programModel = [[SAShareContentProgramModel alloc] init];
        [self.dataSource addObject:programModel];
    }
    [self.tableView SA_endPullToRefresh];
    [self.tableView reloadData];
    
//    @weakify(self);
//    [self.contentModel fetchColumnContentWithColumnId:self.columnId CompletionHandler:^(BOOL success, id obj) {
//        @strongify(self);
//        [self.tableView SA_endPullToRefresh];
//        if (success) {
//            [self.dataSource removeAllObjects];
//            [self.dataSource addObjectsFromArray:obj];
//            [self.tableView reloadData];
//        }
//    }];
}

#pragma mark - UITableViewDelegate,UITalbeViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAShareContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kSAShareContentCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.count) {
        SAShareContentProgramModel *programModel = self.dataSource[indexPath.row];
        cell.imgUrl = @"";
        cell.specilTitle = @"限时上涨到2毛";
        cell.title = @"边玩边赚，还可以天天赢红包，最高200%收益，让红包非起来！";
        cell.price = @"高价  0.200元/阅读";
        cell.read = @"阅读:20438";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(200);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(observerContentScrollViewDidScroll:)]) {
        [self.delegate observerContentScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([[self delegate] respondsToSelector:@selector(observerContentScrollViewBeginDragging:)]) {
        [self.delegate observerContentScrollViewBeginDragging:scrollView];
    }
}

@end
