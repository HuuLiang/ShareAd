//
//  SATabBarController.m
//  ShareAdvertApp
//
//  Created by Liang on 2017/7/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "SATabBarController.h"
#import "SANavigationController.h"
#import "SAShareViewController.h"
#import "SARecruitViewController.h"
#import "SAMineViewController.h"

@interface SATabBarController () <UITabBarControllerDelegate>

@end

@implementation SATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)configViewControllers {
    SAShareViewController *shareVC = [[SAShareViewController alloc] initWithTitle:@"微金赚"];
    SANavigationController *shareNav = [[SANavigationController alloc] initWithRootViewController:shareVC];
    shareNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分享赚钱"
                                                        image:[[UIImage imageNamed:@"tabbar_share_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                selectedImage:[[UIImage imageNamed:@"tabbar_share_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    SARecruitViewController *recruitVC = [[SARecruitViewController alloc] initWithTitle:@"收徒赚钱"];
    SANavigationController *recruitNav = [[SANavigationController alloc] initWithRootViewController:recruitVC];
    recruitNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:recruitVC.title
                                                          image:[[UIImage imageNamed:@"tabbar_recruit_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:@"tabbar_recruit_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    SAMineViewController *mineVC = [[SAMineViewController alloc] initWithTitle:@"个人中心"];
    SANavigationController *mineNav = [[SANavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                       image:[[UIImage imageNamed:@"tabbar_mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    self.tabBar.translucent = NO;
    self.delegate = self;
    self.viewControllers = @[shareNav,recruitNav,mineNav];
}

@end
