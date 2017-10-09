//
//  FMBasicViewController.m
//  FMClient3.0
//
//  Created by YT on 2017/3/28.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "FMHomeViewController.h"
#import "FMProgressHUD.h"

@interface FMHomeViewController ()<UIWebViewDelegate>



@end

@implementation FMHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[FMProgressHUD sharedManager] dismiss];
        [self configSubWebView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[FMProgressHUD sharedManager] dismiss];
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
    self.currentUrl = [NSString stringWithFormat:@"%@/%@%@",NEWLOADURL,@"index",@".html?native=2"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.currentUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    [self.webView loadRequest:request];
    
}

#pragma mark ---------UIWebViewDelegate delegate -------
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.webView == webView) {
        
        self.loadImage.hidden = YES;
    }
    
    [self handleJupushInfoWithTerminate];//处理后台通知信息
    [self mapViewMethodRealizeWithWebView:webView];
    [self getRegistIDMethodRealizeWithWebView:webView];
    [self getCurrentLocMethodRealizeWithWebView:webView];
    [self weiChatPayMethodRealizeWithWebView:webView];
    
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error===%@",error);
    if([error code] == NSURLErrorCancelled)
    {
        
        return;
    }
    
    [[iToast makeText:@"网络不稳定！"] show];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString * url = [NSString stringWithFormat:@"%@",[request URL]];
    NSLog(@"home's url === %@",url);
    if (navigationType == UIWebViewNavigationTypeOther||navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        if ([url isEqualToString:@"tel:4008622611"]) {
            return YES;
        }
        //首页门店 处理
        if ([[[url componentsSeparatedByString:@"#"] lastObject] isEqualToString: @"pageOfflineStore"]) {
            [[FMTabbar sharedManager] chooseStorePage];
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
//            NSLog(@"-----%@",self.tabBarController.viewControllers);
            
            return NO;
        }
        
        BOOL res = [[FMTabbarAppear sharedManager]checkTabbarWithUrl:url];
        res ? [self hideTabbar]:[self showTabbar];
    }
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (buttonIndex == 0) {
    //
    //        [self.tabView choosePageClickWithInter:self.tabBtnIndex];
    //
    //    }else{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008-622-611"]];
    //    }
}



@end

