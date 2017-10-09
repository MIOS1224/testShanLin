//
//  MYBaseConfigUtils.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MYBaseConfigUtils.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface MYBaseConfigUtils()
{
    NSDictionary *config;
}

@end

@implementation MYBaseConfigUtils

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        //读取配置文件
        [self refreshCfg];
    }
    
    return self;
}

- (void)refreshCfg
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    
    config = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}
#pragma mark ------- 系统参数 ------------
- (NSString*)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    return  [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
- (NSInteger)appVersionCode
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *bundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return [bundleVersion integerValue];
}

- (NSString*)appBundleIdentifier
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleIdentifier"];
}

#pragma mark ------- URL  ------------
- (NSString*)host
{
    return [config objectForKey:@"host"];
}

- (NSString*)path
{
    return [config objectForKey:@"path"];
}

- (NSString*)appKey
{
    return [config objectForKey:@"appKey"];
}

- (NSString*)secretKey
{
    return [config objectForKey:@"secretKey"];
}
- (NSString*)baiduMapKey
{
    return [config objectForKey:@"baiduMapKey"];
}

- (NSString*)umengKey
{
    return [config objectForKey:@"umengKey"];
}


#pragma mark ------ 微信账号 ----------
- (NSString*)wxAppId
{
    return [config objectForKey:@"wxAppId"];
}

- (NSString*)wxAppSecret
{
    return [config objectForKey:@"wxAppSecret"];
}
- (NSString*)wxPartinerid
{
    return [config objectForKey:@"wxPartinerid"];
}

- (NSString*)wxMchid
{
    return [config objectForKey:@"wxMchid"];
}

- (NSString*)alipayScheme
{
    return [config objectForKey:@"alipayScheme"];
}

#pragma mark -------- 分享参数 -------
- (NSString*)sinaAppkey
{
    return [config objectForKey:@"sinaAppkey"];
    
}
- (NSString*)sinaAppSecret
{
    return [config objectForKey:@"sinaAppSecret"];
    
}

- (NSString*)wxShareURL
{
    return [config objectForKey:@"wxShareURL"];
}

- (NSString*)qqAppId
{
    return [config objectForKey:@"qqAppId"];
}

- (NSString*)qqAppSecret
{
    return [config objectForKey:@"qqAppSecret"];
}

#pragma mark -------- 信鸽参数 -------
- (NSString*)gxAppId
{
    
    return [config objectForKey:@"xgAppId"];
}

- (NSString*)gxAppKey
{
    
    return [config objectForKey:@"xgAppKey"];
}

- (NSString*)gxAppSecret
{
    
    return [config objectForKey:@"xgAppSecret"];
}

#pragma mark -------- 预留分享内容 -------
- (NSString*)shareTitle
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *share = [userDefaults objectForKey:@"share"];
    
    if (share) {
        return [share objectForKey:@"title"];
    }
    return nil;
}

- (NSString*)shareContent
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *share = [userDefaults objectForKey:@"share"];
    
    if (share) {
        return [share objectForKey:@"content"];
    }
    return nil;
}

- (NSString*)shareImage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *share = [userDefaults objectForKey:@"share"];
    
    if (share) {
        return [share objectForKey:@"image"];
    }
    
    return nil;
}


//- (NSString*)deviceInfo
//{
//    NSString * phone = [[NSUserDefaults standardUserDefaults]valueForKey:UD_LOGIN_PHONE];
//    NSString * udid  = [OpenUDID value];
//    NSString * mobileVersion = [[UIDevice currentDevice] model];
//    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
//    
//    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
//    CTCarrier *carrier = [info subscriberCellularProvider];
//    NSString  *operatorName = [NSString stringWithFormat:@"%@",[carrier carrierName]];//运营商
//    NSString  *networkType  = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];//网络情况
//    
//    
//    NSMutableDictionary *device = [[NSMutableDictionary alloc]init];
//    
//    [device setValue:[NSNumber numberWithFloat:[phone floatValue]] forKey:@"userId"];
//    [device setValue:@"member"      forKey:@"userType"];
//    [device setValue:udid           forKey:@"deviceNo"];
//    [device setObject:mobileVersion forKey:@"mobileVersion"];
//    [device setObject:systemVersion forKey:@"systemVersion"];
//    [device setObject:@"true"       forKey:@"wifi"];
//    
//    [device setObject:@"true"      forKey:@"gps"];
//    [device setObject:@"false"     forKey:@"root"];
//    [device setObject:operatorName forKey:@"operatorName"];
//    [device setObject:networkType  forKey:@"networkType"];
//    [device setObject:@"null"      forKey:@"ip"];
//    
//    NSData * data = [NSJSONSerialization dataWithJSONObject:device options:0 error:nil];
//    NSString * deviceInfo = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    
//    return deviceInfo;
//    
//}
@end
