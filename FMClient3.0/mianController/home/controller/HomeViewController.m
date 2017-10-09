//
//  HomeViewController.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "HomeViewController.h"
#import "MYBaseNavController.h"
#import "FMTabbarView.h"
#import <CoreLocation/CoreLocation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "OpenUDID.h"
#import <BaiduMapAPI/BMKAnnotation.h>
#import <BaiduMapAPI/BMKShape.h>
#import "EMManualLocViewController.h"

#import "FMMapView.h"
#import "FMMapViewController.h"
#import "MYBaseNavController.h"
#import "FMWeatherController.h"
#import "HomeStateView.h"
#import "iToast.h"

#import "FMLocationManager.h"
#import "HomePullView.h"
#import "UMMobClick/MobClick.h"

#import "NewjourneyViewController.h"
#import "HTTPManager.h"
//#import "ShopViewController.h"


#import "WXApi.h"
#import "WXUtil.h"
#import "payRequsestHandler.h"

#import "FMProgressHUD.h"
#import "FMDBHelper.h"
#import "DataBaseHelp.h"

#import "FMShareView.h"

#import <OHHTTPStubs.h>
#import "OHPathHelpers.h"


#define PASSVALUEKEY @"come^on&www.fmars.cn"
#define BASICPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]



@interface HomeViewController ()<FMTabbarViewDelegate,UIScrollViewDelegate,HomePullViewDelegate,UIWebViewDelegate,HomeStateViewDelegate,FMMapDelegate,ManualLocDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,OrderViewDelegate,WXApiDelegate>

@property (nonatomic,strong)FMMapView     * mapSubView;
@property (nonatomic,strong)FMTabbarView  * tabView;
@property (nonatomic,strong)HomePullView  * leftCityView;
@property (nonatomic,strong)HomeStateView * statueView;

@property (nonatomic,strong)NewjourneyViewController * order;


@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)NSString  * leftCityTitle;
@property (nonatomic,strong)JSContext * jsContext;

@property (nonatomic,strong)NSString  * currentCity;
@property (nonatomic,strong)NSString  * baseUrl;
@property (nonatomic,strong)NSString  * currentUrl;

@property (nonatomic,strong)UIWebView * loadImage;
@property (nonatomic,strong)NSArray * bottomArr;
@property (nonatomic,strong)NSArray * headArr;

@property (nonatomic,assign)NSInteger tabBtnIndex;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic,assign)CLLocationCoordinate2D currentCoord;

@property (nonatomic,strong)FMShareView * shareView;
@property (nonatomic,strong)NSString   * callBackStr;


@property (nonatomic,assign)BOOL isPull;

@end

@implementation HomeViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
//      [self FirstLoadMethod];
        
//        [self uploadWebView];
//        [self addShareView];
        
        [self dispatchSignal];
        
    }
    return self;
}
-(void)dispatchSignal{
    //crate的value表示，最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务3
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"飞马星车管家";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.currentCity = @"上海";
    self.isPull = YES;
    
//    [self FirstLoadMethod];
    
//    if (IOS9) {
//        
//        [NSURLProtocol registerClass:[FMHttpURLProtocol class]];//启动监测图片加载路径
//    }
    

//    [self uploadWebView];
//    [self addShareView];
//    [[FMDBHelper sharedInstance]addValue:[NSString stringWithFormat:@"%@%d",@"value",1] forKeyPath:[NSString stringWithFormat:@"%@%d",@"key",1]];
 
    NSString * str = [self intToBinary:161];
    NSLog(@"%@",str);
    
}

