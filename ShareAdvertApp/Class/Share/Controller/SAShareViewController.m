//
//  SAShareViewController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/5.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SAShareViewController.h"

#import "UISliderView.h"

#import "SAShareContentVC.h"
#import "SAShareAllContentVC.h"
#import "SAShareHeaderView.h"
#import "SAMineAlertUIHelper.h"

#import "SAShareModel.h"
#import "SAReqManager.h"
#import "SAUserAccountModel.h"
#import "SAConfigModel.h"

@interface SAShareViewController () <UIScrollViewDelegate,SAShareContentDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) SAShareHeaderView *headerView;
@property (nonatomic) UIImageView *moreContent;
@property (nonatomic) UISliderView *sliderView;
@property (nonatomic) SAShareModel *response;
@property (nonatomic) BOOL isLogin;
@property (nonatomic) SAShareContentVC *currentContentVC;
@end

@implementation SAShareViewController
QBDefineLazyPropertyInitialization(SAShareModel, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#FF3366");
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColor(@"#ffffff");
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [self fetchColumnContent];
    
    self.isLogin = [SAUtil checkUserIsLogin];
    
    if (_isLogin) {
        [self configShareTableHeaderView];
    }
    
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
//            make.left.bottom.top.equalTo(self.view);
//            make.top.equalTo(self.view).offset(64);
        }];
    }
    
    @weakify(self);
    [_tableView SA_addPullToRefreshWithHandler:^{
        @strongify(self);
        [[self currentContentVC] refreshContent];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configShareTableHeaderView) name:kSAUserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushContentVCWithColumnId:) name:kSAPushShareContentVCNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeaderViewInfo) name:kSARefreshAccountInfoNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_isLogin) {
        [self.tableView setContentOffset:CGPointMake(0, -64) animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIView * barBackground =  [self.navigationController.navigationBar.subviews firstObject];
    UIImageView *imgV = [barBackground.subviews firstObject];
    imgV.backgroundColor = kColor(@"#FF3366");
}

- (void)fetchColumnContent {
    [[SAReqManager manager] fetchColumnContentWithClass:[SAShareModel class] CompletionHandler:^(BOOL success, id obj) {
        if (success) {
            self.response = obj;
            [self configContentView];
        }
    }];
}

- (void)refreshHeaderViewInfo {
    if (_headerView) {
        _headerView.balance = [SAUserAccountModel account].account.amount;
        _headerView.toRecruit = [SAUserAccountModel account].account.todayApNumber;
        _headerView.toEarnings = [SAUserAccountModel account].account.todayAmount;
    }
}

- (void)configShareTableHeaderView {
    _isLogin = YES;
    self.headerView = [[SAShareHeaderView alloc] init];
    _headerView.size = CGSizeMake(kScreenWidth, kWidth(328));
    self.tableView.tableHeaderView = _headerView;
    
    _headerView.balance = [SAUserAccountModel account].account.amount;
    _headerView.toRecruit = [SAUserAccountModel account].account.todayApNumber;
    _headerView.toEarnings = [SAUserAccountModel account].account.todayAmount;
}

- (void)configContentView {
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.size = CGSizeMake(kScreenWidth, kScreenHeight);
    _tableView.tableFooterView = tableFooterView;
    
    self.sliderView = [[UISliderView alloc] initWithSuperView:tableFooterView];
    _sliderView.titleScrollViewFrame = CGRectMake(0, 0, kScreenWidth - kWidth(80), kWidth(80));
    _sliderView.imageBackViewColor = kColor(@"#FF3366");
    
    NSMutableArray *columnTitles = [[NSMutableArray alloc] init];
    for (SAShareColumnModel *columnModel in self.response.columns) {
        [columnTitles addObject:columnModel.name];
    }
    _sliderView.titlesArr = columnTitles;
    [tableFooterView addSubview:_sliderView];

    for (SAShareColumnModel *columnModel in self.response.columns) {
        SAShareContentVC *contentVC = [[SAShareContentVC alloc] initWithColumnId:columnModel.columnId];
        contentVC.delegate = self;
        [_sliderView addChildViewController:contentVC title:columnModel.name];
    }
    [_sliderView setSlideHeadView];
    
    self.moreContent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_more"]];
    _moreContent.frame = CGRectMake(kScreenWidth - kWidth(80), 0, kWidth(80), kWidth(78));
    _moreContent.userInteractionEnabled = YES;
    [tableFooterView addSubview:_moreContent];
    
    @weakify(self);
    [_moreContent bk_whenTapped:^{
        @strongify(self);
        [SAShareAllContentVC showAllContentVCWithDataSource:self.response.columns height:self.tableView.contentOffset.y+kWidth(328) InCurrentVC:self];
    }];
}

- (SAShareContentVC *)currentContentVC {
    if (!_sliderView) {
        return nil;
    }
    return (SAShareContentVC *)self.childViewControllers[_sliderView.selectedBtn.tag];
}

- (void)pushContentVCWithColumnId:(NSNotification *)notification {
    SAShareColumnModel *columnModel = (SAShareColumnModel *)[notification object];
    [_sliderView currentVCWithIndex:[self.response.columns indexOfObject:columnModel]];
}

#pragma mark - UITableViewDelagate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    QBLog(@"self.tableView.contentOffset.y %f",self.tableView.contentOffset.y);
//    if (!_currentContentVC) {
//        return;
//    }
//    
//    _currentContentVC = [self currentContentVC];
//    
//    if (!_currentContentVC) {
//        return;
//    }
    
    if (self.tableView.contentOffset.y >= _headerView.height - 64) {
        [self.tableView setContentOffset:CGPointMake(0, _headerView.height - 64) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}



#pragma mark - SAShareContentDelegate

- (void)observerContentScrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isLogin) {
        return;
    }
//    CGFloat moveDistance = scrollView.contentOffset.y;
//    QBLog(@"DidScroll moveDistance %f",moveDistance);
//    CGFloat currentTableViewOffsetY = self.tableView.contentOffset.y;
//    if (currentTableViewOffsetY >= - 64 && currentTableViewOffsetY <= _headerView.height - 64) {
//        [_tableView setContentOffset:CGPointMake(0, -64 + moveDistance) animated:NO];
//    }
//    if (moveDistance > 0 && moveDistance + currentTableViewOffsetY < _headerView.height - 64) {
//    }
//        else if (moveDistance > _headerView.height) {
//        [_tableView setContentOffset:CGPointMake(0, kWidth(328)) animated:NO];
//    } else if (moveDistance <= 0) {
//        [_tableView setContentOffset:CGPointZero animated:NO];
//    }
}

- (void)observerContentScrollViewBeginDragging:(UIScrollView *)scrollView {
    if (!_isLogin) {
        return;
    }
//    CGFloat moveDistance = scrollView.contentOffset.y;
//    QBLog(@"BeginDragging moveDistance %f",moveDistance);
//    if (moveDistance <= 0) {
//        [_tableView setContentOffset:CGPointZero animated:YES];
//    } else if (moveDistance > _headerView.height) {
//        [_tableView setContentOffset:CGPointMake(0, _headerView.height) animated:YES];
//    }
}

@end
