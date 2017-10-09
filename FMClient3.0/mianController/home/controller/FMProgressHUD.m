//
//  FMProgressHUD.m
//  FMClient3.0
//
//  Created by YT on 2017/2/22.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "FMProgressHUD.h"

@implementation FMProgressHUD

+(instancetype)sharedManager
{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
-(void)showProgress:(UIView *)baseView WithTextValue:(NSString *)textValue
{
    self.hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.hud.center = baseView.center;
    
    [baseView addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.bezelView.color = [UIColor blackColor];
    self.hud.activityIndicatorColor = [UIColor whiteColor];
    self.hud.opacity = 1;
    
    self.hud.label.textColor = [UIColor whiteColor];
    self.hud.label.font = [UIFont systemFontOfSize:13];
    
    self.hud.label.text = textValue;
    [self.hud showAnimated:YES];
}
-(void)dismiss
{
    [self.hud hideAnimated:YES];
}

@end
