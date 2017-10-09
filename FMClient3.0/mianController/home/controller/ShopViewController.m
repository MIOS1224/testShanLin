//
//  ShopViewController.m
//  FMClient3.0
//
//  Created by YT on 2017/1/5.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()
@property (nonatomic,strong)UIWebView *WebView;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [self addNaviGationBarView];
    
    self.navigationItem.title = @"到店服务";
    
    
    [self addSubWebView];
    
}
-(void)addNaviGationBarView
{
    UIView * barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    barView.backgroundColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    [self.view addSubview:barView];

    
}
-(void)addSubWebView
{
    self.WebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:self.WebView];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://192.168.1.44:82/m2/index.html#pageOfflineStore"]];
    [self.WebView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
