//
//  FMBasicViewController.m
//  FMClient3.0
//
//  Created by YT on 2017/3/28.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "FMBasicViewController.h"
#import "FMMapView.h"
#import "FMLocationManager.h"
#import "EMManualLocViewController.h"

#import "WXApi.h"
#import "WXUtil.h"
#import "payRequsestHandler.h"

#import "UMMobClick/MobClick.h"
#import "OpenUDID.h"


@interface FMBasicViewController ()<WXApiDelegate,FMMapDelegate,ManualLocDelegate>
@property (nonatomic,strong)FMMapView     * mapSubView;
@property (nonatomic,assign)CLLocationCoordinate2D currentCoord;


@end

@implementation FMBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNoticiCenter];
    [self addMapSubViews];
    [self addSubStatueView];
    
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareSuessCallback) name:@"SHARESUCESS" object:nil];
}
-(void)addSubStatueView{
    UIView * stateTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    stateTopView.backgroundColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    [self.view addSubview:stateTopView];
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
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:nil error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark ------- 处理tabbar  ---------------
-(void)showTabbar
{
    CGRect fram = self.webView.frame;
    fram.size.height = SCREEN_HEIGHT - 69;
    self.webView.frame = fram;
    self.tabBarController.tabBar.hidden = NO;
    self.shareView.hidden = YES;
    
}
-(void)hideTabbar
{
    CGRect fram = self.webView.frame;
    fram.size.height = SCREEN_HEIGHT - 69;
    self.webView.frame = fram;
    self.tabBarController.tabBar.hidden = YES;
}
-(NSString *)getChangeUrlWithTarget:(NSString *)targetUrl
{
    NSString * temp = [[targetUrl componentsSeparatedByString:@".html"] firstObject];
    temp = [[temp componentsSeparatedByString:@"/"] lastObject];
    return temp;
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
#pragma mark ------------   分享功能实现 -------------------
-(void)shareMethodRealizeWithWebView:(UIWebView *)webView
{
    self.webView  = webView;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none'"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none'"];
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [self JSNativeShare];
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


#pragma mark ------------   支付功能实现 -------------------
-(void)weiChatPayMethodRealizeWithWebView:(UIWebView *)webView
{
    self.webView  = webView;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none'"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none'"];
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self sendWeiXinPayReq];
    
}
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
        
        NSLog(@"%@\n\n",debug);
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

/// ========支付回调函数==========
-(void)NativeSendWeiXinPayReturnWithCode:(NSString *)code
{
    NSString * jsValue = [NSString stringWithFormat:@"NativeSendWeiXinPayReturn('%@')",code];
    
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
}
/// WXPayDelegate 微信支付返回信息
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




#pragma mark ------------   统计功能实现 -------------------
-(void)mobclickAgentMethodRealizeWithWebView:(UIWebView *)webView
{
    self.webView  = webView;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none'"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none'"];
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self JSMobclickAgentOnEvent];
    [self JSMobclickAgentOnEventWithLabel];
}
-(void)JSMobclickAgentOnEvent
{
    __weak __typeof(self)wself = self;
//   ---------  友盟统计
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
//    ----------  mobClick statistics ----------
-(void)mobilkAnlysisWithEventID:(NSString *)eventID andEventLabel:(NSString *)eventLabel
{
    if ([MYUtils isEmpty:eventLabel]) {
        
        [MobClick event:eventID];
        
    }else{
        
        [MobClick event:eventID label:eventLabel];
    }
    
}

#pragma mark ------------   GET REGIST 功能实现 -------------------

-(void)getRegistIDMethodRealizeWithWebView:(UIWebView *)webView
{
    self.webView  = webView;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none'"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none'"];
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self JSgetRegistrationID];
}

-(void)JSgetRegistrationID
{
    __weak __typeof(self)wself = self;
///  ------------   //推送设备号
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
-(void)uploadRegistrationID:(NSString *)registrationID
{
    NSString * udid = [OpenUDID value];
    
    NSString * jsValue = [NSString stringWithFormat:@"setRegistrationID('%@','%@')",registrationID,udid];
    
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
    
    
}
#pragma mark ------------   定位功能实现 -------------------
-(void)addMapSubViews
{
    self.mapSubView = [[[NSBundle mainBundle]loadNibNamed:@"FMMapView" owner:self options:nil] firstObject];
    self.mapSubView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.mapSubView.delegate = self;
}
-(void)mapViewMethodRealizeWithWebView:(UIWebView *)webView
{
    self.webView  = webView;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none'"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none'"];
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self JSNativeMapShow];
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
//  ------------- config mapView ---------------
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
-(void)mapViewChangeCarClick
{
    //    NSLog(@"更换车辆");
    NSString * jsValue = [NSString stringWithFormat:@"showMyCar()"];
    
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsValue waitUntilDone:NO];
    [self mapViewBackBtnClik];
    
}
-(void)mapViewBackBtnClik
{
    [self.mapSubView removeFromSuperview];
    //    self.mapSubView = nil;
    
}
-(void)mapViewSearchAddress
{
    //    NSLog(@"搜索周边");
    EMManualLocViewController * manu = [[EMManualLocViewController alloc]initWithNibName:@"EMManualLocViewController" bundle:nil];
    manu.delegate = self;
    [self presentViewController:manu animated:YES completion:nil];
}


-(void)mapViewChangeCurrentCoord:(CLLocationCoordinate2D)coord city:(NSString *)city andAddress:(NSString *)address
{
    [self updateChangeLocationWithCoord:coord city:city andAddress:address];
    
}

#pragma mark ManualLocDelegate  //获取当前所选的位置信息
- (void)manualLocViewController:(EMManualLocViewController*)ctrl didSelectedPoi:(BMKPoiInfo*)poi
{
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
    
    
}


//  ------ 移动地图 获取数据 -----------
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
#pragma mark ------------   获取当前位置实现 -------------------

-(void)getCurrentLocMethodRealizeWithWebView:(UIWebView *)webView
{
    self.webView  = webView;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none'"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none'"];
    
    _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
     [self JSCurrentPods];
}
// =============   调用后台的JS Function ==================================
-(void)JSCurrentPods
{
    __weak __typeof(self)wself = self;
//  ----------- 网页获取当前定位
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
//  ------  js 获取当前位置 -------
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

-(void)turnShareCtrlAnimation
{
    CATransition *animation =[CATransition animation];
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromTop];
    [self.tabBarController.view.layer addAnimation:animation forKey:@"switchView"];
}
@end
