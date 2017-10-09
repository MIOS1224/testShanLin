//
//  NewjourneyViewController.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "NewjourneyViewController.h"
#import "AllOrderController.h"
#import "WaitPayController.h"
#import "WaitServeController.h"
#import "ServingViewController.h"
#import "WaitEvaluateController.h"
#import "FMTabbarView.h"
//#import "LoginViewController.h"

@interface NewjourneyViewController ()<UIScrollViewDelegate,FMTabbarViewDelegate>

@property (nonatomic,strong)FMTabbarView * tabView;
@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)NSArray * btnArray;
@property (nonatomic,strong)NSArray * ctrlArray;
@property (nonatomic,strong)UIView  * bottomView;

@property (nonatomic,assign)NSInteger index;

@end

@implementation NewjourneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    [self configData];
    [self addSubTabView];
}
#pragma mark ------- add tabview   -------------
- (void)addSubTabView
{
    self.tabView = [[FMTabbarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - 64, SCREEN_WIDTH, 49)];
    [_tabView addTabBarButtonWithItem];
    _tabView.backgroundColor = [UIColor redColor];
    [_tabView chooseOrdersAction];
    _tabView.delegate = self;
    [self.view addSubview:_tabView];
}
#pragma mark ---------- tabview delegate ---------
-(void)FMTabbarView:(FMTabbarView *)tabView withButton:(UIButton *)selectBtn
{
    NSInteger tag = selectBtn.tag;
    
    if (tag == 2) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(OrderViewCtrl:andIndexTag:)]) {
        
       [self.delegate OrderViewCtrl:self andIndexTag:tag];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}
- (void)configData
{
    self.btnArray = @[@"全部",@"待付款",@"待服务",@"服务中",@"待评价"];
    AllOrderController * all = [[AllOrderController alloc]init];
    WaitPayController  * pay = [[WaitPayController alloc]init];
    
    WaitServeController * serve    = [[WaitServeController alloc]init];
    ServingViewController *serving = [[ServingViewController alloc]init];
    WaitEvaluateController * evaluate = [[WaitEvaluateController alloc]init];
    
    self.ctrlArray = @[all,pay,serve,serving,evaluate];
    [self addSubViews];
    
}
- (void)addSubViews
{
    NSInteger index = self.btnArray.count;
    CGFloat width   = SCREEN_WIDTH/index;
    CGFloat height  = 40.0;
    
    for (NSInteger i = 0; i < index; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.btnArray[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(width * i,0, width, height);
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(changOrderModel:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag = 1000 + i;
        
        
        [self.view addSubview:btn];
    }
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.frame = CGRectMake(0, 40, width, 2);
    self.bottomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.bottomView];
    
    
    UIView * lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 42, SCREEN_WIDTH, 1);
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, SCREEN_HEIGHT - 43 - 49 - 64)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.ctrlArray.count, 0);
    self.scrollView.pagingEnabled = YES;
    
    
    NSInteger ctrTag = self.ctrlArray.count;
    
    for (NSInteger i = 0; i < ctrTag; i++) {
        
        UIViewController * ctrl = self.ctrlArray[i];
        ctrl.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.scrollView.frame.size.height);
        
        [self.scrollView addSubview:ctrl.view];
    }
}

- (void)changOrderModel:(UIButton *)btn
{
    NSInteger tag = btn.tag - 1000;
    [UIView animateWithDuration:0.3 animations:^{
    
        CGRect fram = self.bottomView.frame;
        fram.origin.x = btn.frame.origin.x;
        self.bottomView.frame = fram;
    
        self.scrollView.contentOffset = CGPointMake(tag * SCREEN_WIDTH,0);
        
    }];
    

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    CGFloat width = SCREEN_WIDTH/self.btnArray.count * index;
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect fram = self.bottomView.frame;
        fram.origin.x = width;
        self.bottomView.frame = fram;
        
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}

@end
