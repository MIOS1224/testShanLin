//
//  Header.h
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#define Header_h

#ifndef PA_THEME
#define PA_THEME
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#endif

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5  (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6  (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// 1.判断是否为iOS7
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define IOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.3)


// 2.获得RGB颜色
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.自定义Log
#ifdef DEBUG
#define MYLog(...) NSLog(__VA_ARGS__)
#else
#define MYLog(...)
#endif


#define SystemFont(a)           [UIFont  systemFontOfSize:a]
#define SystemBoldFont(a)       [UIFont boldSystemFontOfSize:a]

#define ImageNamed(name)        [UIImage imageNamed:name]

#define ImageWithPath(name,formatType) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:formatType]]

//4.统一字体
//#f1870a#e95604
#define MYSystemFont @"HiraginoSansGB-W3"//冬青黑体
#define MYNAVIGATIONCOLORDATA @"#e82a2b"//导航栏的颜色
#define MYORANGECOLOR MYColor(235, 114, 13)//橙色的按钮

//5.统一字号
#define TEXT_SIZE (SCREEN_MAX_LENGTH < 600 ? 13 : 14)
#define SUBTITLE_SIZE (SCREEN_MAX_LENGTH < 600 ? 14 : 17)
#define TITLE_SIZE (SCREEN_MAX_LENGTH < 600 ? 16 : 19)

//6.导航栏的左边返回按钮图片
#define MYNAVLEFTIMAGE  (IOS7 ? [[UIImage imageNamed:@"navgation_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : [UIImage imageNamed:@"navgation_back"])

#define MYFREE  (IOS7 ? [[UIImage imageNamed:@"free_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : [UIImage imageNamed:@"free_back"])

#define MYMINENAVLEFTIMAGE  (IOS7 ? [[UIImage imageNamed:@"back_white_item"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : [UIImage imageNamed:@"back_white_item"])

//7.定位当前城市位置
#define kLoadCurrentAddressSuccess  @"kLoadCurrentAddressSuccess"
#define kCurrentAddress             @"kCurrentAddress"

//定位当前坐标
#define kLoadCurrentLocationSuccess @"kLoadCurrentLocationSuccess"
#define kCurrentLocation            @"kCurrentLocation"
#define kManualSelectLocation       @"kManualSelectLocation"

//9.定位失败
#define kLoadCurrentAddressError    @"kLoadCurrentAddressError"

//10.搜索周边信息
#define kNearbySearchOptionSuccess  @"kNearbySearchOptionSuccess"
#define kSearchAddressArray         @"kSearchAddressArray"

#define kDriversData                @"kDriversData"
#define kIsNetworkError             @"kIsNetworkError"

//11,数据类型的重新定义

#define MYStringRef                    @property (nonatomic,copy)   NSString *
#define MYNumberRef                    @property (nonatomic,strong) NSNumber *
#define MYMutableArrayRef              @property (nonatomic,strong) NSMutableArray *
#define MYArrayRef                     @property (nonatomic,strong) NSArray *
#define MYBOOL                         @property (nonatomic) BOOL

//12,serviceTag,type定义
#define kAllServiceTag              @"kAllServiceTag"

#define BACKGROUNDCOLOR       @"#f0f0f0"
#define KORANGRE @"#ff6c0d"

#define kShowWelcome    @"isShowWelcome" //表示是否是第一次启动
#define UD_LOGIN_TOKEN  @"ud_login_token"//登录信息字段


#define UD_CURRENT_ID     @"ud_current_id"//升级信息id唯一编号
#define UD_CURRENT_VER    @"ud_current_ver"//登录信息字段
#define UD_LISTXML_ARRAY  @"ud_listxml_array"//listxml array信息



//定义单例的写法
#define SingletonH(name) + (instancetype)shared##name;
#define SingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone { \
return _instance; \
}



#define LINE_SAPCING  4 
//http://61.152.218.34:555/fmars/m2/index.html
//www.fmars.cn

#define BASICURL   @"http://61.152.218.34:555/fmars/api.php/getNativeUrlConfig"
#define LOADURL    @"http://61.152.218.34:555/fmars/m2/index.html?native=0"
#define NEWLOADURL @"http://61.152.218.34:555/fmars/m2"

#define STANDYURL  @"http://61.152.218.34:555/fmars/m2/index.html?"
#define LOADZIPURL @"http://61.152.218.34:555/fmars"
#define SUFFIXSTR  @"fmars/"


//#define BASICURL    @"http://192.168.1.44:82/api.php/getNativeUrlConfig"
//#define LOADURL     @"http://192.168.1.44:82/m3/index.html?native=1"
//#define NEWLOADURL  @"http://192.168.1.44:82/m3"
//
//#define STANDYURL   @"http://192.168.1.44:82/m2/index.html?"
//#define LOADZIPURL  @"http://192.168.1.44:82"
//#define SUFFIXSTR   @":82/"

#define  IMAGE_PATH(X) [@"http://" stringByAppendingString:[[[MYConfigUtils sharedInstance] host] stringByAppendingString:X.image_url]]


#define BASICPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]



#ifdef __OBJC__

#import "MYBaseController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "UIColor+MYColorString.h"
#import "FMBasicViewController.h"
#import "FMTabbarAppear.h"
#import "iToast.h"


#import "MYUtils.h"
#import "SSZipArchive.h"
#endif /* Header_h */


