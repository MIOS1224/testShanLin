//
//  AppDelegate.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/1.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "AppDelegate.h"
#import "FMAddInfoController.h"
#import "HomeViewController.h"
#import "MYUtils.h"
#import "MYBaseNavController.h"
#import "FMLocationManager.h"
#import "FMMapViewController.h"


#import <UMSocialCore/UMSocialCore.h>
#import "HTTPManager.h"

#import "WXApi.h"
#import "payRequsestHandler.h"
#import "FMHttpURLProtocol.h"
#import "FMURLSessionProtocol.h"


#import "UMMobClick/MobClick.h"
#import <UMSocialCore/UMSocialCore.h>


#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define BAIDUKEY @"StgPNaZmzLTQS66PXn7oBBcQ"
#define JPUSHKEY @"b8fc0c2639e9e7091df100f1"
#define JPUSHMasterKey @"22f4d4a421e9841f6043274b"
#define WECHATKEY @"wx8356edda5f724259"
#define WECHATSECRET @"2e877845accb41e6c46c700eddb4f4d8"

#define APP_URL    @"http://itunes.apple.com/lookup?id=1091957094"


@interface AppDelegate ()<WXApiDelegate>

@property (strong, nonatomic) BMKMapManager *mapManager;
@property (nonatomic,strong)NSString * trackStr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, queue, ^{
////        [NSThread sleepForTimeInterval:1];
//        NSLog(@"group1");
//    });
//    dispatch_group_async(group, queue, ^{
////        [NSThread sleepForTimeInterval:2];
//        NSLog(@"group2");
//    });
//    dispatch_group_async(group, queue, ^{
////        [NSThread sleepForTimeInterval:3];
//        NSLog(@"group3");
//    });
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"updateUi");  
//    });  
////    dispatch_release(group);
//    
//    
//    
//    dispatch_queue_t queue1 = dispatch_queue_create("gcdtest.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue1, ^{
////        [NSThread sleepForTimeInterval:2];
//        NSLog(@"dispatch_async1");
//    });
//    dispatch_async(queue1, ^{
////        [NSThread sleepForTimeInterval:4];
//        NSLog(@"dispatch_async2");
//    });
//    dispatch_barrier_async(queue1, ^{
//        NSLog(@"dispatch_barrier_async");
////        [NSThread sleepForTimeInterval:4];
//        
//    });
//    dispatch_async(queue1, ^{
////        [NSThread sleepForTimeInterval:1];
//        NSLog(@"dispatch_async3");
//    });
    
    
    
    
    
    
     [NSURLProtocol registerClass:[FMURLSessionProtocol class]];//启动监测图片加载路径
    //删除cache
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    [self deleteMethod];
    [self configRootViewController];
    [self getUrlArrInfo];

    [self initAppMap];
    
//    //开始定位
    [[FMLocationManager sharedManager]startLocationService];

    //设置Window主界面
