//
//  FMShareController.h
//  FMClient3.0
//
//  Created by YT on 2017/3/29.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "FMShareView.h"

@interface FMShareController : UIViewController

@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)UIWebView * loadImage;
@property(nonatomic,strong)NSString * urlStr;
@property(nonatomic,strong)NSString * backStr;

@property(nonatomic,strong)FMShareView * shareView;
@property(nonatomic,strong)JSContext   * jsContext;
@property(nonatomic,strong)NSString    * callBackStr;


@property(nonatomic,assign)NSUInteger  backIndex;

@end
