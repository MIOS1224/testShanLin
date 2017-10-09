//
//  FMTabbarView.m
//  FMClient3.0
//
//  Created by YT on 2016/10/26.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "FMTabbarView.h"

@interface FMTabbarView ()

@property (nonatomic, strong) NSMutableArray * tabBarButtons;
@property (nonatomic, strong) FMButton * selectedButton;
@property (nonatomic,assign)NSInteger indexValue;

- (void)buttonClick:(FMButton *)button;

@end
@implementation FMTabbarView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.indexValue = 0;
        self.backgroundColor = [UIColor colorWithDtString:@"#f2f2f2"];
    }
    return self;
}

-(void)chooseHomeAction
{
    FMButton * btn = self.tabBarButtons[0];
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
}
-(void)chooseStoresAction
{
    FMButton * btn = self.tabBarButtons[1];
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
}
-(void)chooseOrdersAction
{
    FMButton * btn = self.tabBarButtons[2];
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
}
-(void)chooseMemberAction
{
    FMButton * btn = self.tabBarButtons[3];
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
}
-(void)chooseMineAction
{
    FMButton * btn = self.tabBarButtons[3];
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
}



-(void)choosePageClickWithInter:(NSInteger)index
{
    FMButton * btn = self.tabBarButtons[index];
    [self buttonClick:btn];
}

-(void)homePageClick
{
    FMButton * btn = self.tabBarButtons[0];
    [self buttonClick:btn];
}
-(void)orderPageClick
{
    FMButton * btn = self.tabBarButtons[1];
    [self buttonClick:btn];
}
-(void)memberPageClick
{
    FMButton * btn = self.tabBarButtons[2];
    [self buttonClick:btn];
}
-(void)minePageClick
{
    FMButton * btn = self.tabBarButtons[3];
    [self buttonClick:btn];
}
- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

-(void)addLineView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self addSubview:view];
    
    view.backgroundColor = [UIColor colorWithDtString:@"#f2f2f2"];
    
}
- (void)addTabBarButtonWithItem
{
    NSArray * names  = @[@"首页",@"门店",@"订单",@"我的"];
    NSArray * images = @[@"home",@"stores",@"order",@"me"];
    NSArray * secMsg = @[@"home-active",@"stores-active",@"order-active",@"me-active@2x"];
    
    for (NSInteger index = 0; index<names.count; index ++) {
        
        FMButton *button = [[FMButton alloc] init];
        
        [button setTitle:names[index] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:images[index]] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:secMsg[index]] forState:(UIControlStateSelected)];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + index;
        
        [self addSubview:button];
        [self.tabBarButtons addObject:button];
    }
    
    [self addLineView];
    
    if (self.tabBarButtons.count == 4) {
        FMButton * btn = [self.tabBarButtons firstObject];
        [self buttonClick:btn];
    }
}

- (void)buttonClick:(FMButton *)button
{
    // 1.通知代理
    
    if (self.selectedButton == button) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(FMTabbarView:withButton:)]) {
        [self.delegate FMTabbarView:self withButton:button];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor colorWithDtString:@"#f2f2f2"];
    
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    CGFloat buttonH = h;
    CGFloat buttonW = w / 4;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.tabBarButtons.count; index++) {
        
        FMButton *button = self.tabBarButtons[index];
        
        CGFloat buttonX = index * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        button.tag = index;
    }
}

@end
