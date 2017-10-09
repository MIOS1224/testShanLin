//
//  FMLogViewController.m
//  FMClient3.0
//
//  Created by YT on 2017/3/29.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "FMLogViewController.h"

@interface FMLogViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)UIWebView * loadImage;

@end

@implementation FMLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubWebView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView reload];
    
}

#pragma mark ------- config webview ------
-(void)configSubWebView
{
    if (!self.webView) {
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 69 )];
        [self.view addSubview:self.webView];
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        self.webView.scrollView.showsVerticalScrollIndicator   = NO;
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.bounces = NO;
        self.webView.delegate = self;
        
    }
    
    if (!self.loadImage) {
        
        NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"loading10 3" ofType:@"gif"]];
        self.loadImage = [[UIWebView alloc] initWithFrame:CGRectMake(0,(SCREEN_HEIGHT - 94 - 128)/2,SCREEN_WIDTH,SCREEN_HEIGHT - 94)];
        [self.loadImage loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [self.view addSubview:self.loadImage];
        self.loadImage.userInteractionEnabled = NO;
    }
    
    self.loadImage.hidden = NO;
    NSString * url = [NSString stringWithFormat:@"%@/%@%@",NEWLOADURL,@"log",@".html?native=1"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    //    self.webView.scrollView.delegate = self;
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (navigationType == UIWebViewNavigationTypeOther||navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSString * url = [NSString stringWithFormat:@"%@",request.URL];
        
        BOOL res = [[FMTabbarAppear sharedManager]checkTabbarWithUrl:url];
        res ? [self hideTabbar]:[self showTabbar];
        
    }
    
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        
        self.loadImage.hidden = YES;
    }
}
-(void)showTabbar
{
    CGRect fram = self.webView.frame;
    fram.size.height = SCREEN_HEIGHT - 69;
    self.webView.frame = fram;
    self.tabBarController.tabBar.hidden = NO;
}
-(void)hideTabbar
{
    CGRect fram = self.webView.frame;
    fram.size.height = SCREEN_HEIGHT - 20;
    self.webView.frame = fram;
    self.tabBarController.tabBar.hidden = YES;
}

@end
