//
//  HomeStateView.h
//  FMClient3.0
//
//  Created by YT on 2016/12/9.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeStateView;

@protocol HomeStateViewDelegate<NSObject>
@optional

-(void)HomeStateView:(HomeStateView *)stateView;
-(void)HomeStateView:(HomeStateView *)stateView stateClick:(UILabel *)stateLabel;

@end

@interface HomeStateView : UIView

@property(nonatomic,weak)id<HomeStateViewDelegate>  delegate;

@property (nonatomic,strong)NSString * titleStr;
@property (nonatomic,strong)NSArray * weatherArr;

@end
