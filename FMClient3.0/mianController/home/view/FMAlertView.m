//
//  FMAlertView.m
//  FMClient3.0
//
//  Created by YT on 2016/12/27.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "FMAlertView.h"
#import "Tools.h"

@implementation FMAlertView


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
-(void)configAlertViewData:(NSString *)alertStr
{
    CGSize  size = [Tools sizeOfStr:alertStr withFont:[UIFont systemFontOfSize:13] withMaxWidth:SCREEN_WIDTH - 30 withLineBreakMode:(NSLineBreakByWordWrapping)];
    self.alertViewHeight.constant = size.height * 1.15 + 50;
    
    self.alertLabel.text = alertStr;
    
    
}
- (IBAction)cancleBtnClick:(id)sender {
    [self removeFromSuperview];
}

@end
