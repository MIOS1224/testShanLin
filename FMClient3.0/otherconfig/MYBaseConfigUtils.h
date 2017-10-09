//
//  MYBaseConfigUtils.h
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYBaseConfigUtils : NSObject
+ (id)sharedInstance;
/**
 *  刷新本地配置
 */
- (void)refreshCfg;
/**
 *  更新在线配置
 */
//- (void)updateOnlineCfg;a
/**
 *  获取配置文件中的百度地图key
 *
 *  @return NSString
 */
- (NSString*)baiduMapKey;
/**
 *  获取配置文件中友盟key
 *
 *  @return NSString
 */
- (NSString*)umengKey;
/**
 *  应用版本号
 *
 *  @return NSString
 */
- (NSString*)appVersion;
/**
 *  微信AppId
 *
 *  @return NSString
 */
- (NSString*)wxAppId;
/**
 *  微信appSecret
 *
 *  @return NSString
 */
- (NSString*)wxAppSecret;
/**
 *  微信wxPartinerid
 *
 *  @return NSString
 */
- (NSString*)wxPartinerid;
/**
 *  微信wxMchid
 *
 *  @return NSString
 */
- (NSString*)wxMchid;
/**
 *  版本号
 *
 *  @return NSInteger
 */
- (NSInteger)appVersionCode;
/**
 *  CFBundleIdentifier
 *
 *  @return NSString
 */
- (NSString*)appBundleIdentifier;

/**
 *  服务器地址
 *
 *  @return NSString
 */
- (NSString*)host;
/**
 *  api路径
 *
 *  @return NSString
 */
- (NSString*)path;
/**
 *  应用Key
 *
 *  @return NSString
 */
- (NSString*)appKey;
/**
 *  安全Key
 *
 *  @return NSString
 */
- (NSString*)secretKey;
/**
 *  支付宝回调地址
 *
 *  @return NSString
 */
- (NSString*)alipayScheme;
/**
 *  分享标题
 *
 *  @return NSString
 */
- (NSString*)shareTitle;
/**
 *  分享文字内容
 *
 *  @return NSString
 */
- (NSString*)shareContent;
/**
 *  分享图片
 *
 *  @return NSString
 */
- (NSString*)shareImage;
/**
 *  微信分享配置url
 *
 *  @return
 */
- (NSString*)wxShareURL;
/**
 *  qq互联appid
 *
 *  @return NSString
 */
- (NSString*)qqAppId;
/**
 *  qq互联性AppSecret
 *
 *  @return NSString
 */
- (NSString*)qqAppSecret;

/**
 *  个推appId
 *
 *  @return NSString
 */
- (NSString*)gxAppId;
/**
 *  个推AppSecret
 *
 *  @return NSString
 */
- (NSString*)gxAppSecret;

/**
 *  个推AppKey
 *
 *  @return NSString
 */
- (NSString*)gxAppKey;
/**
 *  sinaAppkey
 *
 *  @return NSString
 */
- (NSString*)sinaAppkey;
/**
 *  sinaAppSecret
 *
 *  @return NSString
 */
- (NSString*)sinaAppSecret;


/**
 * 获取设备信息
 * @return NSString
 */
//- (NSString*)deviceInfo;


@end