-(void)uploadWebView
{

    [[FMProgressHUD sharedManager] dismiss];
    [self configSubWebView];
    
//    [self setupRefresh];
    
    [self addSubStatueView];
    
    [self addSubTabView];
    
    [self addNoticiCenter];
    
    //    [self addSubShareView];
    
    
    self.tabBtnIndex = 0;
    
    self.mapSubView = [[[NSBundle mainBundle]loadNibNamed:@"FMMapView" owner:self options:nil] firstObject];
    self.mapSubView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.mapSubView.delegate = self;
    
    NSArray * arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"NativeUrlConfig"];
    if (arr.count) {
        [self refineNativeURLConfigWith:arr];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(configNativeUrl:) name:@"NativeUrlConfig" object:nil];

}
-(void)configNativeUrl:(NSNotification *)userInfo
{
    NSDictionary * dict = userInfo.userInfo;
    
    NSArray * arr = [dict objectForKey:@"NativeUrlConfig"];
    [self refineNativeURLConfigWith:arr];
    
}
-(void)refineNativeURLConfigWith:(NSArray *)arr
{
    //    NSLog(@"===%@",dict);
    if ([[arr lastObject] isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        
        NSDictionary * arrDict = [arr lastObject];
        
        NSArray * allKeys = [arrDict allKeys];
        
        if ([allKeys containsObject:@"Bottom"]) {
            
            self.bottomArr = [arrDict objectForKey:@"Bottom"];
            self.headArr   = [arrDict objectForKey:@"HeadAndBottom"];
        }
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //    self.webView = nil;
    //    [self.webView stopLoading];
    
}

#pragma  mark ------ add noticicenter ------
-(void)addNoticiCenter
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleJupushInfo:)
                                                name:@"JUPUSHGETUSERINFO"
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(weixinDelegateMethod:)
                                                name:@"kweixinSuccessNoticationCenter"
                                              object:nil];
    
}

#pragma  mark ------ pull statue view -------
-(void)addSubStatueView{
    UIView * stateTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    stateTopView.backgroundColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    [self.view addSubview:stateTopView];
    //
    //    self.statueView = [[HomeStateView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 74)];
    //    self.statueView.backgroundColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    //    self.statueView.delegate = self;
    //
    //    [self.view addSubview:self.statueView];
}
#pragma mark  ------ weaterBtnClick  --------
-(void)HomeStateView:(HomeStateView *)stateView stateClick:(UILabel *)stateLabel
{
    [self changeCityItem];
}
-(void)HomeStateView:(HomeStateView *)stateView
{
    FMWeatherController * weather = [[FMWeatherController alloc]initWithNibName:@"FMWeatherController" bundle:nil];
    MYBaseNavController * nav     = [[MYBaseNavController alloc]initWithRootViewController:weather];
    weather.dataArr = stateView.weatherArr;
    
    [self presentViewController:nav animated:YES completion:nil];
    
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
    
    }
    
    
    if (!self.loadImage) {
        
        NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"loading10 3" ofType:@"gif"]];
        self.loadImage = [[UIWebView alloc] initWithFrame:CGRectMake(0,(SCREEN_HEIGHT - 94 - 128)/2,SCREEN_WIDTH,SCREEN_HEIGHT - 94)];
        [self.loadImage loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [self.view addSubview:self.loadImage];
        self.loadImage.userInteractionEnabled = NO;
    }
    
    self.loadImage.hidden = NO;
    
     NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:LOADURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    self.webView.scrollView.delegate = self;
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
}

#pragma mark ----- left city click -------
- (void)changeCityItem
{
    self.isPull = !self.isPull;
    self.leftCityView.hidden = self.isPull;
}

