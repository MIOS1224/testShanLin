//
//  MYBaseController.h
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBaseConfigUtils.h"
/**
 *  当前位置名称
 */
static NSString *const UD_CUR_ADDR  =   @"ud_current_address";
/**
 *  当前纬度
 */
static NSString *const UD_CUR_LAT   =   @"ud_current_lat";
/**
 *  当前经度
 */
static NSString *const UD_CUR_LNG   =   @"ud_current_lng";
/**
 *  当前城市
 */
static NSString *const UD_CUR_CITY  =   @"ud_current_city";
/**
 *  定位时间
 */
static NSString *const UD_LOC_TIME  =   @"ud_loc_time";
/**
 *  未定位到信息
 */
static NSString *const UD_CUR_NULL  =   @"ud_current_null";
/**
 *  登陆的手机号码
 */
static NSString *const UD_LOGIN_PHONE = @"ud_login_token";
/**
 *  登陆成功通知
 */
static NSString *const UD_LOGIN_SUCCESS = @"LoginSuccessed";

/**
 *  每页显示数据条数
 */
static const NSInteger PAGE_LIMIT = 10;


/**
 * 远程通知
 **/
static  NSString *const kRemoteNoticeNotification = @"kRemoteNoticeNotification";/**
 * 设备变成激活状态
 **/
static  NSString *const kDeviceDidBecomeActive = @"kDeviceDidBecomeActive";
/**
 * 首页定位失败
 **/
static  NSString *const kLocationError = @"kLocationError";

/**
 * 首页定位成功
 **/
static  NSString *const kLocationSuccess = @"kLocationSuccess";

/**
 * 返回首页
 **/
static  NSString *const kConfigHomeMapView = @"kConfigHomeMapView";


@interface MYBaseController : UIViewController

/**
 *  保存数据到 UserDefaults
 *
 *  @param value value
 *  @param key   key
 */
- (void)userDefaultsValue:(id)value forKey:(NSString *)key;
/**
 *  从 UserDefaults 中获取数据
 *
 *  @param key key
 *
 *  @return value
 */
- (id)userDefaultsForKey:(NSString*)key;

/**
 *  构造api请求地址
 *
 *  @param api NSString
 *
 *  @return NSString API完整路径
 */
- (NSString*)buildApi:(NSString*)api;
/**
 *  获取当前时间戳
 *
 *  @return NSString
 */
- (NSString*)timestamp;
/**
 *  设置公用的返回按钮
 *
 */
- (void)setBaseNavBackStyle;

- (void)setNavRightItem:(NSString*)str;
- (void)setNavLeftNoImgItem:(NSString*)str;

- (void)rightBarButtonAction:(id)sender;
- (void)setNavLeftItem:(NSString*)str;

- (void)setNavRightItemImage:(UIImage *)img;

- (void)setNavRightItemImage:(UIImage *)img andSize:(CGSize)size;

- (void)backBtn;

-(void)setTitle:(NSString *)title;

@end