//    [self configRootViewController];
    
    [self jspushConfigWithOptions:launchOptions];
    
    
    [self configUMMbClick];
    
    //[4]:向微信注册
    [self registerApp:WECHATKEY];
    
   
    
    return YES;
    
    
}
-(void)deleteMethod
{
    NSArray * xmlArr = [[NSUserDefaults standardUserDefaults]objectForKey:UD_LISTXML_ARRAY];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    for(NSString *str in xmlArr)
    {
        [dic setValue:str forKey:str];
    }
    NSArray * temp = [dic allKeys];
    [[NSUserDefaults standardUserDefaults]setObject:temp forKey:UD_LISTXML_ARRAY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

-(void)getNewVerision
{
    [[HTTPManager sharedInstance]getWithAPI:APP_URL dictionary:nil success:^(id responseObject) {
        NSArray *infoArray = [responseObject objectForKey:@"results"];
        if (infoArray.count >= 1) {
            
            NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
            
            //appstore 版本
            NSString* appStoreVersion = [releaseInfo objectForKey:@"version"];
            
            //当前版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            if ([currentVersion compare:appStoreVersion]==NSOrderedAscending)
            {
                
               self.trackStr=releaseInfo[@"trackViewUrl"];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"有新版本了,赶快更新看看吧！" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即升级", nil];
                [alertView show];
                
            }
            
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSURL *trackURL=[NSURL URLWithString:self.trackStr];
        [[UIApplication sharedApplication]openURL:trackURL];
        
        
    }
}
#pragma mark -----  显示主界面  --------
-(void)configRootViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    if([MYUtils isEmpty:isShow] || ![verision isEqualToString:currentVersion])
//    {
//        
////        [self clearFile];
//        
//        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"BundleShortVersion"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        FMAddInfoController * addCtrl = [[FMAddInfoController alloc]init];
//        self.window.rootViewController = addCtrl;
//        
//    }else{
//        
//        HomeViewController * home = [[HomeViewController alloc]init];
//        //设置windows根视
//        self.window.rootViewController = home;
//    }

    FMAddInfoController * addCtrl = [[FMAddInfoController alloc]init];
    self.window.rootViewController = addCtrl;
    
    self.window.backgroundColor    = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}
#pragma mark -------  map init -------
- (void)initAppMap
{
    
    self.mapManager = [[BMKMapManager alloc] init];
    
    BOOL ret = [self.mapManager start:BAIDUKEY  generalDelegate:nil];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
- (void)configUMMbClick
{
    UMConfigInstance.appKey = @"578f4db6e0f55a2e67001af9";
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
   
    
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"578f4db6e0f55a2e67001af9"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WECHATKEY appSecret:WECHATSECRET redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1104773453"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3636251062"  appSecret:@"445287eff3919c808192c03a7361baf1" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
   [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // 监听设备激活状态
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceDidBecomeActive object:nil];
    
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
     [application setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
     [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"WillTerminate" forKey:@"applicationWillTerminate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)getUrlArrInfo
{
    [[HTTPManager sharedInstance]getWithAPI:BASICURL dictionary:nil success:^(id responseObject) {
        
        [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"NativeUrlConfig"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NativeUrlConfig" object:nil userInfo:@{@"NativeUrlConfig":responseObject}];
        
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
    
}
#pragma mark ===== delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        NSLog(@"registrationID=====%@",registrationID);
        
        
        [[NSUserDefaults standardUserDefaults]setObject:registrationID forKey:@"registrationID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }];
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    
    if (IOS7) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        
    }else
    {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)jspushConfigWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10以上
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //iOS8以上可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }else {
        //iOS8以下categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    BOOL isProduction = YES;// NO为开发环境，YES为生产环境
    //广告标识符
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKEY
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {

        [[NSUserDefaults standardUserDefaults]setObject:registrationID forKey:@"registrationID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }];
    
}
//获取到通知信息
-(NSString *)logDic:(NSDictionary *)dic {
    
    
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    
    
    return str;
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        
    }

    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"JUPUSHGETUSERINFO" object:nil userInfo:userInfo];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
    }
    completionHandler(
    
    );
}
#endif
//2. 清除缓存
- (void)clearFile
{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    NSArray * arr = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory , NSUserDomainMask , YES );
    
    NSString * cachePath = [arr firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    
    for ( NSString * p in files) {
        NSError * error = nil ;
        if ([p isEqualToString:@"Caches/http_www.fmars.cn_0.localstorage"]) {
            
            NSString * value = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocalStorage"];
            
            NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
            if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
                [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
            }
            
//            if (![value isEqualToString:@"isMoves"]) {
//                
//                
//                NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
//                if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
//                    [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
//                }
//                [[NSUserDefaults standardUserDefaults]setObject:@"isMoves" forKey:@"LocalStorage"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//            }
        }
    }
    
}
#pragma mark WXAPI
-(void)registerApp:(NSString *)appid
{
    
    BOOL result = [WXApi registerApp:appid withDescription:@"demo 2.0"];
    
    if (!result) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:@"微信SDK未启动"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[UMSocialManager defaultManager] handleOpenURL:url],[WXApi handleOpenURL:url delegate:self];
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return [[UMSocialManager defaultManager] handleOpenURL:url],[WXApi handleOpenURL:url delegate:self];;
}

#pragma mark //微信支付回调函数
-(void) onResp:(BaseResp*)resp
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kweixinSuccessNoticationCenter" object:self userInfo:@{@"appdelegateWeinxin":resp}];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kweixinChargeNoticationCenter" object:self userInfo:@{@"appdelegateChargeWeinxin":resp}];
    
}
@end
