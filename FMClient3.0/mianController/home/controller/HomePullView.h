//
//  HomePullView.h
//  FMClient3.0
//
//  Created by YT on 2016/11/25.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomePullView;
@protocol HomePullViewDelegate<NSObject>
@optional
-(void)HomePullView:(HomePullView *)pullView andChooseBtn:(UIButton *)chooseBtn;

@end
@interface HomePullView : UIView
@property (weak, nonatomic) IBOutlet UILabel *GPSCityName;
@property (weak, nonatomic) IBOutlet UIButton *SHCity;
@property (weak, nonatomic) IBOutlet UIButton *YWCity;
@property (weak, nonatomic) IBOutlet UIButton *currentCityBtn;



@property (weak,nonatomic)id <HomePullViewDelegate>delegate;

@end
