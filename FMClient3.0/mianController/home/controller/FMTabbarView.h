//
//  FMTabbarView.h
//  FMClient3.0
//
//  Created by YT on 2016/10/26.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMButton.h"

@class FMTabbarView;

@protocol FMTabbarViewDelegate<NSObject>
@optional

-(void)FMTabbarView:(FMTabbarView *)tabView withButton:(UIButton *)selectBtn;

@end
@interface FMTabbarView : UIView

@property (nonatomic,assign)id<FMTabbarViewDelegate>delegate;


- (void)addTabBarButtonWithItem;

-(void)chooseHomeAction;
-(void)chooseStoresAction;
-(void)chooseOrdersAction;
//-(void)chooseMemberAction;
-(void)chooseMineAction;



-(void)homePageClick;
-(void)orderPageClick;
//-(void)memberPageClick;
-(void)minePageClick;


-(void)choosePageClickWithInter:(NSInteger)index;


@end
