//
//  FMTabbarViewController.m
//  feimaxing
//
//  Created by will on 15/7/30.
//  Copyright (c) 2015年 FM. All rights reserved.
//

#import "FMTabbarViewController.h"
#import "HomeViewController.h"
#import "StoreViewController.h"
#import "OrderViewController.h"
#import "MineViewController.h"
#import "FMTabbar.h"

@interface FMTabbarViewController ()<FMTabBarBtnDelegate>

@property (nonatomic,strong)FMTabbar * customTabBar;
@property (nonatomic,strong)HomeViewController * home;
@property (nonatomic,strong)StoreViewController * store;
@property (nonatomic,strong)OrderViewController * order;
@property (nonatomic,strong)MineViewController * mine;

@end

@implementation FMTabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self setupTabbar];
    
    [self setupAllChildViewControllers];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)setupTabbar
{
    self.customTabBar      = [FMTabbar sharedManager];
    _customTabBar.frame    = self.tabBar.bounds;
    _customTabBar.delegate = self;
    [self.tabBar addSubview:_customTabBar];
}

#pragma mark - tabbar的代理方法
- (void)tabBar:(FMTabbar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    
    if (to == self.selectedIndex) {
        return;
    }
    if (!(to == 0)) {
        
        CATransition *animation =[CATransition animation];
        [animation setDuration:0.5f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setType:kCATransitionFade];
        [animation setSubtype:kCATransitionFromTop];
        [self.view.layer addAnimation:animation forKey:@"switchView"];
 
    }
    
    if (to != 4) {
        if ([[self.viewControllers lastObject]isKindOfClass:NSClassFromString(@"FMShareController")]) {
            FMShareController * share = [self.viewControllers lastObject];
            if (share) {
                
                share.webView = nil;
                share.urlStr = nil;
                share.backStr = nil;
            }
        }
        
        
    }
    
    self.selectedIndex = to;

}
- (void)setupAllChildViewControllers
{
    self.home   = [[HomeViewController alloc] init];
    self.store  = [[StoreViewController  alloc] init];
    self.order  = [[OrderViewController  alloc] init];
    self.mine   = [[MineViewController   alloc] init];
    
    [self setupChildViewController:_home  withTitle:@"首页" imageName:@"home"  selectedName:@"home-active"];
    [self setupChildViewController:_store withTitle:@"门店" imageName:@"stores"selectedName:@"stores-active"];
    [self setupChildViewController:_order withTitle:@"订单" imageName:@"order" selectedName:@"order-active"];
    [self setupChildViewController:_mine  withTitle:@"我的" imageName:@"me"    selectedName:@"me-active@2x"];

}

-(void)setupChildViewController:(UIViewController *)childVc withTitle:(NSString *)title imageName:(NSString *)imageName selectedName:(NSString *)selectName
{
   
//    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImage   = [UIImage imageNamed:selectName];
    if (IOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    [self addChildViewController:childVc];
    
    // 添加tabbar内部的按钮
    [[FMTabbar sharedManager]addTabBarButtonWithItem:childVc.tabBarItem];
//    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

@end
