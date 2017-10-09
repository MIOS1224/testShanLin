//
//  FMBasicViewController.h
//  FMClient3.0
//
//  Created by YT on 2017/3/28.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "FMShareController.h"
#import "FMTabbarAppear.h"
#import "FMShareView.h"
#import "FMTabbar.h"


@interface FMBasicViewController : UIViewController

@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)UIWebView * loadImage;
@property(nonatomic,strong)NSDictionary * noticeDic;

@property(nonatomic,strong)FMShareView * shareView;
@property(nonatomic,strong)JSContext   * jsContext;
@property(nonatomic,strong)NSString    * callBackStr;
@property(nonatomic,strong)NSString    * currentUrl;

@property(nonatomic,strong)FMShareController * shareCtrl;

-(void)showTabbar;
-(void)hideTabbar;

-(NSString *)getChangeUrlWithTarget:(NSString *)targetUrl;
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

-(void)shareMethodRealizeWithWebView:(UIWebView *)webView;
-(void)weiChatPayMethodRealizeWithWebView:(UIWebView *)webView;
-(void)mobclickAgentMethodRealizeWithWebView:(UIWebView *)webView;
-(void)getRegistIDMethodRealizeWithWebView:(UIWebView *)webView;
-(void)getCurrentLocMethodRealizeWithWebView:(UIWebView *)webView;
-(void)mapViewMethodRealizeWithWebView:(UIWebView *)webView;


-(void)handleJupushInfoWithTerminate;
-(void)turnShareCtrlAnimation;


@end
