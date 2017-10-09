//
//  MYBaseNavController.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MYBaseNavController.h"
#import "UIColor+MYColorString.h"

@implementation MYBaseNavController
+ (void)initialize
{
    [self setNaviBarTheme];
    
    [self setupBarButtonItemTheme];
    
}
/**
 *  设置导航栏主题
 */
+(void)setNaviBarTheme
{
    UINavigationBar * navBar = [UINavigationBar appearance];
    if (IS_OS_7_OR_LATER) {
        navBar.barTintColor  = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    }
    
//    [navBar setBackgroundImage:[UIImage imageNamed:@"navigation_background.png"] forBarMetrics:(UIBarMetricsDefault)];
    navBar.translucent = NO;
    navBar.barTintColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    //    navBar.barStyle = UIBarStyleDefault;
    
    
    NSMutableDictionary * textAtt = [NSMutableDictionary dictionary];
    textAtt[NSFontAttributeName]  = [UIFont systemFontOfSize:17];
    
    textAtt[NSForegroundColorAttributeName] = [UIColor colorWithDtString:@"#ffffff"];
    
    [navBar setTitleTextAttributes:textAtt];
    
}
/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    
    // 设置文字格式
    NSMutableDictionary * textAttrs      = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName]   = [UIFont systemFontOfSize:TEXT_SIZE];
    
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (IOS7) {
        
        self.edgesForExtendedLayout                         = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars               = NO;
        self.modalPresentationCapturesStatusBarAppearance   = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
}


@end
