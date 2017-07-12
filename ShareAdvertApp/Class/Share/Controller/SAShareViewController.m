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
#import "SAReqManager.h"


@interface SAShareViewController () <UIScrollViewDelegate,SAShareContentDelegate>
@property (nonatomic) UIScrollView *backScrollView;
@property (nonatomic) SAShareHeaderView *headerView;
@property (nonatomic) UIImageView *moreContent;
@property (nonatomic) UISliderView *sliderView;
@property (nonatomic) SAShareModel *response;
@property (nonatomic) BOOL isLogin;
@end

@implementation SAShareViewController
QBDefineLazyPropertyInitialization(SAShareModel, response)

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
    [[SAReqManager manager] fetchColumnContentWithClass:[SAShareModel class] CompletionHandler:^(BOOL success, id obj) {
        if (success) {
            self.response = obj;
            [self configContentView];
        }
    }];
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
    for (SAShareColumnModel *columnModel in self.response.columns) {
        [columnTitles addObject:columnModel.name];
    }
    _sliderView.titlesArr = columnTitles;
    [_backScrollView addSubview:_sliderView];

    for (SAShareColumnModel *columnModel in self.response.columns) {
        SAShareContentVC *contentVC = [[SAShareContentVC alloc] initWithColumnId:columnModel.columnId];
        contentVC.delegate = self;
        [_sliderView addChildViewController:contentVC title:columnModel.name];
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
    CGFloat moveDistance = scrollView.contentOffset.y;
    if (moveDistance <= 0) {
        [_backScrollView setContentOffset:CGPointZero animated:YES];
    } else if (moveDistance > _headerView.height) {
        [_backScrollView setContentOffset:CGPointMake(0, _headerView.height) animated:YES];
    }
}

@end
