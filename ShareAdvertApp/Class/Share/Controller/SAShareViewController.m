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
#import "SAShareModel.h"



@interface SAShareViewController () <UIScrollViewDelegate,SAShareContentDelegate>
@property (nonatomic) UIScrollView *backScrollView;
@property (nonatomic) SAShareHeaderView *headerView;
@property (nonatomic) UIImageView *moreContent;
@property (nonatomic) UISliderView *sliderView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) SAShareModel *shareModel;
@property (nonatomic) BOOL isLogin;
@end

@implementation SAShareViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(SAShareModel, shareModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor(@"#FF3366");
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backScrollView.backgroundColor = kColor(@"#FFFFFF");
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.delegate = self;
    [self.view addSubview:_backScrollView];
    
    [self fetchColumnContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isLogin = [SAUtil checkUserIsLogin];
    _backScrollView.contentOffset = CGPointMake(0, _isLogin ? 0 :kWidth(328));
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _backScrollView.contentSize = CGSizeMake(kScreenWidth, _headerView.height + kScreenHeight);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIView * barBackground =  [self.navigationController.navigationBar.subviews firstObject];
    UIImageView *imgV = [barBackground.subviews firstObject];
    imgV.backgroundColor = kColor(@"#FF3366");
}


- (void)fetchColumnContent {
    [self.dataSource removeAllObjects];
    NSArray *arr = @[@"推荐",@"热点",@"高价",@"美女",@"娱乐",@"游戏",@"电影",@"图片",@"蘑菇",@"洋葱"];
    for (NSInteger i = 0; i < 10 ; i ++) {
        SAShareColumnModel *columnModel = [[SAShareColumnModel alloc] init];
        columnModel.columnId = [NSString stringWithFormat:@"%ld",i];
        columnModel.columnName = arr[i];
        [self.dataSource addObject:columnModel];
    }
    [self configContentView];
//    [self.view endLoading];
//    [self.shareModel fetchShareColumnContent:^(BOOL success, NSArray * obj) {
//        [self.view endLoading];
//        if (success) {
//            [self.dataSource addObjectsFromArray:obj];
//            [self configContentView];
//        }
//    }];
}

- (void)configContentView {
    
    self.headerView = [[SAShareHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(328))];
    _headerView.balance = @"2.060";
    _headerView.toRecruit = @"0";
    _headerView.toEarnings = @"0.030";
    [_backScrollView addSubview:_headerView];
    
    self.sliderView = [[UISliderView alloc] initWithSuperView:_backScrollView];
    _sliderView.titleScrollViewFrame = CGRectMake(0, kWidth(328), kScreenWidth - kWidth(80), kWidth(80));
    _sliderView.imageBackViewColor = kColor(@"#FF3366");
    
    NSMutableArray *columnTitles = [[NSMutableArray alloc] init];
    for (SAShareColumnModel *columnModel in self.dataSource) {
        [columnTitles addObject:columnModel.columnName];
    }
    _sliderView.titlesArr = columnTitles;
    [_backScrollView addSubview:_sliderView];

    for (SAShareColumnModel *columnModel in self.dataSource) {
        SAShareContentVC *contentVC = [[SAShareContentVC alloc] init];
//        contentVC.enableScroll = YES;
        contentVC.delegate = self;
        [_sliderView addChildViewController:contentVC title:columnModel.columnName];
    }
    [_sliderView setSlideHeadView];
    
    self.moreContent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_more"]];
    _moreContent.frame = CGRectMake(kScreenWidth - kWidth(80), kWidth(328), kWidth(80), kWidth(78));
    _moreContent.userInteractionEnabled = YES;
    [_backScrollView addSubview:_moreContent];
    
    @weakify(self);
    [_moreContent bk_whenTapped:^{
        @strongify(self);
        [SAShareAllContentVC showAllContentVCInCurrentVC:self];
    }];
    _backScrollView.scrollEnabled = NO;
}

- (SAShareContentVC *)currentContentVC {
    return (SAShareContentVC *)self.childViewControllers[_sliderView.selectedBtn.tag];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}



#pragma mark - SAShareContentDelegate

- (void)observerContentScrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isLogin) {
        return;
    }
    CGFloat moveDistance = scrollView.contentOffset.y;
    if (moveDistance > 0 && moveDistance < _headerView.height) {
        [_backScrollView setContentOffset:CGPointMake(0, moveDistance) animated:NO];
    }
}

- (void)observerContentScrollViewBeginDragging:(UIScrollView *)scrollView {
    if (!_isLogin) {
        return;
    }
//    QBLog(@"%@ %f",NSStringFromCGPoint(scrollView.contentOffset),kWidth(328));
    CGFloat moveDistance = scrollView.contentOffset.y;
    if (moveDistance <= 0) {
        [_backScrollView setContentOffset:CGPointZero animated:YES];
    } else if (moveDistance > _headerView.height) {
        [_backScrollView setContentOffset:CGPointMake(0, _headerView.height) animated:YES];
    }
}

@end