-(void)hideTabbar
{
    CGRect fram = self.webView.frame;
    fram.origin.y = 20;
    fram.size.height    = SCREEN_HEIGHT - 20;
    self.webView.frame  = fram;
    self.tabView.hidden = YES;
}
-(void)showTabbar
{
    CGRect fram = self.webView.frame;
    fram.origin.y = 20;
    fram.size.height    = SCREEN_HEIGHT - 69;
    self.webView.frame  = fram;
    self.tabView.hidden = NO;
}
#pragma mark ------- add tabview   -------------
- (void)addSubTabView
{
    self.tabView = [[FMTabbarView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
    [_tabView addTabBarButtonWithItem];
    
    _tabView.delegate = self;
    [self.view addSubview:_tabView];
}
#pragma mark ---------- tabview delegate ---------
-(void)FMTabbarView:(FMTabbarView *)tabView withButton:(UIButton *)selectBtn
{
    
    self.isPull = YES;
    self.leftCityView.hidden = self.isPull;
    
    NSInteger tag = selectBtn.tag;
    //    if (tag == 2) {
    //        self.order = [[NewjourneyViewController alloc]initWithNibName:@"NewjourneyViewController" bundle:nil];
    //        self.order.delegate = self;
    //        MYBaseNavController * nav = [[MYBaseNavController alloc]initWithRootViewController:self.order];
    //        [self presentViewController:nav animated:YES completion:nil];
    //        return;
    //    }  http://app.dev.com/m3/store.html?native=1
    
    NSArray * arr  = @[@"index",@"store",@"order",@"me"];
    NSString * url = [NSString stringWithFormat:@"%@/%@%@",NEWLOADURL,arr[tag],@".html?native=1"];
    
    self.currentUrl = url;
    NSURLRequest * reque = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    
    self.tabBtnIndex = tag;
    [self.webView loadRequest:reque];
    
}
-(void)OrderViewCtrl:(NewjourneyViewController *)orderView andIndexTag:(NSInteger)indexTag
{
    self.isPull = YES;
    self.leftCityView.hidden = self.isPull;
    
    NSInteger tag = indexTag;
    
    NSArray * arr  = @[@"",@"#pageOfflineStore",@"#orders",@"#pageRecharge",@"#me"];
    NSString * url = [NSString stringWithFormat:@"%@%@",LOADURL,arr[tag]];
    
    self.currentUrl = url;
    NSURLRequest * reque = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    
    self.tabBtnIndex = tag;
    [self.webView loadRequest:reque];
    
}
-(void)turnOrderContrller
{
    NewjourneyViewController * order = [[NewjourneyViewController alloc]init];
    MYBaseNavController * nav = [[MYBaseNavController alloc]initWithRootViewController:order];
    
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark ---------UIWebViewDelegate delegate -------
-(void)webViewDidStartLoad:(UIWebView *)webView
{
  
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loadImage.hidden = YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none'"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none'"];
    
    
    [self handleJupushInfoWithTerminate];//处理后台通知信息
    
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [self JSCurrentPods];
    [self JSgetRegistrationID];
    [self JSMobclickAgentOnEvent];
    [self JSMobclickAgentOnEventWithLabel];
    [self JSNativeMapShow];
    [self JScheckBaseUrl];
    [self JSNativeShare];
    
    
    [self sendWeiXinPayReq];
    
    
    //切换城市，防止网页未加载完成时执行操作
//    NSString * jsValue = [NSString stringWithFormat:@"setSelectCity('%@')",self.currentCity];
//    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
    
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
    
    self.currentUrl = [NSString stringWithFormat:@"%@",[request URL]];
    
    if (navigationType == UIWebViewNavigationTypeOther||navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        [self turnPageWithUrl:self.currentUrl];
    }
    
    if (self.shareView) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.shareView removeFromSuperview];
        }];
    }
    self.isPull = YES;
    self.leftCityView.hidden = self.isPull;
    
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _jsContext[@"NativeMapShow(retData)"] =^(id obj){
        //原生
        [JSContext currentContext];
    };
    
    return YES;
}
-(void)turnPageWithUrl:(NSString *)urlStr
{
    NSLog(@"urlStr==%@",urlStr);
    
    //特殊处理
//    if ([self findStr:urlStr andTarget:@"order.html#hongbao"]||[self findStr:urlStr andTarget:@"#page"]||[self findStr:urlStr andTarget:@"#mybalance"]||[self findStr:urlStr andTarget:@"#myFmarsCoin"]||[self findStr:urlStr andTarget:@"#vouchers"]||[self findStr:urlStr andTarget:@"native=1#order"]||[self findStr:urlStr andTarget:@"#weather"]||[self findStr:urlStr andTarget:@"#bindCard"]||[self findStr:urlStr andTarget:@"#rate"]||[self findStr:urlStr andTarget:@"order.html?id"]) {
//        [self hideTabbar];
//        return;
//    }
    
    for (NSString * str  in self.headArr) {
        if ([self findStr:urlStr andTarget:str]) {
            [self hideTabbar];
            return;
        }
    }
    if ([self findStr:urlStr andTarget:@"#home"]||[self findStr:urlStr andTarget:self.bottomArr[0]] ) {
        [self.tabView chooseHomeAction];
        [self showTabbar];
        self.tabBtnIndex = 0;
        
    }else if ([self findStr:urlStr andTarget:self.bottomArr[1]])
    {
        [self.tabView chooseStoresAction];
        [self showTabbar];
        self.tabBtnIndex = 1;
        
    }else if ([self findStr:urlStr andTarget:@"#orders"]||[self findStr:urlStr andTarget:self.bottomArr[2]])
    {
        [self.tabView chooseOrdersAction];
        [self showTabbar];
        self.tabBtnIndex = 2;
        
    }else if ([self findStr:urlStr andTarget:@"#me"]||[self findStr:urlStr andTarget:self.bottomArr[3]])
    {
        [self.tabView chooseMineAction];
        [self showTabbar];
        self.tabBtnIndex = 3;
        
    }else{
        
        [self hideTabbar];
    }
    
    
    
}
-(BOOL)findStr:(NSString *)urlStr andTarget:(NSString *)target
{
    if ([urlStr rangeOfString:target].location != NSNotFound) {
        return YES;
    }else
    {
        return NO;
    }
}

