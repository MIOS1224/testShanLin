//
//  HomePullView.m
//  FMClient3.0
//
//  Created by YT on 2016/11/25.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "HomePullView.h"

@implementation HomePullView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.SHCity.layer.borderWidth = 0.5;
    self.SHCity.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.YWCity.layer.borderWidth = 0.5;
    self.YWCity.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.currentCityBtn.layer.borderWidth = 0.5;
    self.currentCityBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}
- (IBAction)SHButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HomePullView:andChooseBtn:)]) {
        [self.delegate HomePullView:self andChooseBtn:self.SHCity];
    }
}
- (IBAction)YWButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(HomePullView:andChooseBtn:)]) {
        [self.delegate HomePullView:self andChooseBtn:self.YWCity];
    }
}


@end
