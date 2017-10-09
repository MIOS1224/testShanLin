//
//  MineViewController.m
//  FMClient3.0
//
//  Created by YT on 2017/3/27.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "MineViewController.h"
#import "FMShareController.h"

@interface MineViewController ()<UIWebViewDelegate>

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubWebView];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self configSubWebView];
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
    self.currentUrl = [NSString stringWithFormat:@"%@/%@%@",NEWLOADURL,@"me",@".html?native=1"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.currentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    //    self.webView.scrollView.delegate = self;
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (navigationType == UIWebViewNavigationTypeOther||navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSString * url = [NSString stringWithFormat:@"%@",request.URL];
        NSLog(@"mine's url ==%@",url);
        if ([[[url componentsSeparatedByString:@"#"] lastObject] isEqualToString: @"orders"]) {
            [[FMTabbar sharedManager]chooseOrderPage];
            return NO;
        }
        if (![[self getChangeUrlWithTarget:url ] isEqualToString:[self getChangeUrlWithTarget:self.currentUrl]]) {
            if ([[self.tabBarController.viewControllers lastObject]isKindOfClass:NSClassFromString(@"FMShareController")])
            {
                self.shareCtrl = [self.tabBarController.viewControllers lastObject];
            }else
            {
                self.shareCtrl = [[FMShareController alloc]init];
                [self.tabBarController addChildViewController:self.shareCtrl];
            }
            
            self.shareCtrl.urlStr = nil;
            self.shareCtrl.urlStr = url;
            self.shareCtrl.backStr = self.currentUrl;
            self.shareCtrl.backIndex = 0;
            [self turnShareCtrlAnimation];
            self.tabBarController.selectedIndex = 4;
            
            
            return NO;
        }
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


@end