-(void)JScheckBaseUrl
{
    __weak __typeof(self)wself = self;
    _jsContext[@"checkBaseUrl"] =^(id obj1){
        
        dispatch_queue_t quent = dispatch_queue_create(nil, DISPATCH_CURRENT_QUEUE_LABEL);
        
        dispatch_async(quent, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //                NSLog(@"checkBaseUrl::%@",obj1);
                NSString * urlValue = [NSString stringWithFormat:@"%@",obj1];
                
                if (![urlValue isEqualToString:wself.currentUrl]) {
                    
                    [wself turnPageWithUrl:urlValue];
                    //                    [wself checkBaseUrlWithValue:urlValue];
                    
                    wself.currentUrl = urlValue;
                }
            });
        });
        [JSContext currentContext];
    };
}


#pragma mark =============   调用后台的JS Function ==================================
-(void)JSCurrentPods
{
    __weak __typeof(self)wself = self;
#pragma mark  ----------- 网页获取当前定位
    _jsContext[@"CurrentPos"] =^(id obj){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![FMLocationManager sharedManager].currentLocation) {
                    [[FMLocationManager sharedManager] startLocationService];
                    return;
                }
                CLLocationCoordinate2D coord = [FMLocationManager sharedManager].currentLocation.location.coordinate;
                NSString * city = [FMLocationManager sharedManager].currentCity;
                NSString * address = [FMLocationManager sharedManager].currentAddress;
                
                [wself updateCurrentPosInfoWithCoord:coord city:city andAddress:address];
                
            });
        });
        
        [JSContext currentContext];
        
    };
}

-(void)JSgetRegistrationID
{
    __weak __typeof(self)wself = self;
#pragma mark  ------------   //推送设备号
    _jsContext[@"getRegistrationID"] =^(id obj){
        
        NSString * registrationID = [[NSUserDefaults standardUserDefaults]objectForKey:@"registrationID"];
        
        if ([registrationID length] > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [wself uploadRegistrationID:registrationID];
                    
                });
            });
        }
        
        [JSContext currentContext];
    };
}
//sendWeiXinPayReq
-(void)sendWeiXinPayReq
{
    __weak __typeof(self)wself = self;
    
    _jsContext[@"sendWeiXinPayReq"] =^(id obj){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSString * prepayid = [NSString stringWithFormat:@"%@",obj];
                
                [wself sendPay:prepayid];
                
            });
        });
        
        [JSContext currentContext];
    };
}

