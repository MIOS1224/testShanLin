//
//  FMTabbar.h
//  FMClient3.0
//
//  Created by YT on 2017/3/27.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FMTabbar;

@protocol FMTabBarBtnDelegate <NSObject>

@optional
- (void)tabBar:(FMTabbar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;
- (void)tabBarDidClickedPlusButton:(FMTabbar *)tabBar;

@end
@interface FMTabbar : UIView


@property (nonatomic, weak) id<FMTabBarBtnDelegate> delegate;
+(instancetype)sharedManager;
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

-(void)chooseHomePage;
-(void)chooseStorePage;
-(void)chooseOrderPage;
-(void)chooseMinePage;

@end
