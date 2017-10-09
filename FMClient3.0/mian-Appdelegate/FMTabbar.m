//
//  FMTabbar.m
//  FMClient3.0
//
//  Created by YT on 2017/3/27.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "FMTabbar.h"
#import "FMTabbarButton.h"

@interface FMTabbar()
@property (nonatomic, strong) NSMutableArray * tabBarButtons;
@property (nonatomic, strong) FMTabbarButton * selectedButton;

@end

@implementation FMTabbar
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
+(instancetype)sharedManager{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}
-(void)backHomeViewCtrl
{
    FMTabbarButton * btn = self.tabBarButtons[0];
    [self buttonClick:btn];
}
- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (void)plusButtonClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
        [self.delegate tabBarDidClickedPlusButton:self];
    }
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    
    FMTabbarButton *button = [[FMTabbarButton alloc] init];
    [self addSubview:button];
    [self.tabBarButtons addObject:button];
    button.item = item;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

- (void)buttonClick:(FMTabbarButton *)button
{
    // 1.通知代理
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor colorWithDtString:@"#f0f8fb"];
    
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    CGFloat buttonH = h;
    CGFloat buttonW = w / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index<self.tabBarButtons.count; index++) {
        
        FMTabbarButton *button = self.tabBarButtons[index];
        
        CGFloat buttonX = index * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        
        button.tag = index;
    }
}
-(void)chooseHomePage
{
    self.hidden = NO;
    [self buttonClick:self.tabBarButtons[0]];
    
}
-(void)chooseStorePage
{
    self.hidden = NO;
    [self buttonClick:self.tabBarButtons[1]];
}
-(void)chooseOrderPage
{
    self.hidden = NO;
    [self buttonClick:self.tabBarButtons[2]];
}
-(void)chooseMinePage
{
    self.hidden = NO;
    [self buttonClick:self.tabBarButtons[3]];
}

@end