-(void)JSMobclickAgentOnEvent
{
    __weak __typeof(self)wself = self;
#pragma mark ---------  友盟统计
    _jsContext[@"MobclickAgentOnEvent"] =^(id obj){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSString * eventid = [NSString stringWithFormat:@"%@",obj];
                
                [wself mobilkAnlysisWithEventID:eventid andEventLabel:nil];
                
            });
        });
        
        [JSContext currentContext];
    };
}
-(void)JSMobclickAgentOnEventWithLabel
{
    __weak __typeof(self)wself = self;
    _jsContext[@"MobclickAgentOnEventWithLabel"] =^(id obj1, id obj2){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * eventid = [NSString stringWithFormat:@"%@",obj1];
                NSString * eventlabel = [NSString stringWithFormat:@"%@",obj2];
                
                [wself mobilkAnlysisWithEventID:eventid andEventLabel:eventlabel];
                
            });
        });
        
        [JSContext currentContext];
    };
}
-(void)JSNativeMapShow
{
    __weak __typeof(self)wself = self;
    _jsContext[@"NativeMapShow"] =^(id obj1){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary * dict = (NSDictionary *)obj1;
                if (dict) {
                    // [wself turnMapViewControllerWithDict:dict];
                    [wself addSubMapViewCtrlWithDataDict:dict];
                }
            });
        });
        [JSContext currentContext];
    };
}
-(void)JSNativeShare
{
        __weak __typeof(self)wself = self;
    _jsContext[@"nativeShare"] =^(id obj1){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * str = (NSString *)obj1;
               NSDictionary *dict = [wself dictionaryWithJsonString:str];
                
                NSString * shareTitle = [dict objectForKey:@"title"];
                NSString * imagePath  = [dict objectForKey:@"imagelink"];
                NSString * descinfo   = [dict objectForKey:@"desc"];
                NSString * shareUrl   = [dict objectForKey:@"link"];
                wself.callBackStr     = [dict objectForKey:@"callback"];
                
                
                if ([MYUtils isNotEmpty:shareTitle] && [MYUtils isNotEmpty:shareUrl]) {
                    
                    [wself addShareViewWithtitle:shareTitle imagePath:imagePath anddescInfo:descinfo andShareUrl:shareUrl];
                }else
                {
                    [[iToast makeText:@"分享失败，请重试"] show];
                }
                
            });
        });
        [JSContext currentContext];
    };
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         options:NSJSONReadingMutableContainers
                         error:&err];
    
    if(err) {
        return nil;
    }
    return dic;
    
}
#pragma mark -------------   上传JUPUSH registrationID -----------------------
-(void)uploadRegistrationID:(NSString *)registrationID
{
    NSString * udid = [OpenUDID value];
    
    NSString * jsValue = [NSString stringWithFormat:@"setRegistrationID('%@','%@')",registrationID,udid];
    
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
    
    
}

#pragma  mark ---------  处理通知信息  ------

