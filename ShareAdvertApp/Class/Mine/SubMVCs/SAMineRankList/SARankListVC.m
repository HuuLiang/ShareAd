//
//  SARankListVC.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/8.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SARankListVC.h"
#import "UISliderView.h"
#import "SARankDetailVC.h"

@interface SARankListVC ()
@property (nonatomic) UISliderView *sliderView;
@end

@implementation SARankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sliderView = [[UISliderView alloc] initWithSuperView:self.view];
    _sliderView.titleScrollViewFrame = CGRectMake(0, 0, kScreenWidth, kWidth(80));
    _sliderView.imageBackViewColor = kColor(@"#FF3366");
    _sliderView.imageBackViewFrame = CGRectMake(kWidth(80), kWidth(80) - 3.5, kWidth(170), 3);
    
    NSArray *titles = @[@"收益排行榜",@"收徒排行榜"];
    _sliderView.titlesArr = titles;
    [self.view addSubview:_sliderView];
    
    for (NSString *title in titles) {
        SARankDetailVC *detailVC = [[SARankDetailVC alloc] init];
        [_sliderView addChildViewController:detailVC title:title];
    }
    [_sliderView setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