-(void)handleJupushInfo:(NSNotification *)dictInfo
{
    self.noticeDic = dictInfo.userInfo;
    NSString * strVlaue = [self dictionaryToJson:dictInfo.userInfo];
    NSArray * arr = [dictInfo.userInfo allKeys];
    
    if (arr.count > 2) {
        
        NSString * jsValue = [NSString stringWithFormat:@"Native2JsAction('NatGetBackCall','%@')",strVlaue];
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
        
    }
    
}
#pragma mark ------- 处理后台通知信息
-(void)handleJupushInfoWithTerminate
{
    if (self.noticeDic) {
        
        NSString * strVlaue = [self dictionaryToJson:self.noticeDic];
        NSArray * arr = [self.noticeDic allKeys];
        
        if (arr.count > 2) {
            
            NSString * jsValue = [NSString stringWithFormat:@"Native2JsAction('NatGetBackCall','%@')",strVlaue];
            
            
            [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
            
        }
    }
}
#pragma mark  ------  js 获取当前位置 -------
-(void)updateCurrentPosInfoWithCoord:(CLLocationCoordinate2D)coord city:(NSString *)city andAddress:(NSString *)address
{
    __block NSString * cityValue = city;
    __block NSString * addressValue = address;
    
    dispatch_queue_t  queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        NSString * lng = [NSString stringWithFormat:@"%lf",coord.longitude];
        NSString * lat = [NSString stringWithFormat:@"%lf",coord.latitude];
        if ([MYUtils isEmpty:address] || [MYUtils isEmpty:city]) {
            [[iToast makeText:@"位置获取失败，请重试..."] show];
            return ;
        }
        NSDictionary * dict = @{@"lng":lng,@"lat":lat,@"city":cityValue,@"address":addressValue};
        NSString * strValue = [self dictionaryToJson:dict];
        
        NSString * jsValue = [NSString stringWithFormat:@"Native2JsAction('setMyLocation','%@')",strValue];
        
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
    });
    
    
}
#pragma mark ------ 移动地图 获取数据 -----------
-(void)updateChangeLocationWithCoord:(CLLocationCoordinate2D)coord city:(NSString *)city andAddress:(NSString *)address
{
    
    __block NSString * cityValue = city;
    __block NSString * addressValue = address;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString * lng = [NSString stringWithFormat:@"%lf",coord.longitude];
            NSString * lat = [NSString stringWithFormat:@"%lf",coord.latitude];
            
            NSDictionary * dict = @{@"lng":lng,@"lat":lat,@"city":cityValue,@"address":addressValue};
            NSString * strValue = [self dictionaryToJson:dict];
            
            NSString * jsValue = [NSString stringWithFormat:@"Native2JsAction('OnNativeMapMove','%@')",strValue];
            [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
            
        });
    });
    
    __weak __typeof(self)wself = self;
    _jsContext[@"NativeMapShow"] =^(id obj1){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSDictionary * dict = (NSDictionary *)obj1;
                if (dict) {
                    
                    [wself addSubMapViewCtrlWithDataDict:dict];
                }
                
            });
        });
        [JSContext currentContext];
    };
    
}

#pragma mark ----------  mobClick statistics ----------
-(void)mobilkAnlysisWithEventID:(NSString *)eventID andEventLabel:(NSString *)eventLabel
{
    if ([MYUtils isEmpty:eventLabel]) {
        
        [MobClick event:eventID];
        
    }else{
        
        [MobClick event:eventID label:eventLabel];
    }
    
}
#pragma mark ---------- push mapcontroller
//-(void)turnMapViewControllerWithDict:(NSDictionary *)dict
//{
//
//    FMMapViewController * map = [[FMMapViewController alloc]initWithNibName:@"FMMapViewController" bundle:nil];
//    MYBaseNavController * nav = [[MYBaseNavController alloc]initWithRootViewController:map];
//
//    map.dictData = dict;
//    [self presentViewController:nav animated:YES completion:nil];
//
//}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:nil error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark  ------------- config mapView ---------------
-(void)addSubMapViewCtrlWithDataDict:(NSDictionary *)dataDict
{
    if (!self.mapSubView) {
        
        self.mapSubView = [[[NSBundle mainBundle]loadNibNamed:@"FMMapView" owner:self options:nil] firstObject];
        self.mapSubView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:self.mapSubView];
        self.mapSubView.delegate = self;
    }
    
    if (self.mapSubView.superview == nil) {
        [self.mapSubView setMapCenterCoor:[FMLocationManager sharedManager].currentLocation.location];
        
        NSString * addressStr = [NSString stringWithFormat:@"%@%@",[FMLocationManager sharedManager].currentCity,[FMLocationManager sharedManager].currentAddress];
        
        [self.mapSubView setDetailLabelInfo:addressStr];
    }
    
    [self.view addSubview:self.mapSubView];
    [self.mapSubView configDataDict:dataDict];
}

-(void)mapViewBackBtnClik
{
    [self.mapSubView removeFromSuperview];
    //    self.mapSubView = nil;
    
}
-(void)mapViewChangeCarClick
{
    //    NSLog(@"更换车辆");
    NSString * jsValue = [NSString stringWithFormat:@"showMyCar()"];
    
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
    [self mapViewBackBtnClik];
    
}
-(void)mapViewSearchAddress
{
    //    NSLog(@"搜索周边");
    EMManualLocViewController * manu = [[EMManualLocViewController alloc]initWithNibName:@"EMManualLocViewController" bundle:nil];
    manu.delegate = self;
    [self presentViewController:manu animated:YES completion:nil];
}
#pragma mark ManualLocDelegate  //获取当前所选的位置信息
- (void)manualLocViewController:(EMManualLocViewController*)ctrl didSelectedPoi:(BMKPoiInfo*)poi
{
    //    BMKPoiInfo * poiInfo = [result.poiList firstObject];
    
    
    
    NSString * detailAddress = [NSString stringWithFormat:@"%@%@",poi.address,poi.name];
    NSString * city = poi.city;
    CLLocationCoordinate2D coord = poi.pt;
    self.currentCoord = coord;
    
    if ([MYUtils isEmpty:detailAddress] ) {
        [iToast makeText:@"位置信息获取错误，请重试....."];
        return;
    }
    
    [self updateChangeLocationWithCoord:coord city:city andAddress:detailAddress];
}

-(void)mapViewChooseDetailTime{
    
}
-(void)mapViewChangeCurrentCoord:(CLLocationCoordinate2D)coord city:(NSString *)city andAddress:(NSString *)address
{
    [self updateChangeLocationWithCoord:coord city:city andAddress:address];
    
}
-(void)mapViewNextBtnClickWithCoord:(CLLocationCoordinate2D)coord andAddress:(NSString *)address timeValue:(NSString *)timeValue spanValue:(NSString *)spanValue
{
//    NSLog(@"下一步");
    if (self.currentCoord.latitude == 0) {
        self.currentCoord = [FMLocationManager sharedManager].currentLocation.location.coordinate;
    }
    NSString * lng = [NSString stringWithFormat:@"%lf",self.currentCoord.longitude];
    NSString * lat = [NSString stringWithFormat:@"%lf",self.currentCoord.latitude];
    
    if ([MYUtils isEmpty:lng] || [MYUtils isEmpty:lat]) {
        [[iToast makeText:@"位置获取失败..."] show];
        return;
    }
    
    NSDictionary * dict = @{@"lng":lng,@"lat":lat,@"address":address,@"NeedTm":@"TRUE",@"comeTm":timeValue,@"comeSpan":spanValue};
    NSString * strValue = [self dictionaryToJson:dict];
    
    NSString * jsValue = [NSString stringWithFormat:@"Native2JsAction('LoadCreateOrder','%@')",strValue];
    
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
    
    [self mapViewBackBtnClik];
    //    self.mapSubView.hidden = YES;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self.tabView choosePageClickWithInter:self.tabBtnIndex];
        
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008-622-611"]];
    }
}

#pragma mark  -----------  微信支付 ---------
- (void)sendPay:(NSString *)prepayId
{
    //    FMConfigUtils * cfg = [FMConfigUtils sharedInstance];
    
    
    //    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:@"wx8356edda5f724259" mch_id:@"1267029401"];
    //设置密钥
    [req setKey:@"fmars7bc090611e6b5123e1d05defe78"];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req getSignParamsWith:prepayId];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
//        NSLog(@"%@\n\n",debug);
    }else{
//        NSLog(@"%@\n\n",[req getDebugifo]);
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req    = [[PayReq alloc] init];
        req.openID     = [dict objectForKey:@"appid"];
        req.partnerId  = [dict objectForKey:@"partnerid"];
        req.prepayId   = [dict objectForKey:@"prepayid"];
        req.nonceStr   = [dict objectForKey:@"noncestr"];
        req.timeStamp  = stamp.intValue;
        req.package    = [dict objectForKey:@"package"];
        req.sign       = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}
//NativeSendWeiXinPayReturn

#pragma mark ========支付回调函数==========
-(void)NativeSendWeiXinPayReturnWithCode:(NSString *)code
{
    NSString * jsValue = [NSString stringWithFormat:@"NativeSendWeiXinPayReturn('%@')",code];
    
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
}
#pragma WXPayDelegate 微信支付返回信息
-(void)weixinDelegateMethod:(NSNotification *)userInfo
{
    NSDictionary * dic = userInfo.userInfo;
    
    BaseResp* resp = [dic objectForKey:@"appdelegateWeinxin"];
    __block NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                [self NativeSendWeiXinPayReturnWithCode:@"1"];
                
                break;
                
            default:
                strMsg = @"微信支付失败!";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"微信支付失败!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
        }
    }
}


-(void)addShareViewWithtitle:(NSString *)title imagePath:(NSString *)imagePath anddescInfo:(NSString *)descInfo andShareUrl:(NSString *)shareUrl
{
    self.shareView = [[FMShareView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100)];
    
    self.shareView.imagePath = imagePath;
    self.shareView.title     = title;
    self.shareView.descInfo  = descInfo;
    self.shareView.shareUrl  = shareUrl;
    
//    shareView.imagePath = @"http://app.dev.com/m2/image/vc.png";
//    shareView.title     = @"我用飞马星，省心，省时，省钱！还为地球节约资源";
//    shareView.descInfo  = @"不伤神，不费事，飞马星轻松帮您搞定爱车问题~~~";
//    shareView.shareUrl  = @"http://app.dev.com/m2/hongbao.html?id=1291";
    [UIView animateWithDuration:0.5 animations:^{
        
        self.shareView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:self.shareView];
        
    }];
    
    
}
-(void)shareSuessCallback
{
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.shareView removeFromSuperview];
    }];
    NSString * jsValue = [NSString stringWithFormat:@"%@()",self.callBackStr];
    
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
//    NSLog(@“”)
    
}

#pragma mark -------  下拉刷新 ------------
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}
-(void)setupRefresh
{
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshStateChange) forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:control];
    
    [control beginRefreshing];
}
-(void)refreshStateChange
{
    [self.webView reload];
}

- (NSString * )intToBinary:(int)intValue{
    int byteBlock = 8,
    totalBits = (sizeof(int)) * byteBlock,
    binaryDigit = totalBits;
    char ndigit[totalBits + 1];
    while (binaryDigit-- > 0)
    {
        ndigit[binaryDigit] = (intValue & 1) ? '1' : '0';
        
        intValue >>= 1;
    }
    ndigit[totalBits] = 0;
    

    NSString * temp  = [NSString stringWithUTF8String:ndigit];
    NSRange range    = [temp rangeOfString:@"1"];
    NSString * value = [temp substringWithRange:NSMakeRange(range.location, temp.length - range.location)];
    
    NSMutableArray * arr =  [self getRangeStr:value findText:@"1"];
    NSMutableString * finalStr = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%ld",arr.count]];
    
    for (NSNumber * str in arr) {
        [finalStr appendString:[NSString stringWithFormat:@"%@",str]];
    }
    return finalStr;
    
}

- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText

{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText];
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location + 1]];
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++){
            if (0 == i) {
                
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
                
            }else{
                
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
                
            }
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
                
            }else
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location + 1]];
            
        }
    }
        return arrayRanges;
        
}
@end
