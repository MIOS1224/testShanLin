//
//  HomeStateView.m
//  FMClient3.0
//
//  Created by YT on 2016/12/9.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "HomeStateView.h"
#import "HTTPManager.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Base64.h"
#import "WeatherInfo.h"

@interface HomeStateView ()
@property (nonatomic,strong)UILabel * weatherLabel;
@property (nonatomic,strong)UILabel * washCarLabel;

@property (nonatomic,strong)UILabel * stateLabel;
@property (nonatomic,strong)UIImageView * stateImage;



@property (nonatomic,strong)UIImageView * weatherImage;
@property (nonatomic,strong)UIImageView * washCarImage;

@property(nonatomic,strong)NSDictionary * weatherDic;

@property(nonatomic,strong)UIView * titleView;


@end

@implementation HomeStateView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubWashView];
        
        [self getWeatherInfo];
    }
    return self;
}
-(void)setTitleStr:(NSString *)titleStr
{
    self.stateLabel.text = titleStr;
}

-(void)addSubWashView
{
    if (!self.titleView) {
        self.titleView = [[UIView alloc]init];
        self.titleView.backgroundColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        [self.titleView addSubview:titleLabel];
        
        titleLabel.text = @"飞马星车管家";
        titleLabel.font   = [UIFont systemFontOfSize:18];
        titleLabel.frame  = CGRectMake((SCREEN_WIDTH - 300)/2, 8, 300, 30);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    if (!self.stateLabel) {
        self.stateLabel = [[UILabel alloc]init];
    }
    
    if (!self.stateImage) {
        self.stateImage = [[UIImageView alloc]init];
    }
    if (!self.washCarLabel) {
        
        self.washCarLabel = [[UILabel alloc]init];
    }
    
    if (!self.weatherLabel) {
        self.weatherLabel = [[UILabel alloc]init];
    }
    if (!self.weatherImage) {
        
        self.weatherImage = [[UIImageView alloc]init];
    }
    if (!self.washCarImage) {
        
        self.washCarImage = [[UIImageView alloc]init];
    }
    
    
    self.washCarImage.image = [UIImage imageNamed:@"idx.png"];
    self.stateImage.image   = [UIImage imageNamed:@"icon-location.png"];
    
    self.weatherLabel.text = @"正在查询天气...";
    self.washCarLabel.text = @"洗车指数";
    self.stateLabel.text   = @"上海";
    
    
    
    
    
    self.stateLabel.font    = [UIFont systemFontOfSize:13];
    self.weatherLabel.font  = [UIFont systemFontOfSize:13];
    self.washCarLabel.font  = [UIFont systemFontOfSize:13];
    
    //    self.weatherLabel.contentMode = UIViewContentModeCenter;
    //    self.washCarLabel.textAlignment  = 2;
    //    self.washCarLabel.backgroundColor = [UIColor blueColor];
    
    
    self.weatherLabel.userInteractionEnabled  = YES;
    self.washCarLabel.userInteractionEnabled  = YES;
    self.stateLabel.userInteractionEnabled    = YES;
    
    self.stateLabel.textColor    = [UIColor whiteColor];
    self.weatherLabel.textColor  = [UIColor whiteColor];
    self.washCarLabel.textColor  = [UIColor whiteColor];
    
    
    self.stateLabel.textAlignment = NSTextAlignmentRight;
    
    
    [self addSubview:self.titleView];
    [self addSubview:self.stateLabel];
    [self addSubview:self.stateImage];
    [self addSubview:self.weatherLabel];
    [self addSubview:self.weatherImage];
    [self addSubview:self.washCarLabel];
    [self addSubview:self.washCarImage];
    
    UITapGestureRecognizer * stateTapGes   = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stateBtnClick)];
    UITapGestureRecognizer * weatherTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weaterBtnClick)];
    UITapGestureRecognizer * washCarTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weaterBtnClick)];
    
    
    [self.stateLabel addGestureRecognizer:stateTapGes];
    [self.weatherLabel addGestureRecognizer:weatherTapGes];
    [self.washCarLabel addGestureRecognizer:washCarTapGes];
    
}
-(void)stateBtnClick
{
    if ([self.delegate respondsToSelector:@selector(HomeStateView:stateClick:)]) {
        [self.delegate HomeStateView:self stateClick:self.stateLabel];
    }
}
-(void)weaterBtnClick
{
    if ([self.delegate respondsToSelector:@selector(HomeStateView:)]) {
        [self.delegate HomeStateView:self];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger subY = 49;
    
    self.titleView.frame    = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.stateLabel.frame = CGRectMake(5, 20, 40, 20);
    self.stateImage.frame = CGRectMake(CGRectGetMaxX(self.stateLabel.frame) + 5, 22, 15, 15);
    
    
    self.weatherImage.frame = CGRectMake(15, subY, 20, 20);
    self.weatherLabel.frame = CGRectMake(CGRectGetMaxX(self.weatherImage.frame) + 5, subY - 3, 100, 25);
    
    self.washCarLabel.frame = CGRectMake(SCREEN_WIDTH - 80, subY, 80, 20);
    self.washCarImage.frame = CGRectMake(SCREEN_WIDTH - 100, subY, 20, 20);
}

#pragma mark ----- getWeatherInfo -------
-(void)getWeatherInfo
{
    //101210904
    //    1.5.1 单站点请求可以请求所有数据大类全部要素 acdb2e_SmartWeatherAPI_147451d  101020100
    //http://api.weatherdt.com/common/?area=101020100d&type=forcast&key=93b2f3d99c1faa9d //forcast|alarm& key=密钥
//    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    //------------------------------------
    NSString *areaid = @"101020100";
    NSString *type = @"forecast_v";
    
    NSDate *_date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date = [[dateFormatter stringFromDate:_date] substringToIndex:12];
    
    NSString *appid = @"93b2f3d99c1faa9d";//这里是楼主随便输入的，瞎编的
    NSString *private_key = @"acdb2e_SmartWeatherAPI_147451d";//也是瞎编的
    
    NSString *_key = [self hmacSha1:[self getPublicKey:areaid :type :date :appid] :private_key];
    NSString *key = [self stringByEncodingURLFormat:_key];
    
    
    NSString *weatherAPI = [self getAPI:areaid :type :date :appid :key];
    
    [[HTTPManager sharedInstance]getWithAPI:weatherAPI dictionary:nil success:^(id responseObject) {
//        NSLog(@"responseObject== %@",responseObject);
        if (responseObject) {
            
            self.weatherArr = [[responseObject objectForKey:@"f"] objectForKey:@"f1"];
            self.weatherDic = [self.weatherArr firstObject];
            NSString * fabValue = [self.weatherDic objectForKey:@"fa"];
            if ([MYUtils isEmpty:fabValue]) {
                fabValue = [self.weatherDic objectForKey:@"fb"];
            }
            
            NSString * fcdValue = [self.weatherDic objectForKey:@"fc"];
            if ([MYUtils isEmpty:fcdValue]) {
                fcdValue =  [self.weatherDic objectForKey:@"fd"];
            }
            
            self.weatherLabel.text = [NSString stringWithFormat:@"%@℃%@",fcdValue,[WeatherInfo analysisWeatherInfoWith:fabValue]];
            self.washCarLabel.text = [WeatherInfo washCarDataWith:[fabValue integerValue]];
            
            self.weatherImage.image =[UIImage imageNamed:[WeatherInfo getWeatherIMmageWith:[fabValue integerValue] withFaValue:[self.weatherDic objectForKey:@"fa"]]];
            
        }
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}
//获得publicky http://api.weatherdt.com/common/?area=areaId&type=forcast&key=741c428fc7116c6f718cb14f2dda49sm
- (NSString*) getPublicKey:(NSString*)areaid :(NSString*)type :(NSString*)date :(NSString*)appid {
    
    NSString *Key = [[NSString alloc] initWithFormat:@"http://open.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=%@", areaid, type, [date substringToIndex:12], appid];
    
    return Key;
}

//获得完整的API
- (NSString*) getAPI:(NSString*)areaid :(NSString*)type :(NSString*)date :(NSString*)appid :(NSString*)key {
    
    NSString *API = [[NSString alloc] initWithFormat:@"http://open.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=%@&key=%@", areaid, type, [date substringToIndex:12], [appid substringToIndex:6], key];
    //-------------这里需要主要的是只需要appid的前6位！！！
    
    return API;
    
}
//将获得的key进性urlencode操作
- (NSString *)stringByEncodingURLFormat:(NSString*)_key{
    
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_key, nil, (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8);
    //由于ARC的存在，这里的转换需要添加__bridge
    return encodedString;
    
}
//对publickey和privatekey进行加密
- (NSString *) hmacSha1:(NSString*)public_key :(NSString*)private_key{
    
    NSData* secretData = [private_key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* stringData = [public_key dataUsingEncoding:NSUTF8StringEncoding];
    
    const void* keyBytes = [secretData bytes];
    const void* dataBytes = [stringData bytes];
    
    ///#define CC_SHA1_DIGEST_LENGTH   20          /* digest length in bytes */
    void* outs = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CCHmac(kCCHmacAlgSHA1, keyBytes, [secretData length], dataBytes, [stringData length], outs);
    
    // Soluion 1
    NSData* signatureData = [NSData dataWithBytesNoCopy:outs length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
    
    return [signatureData base64EncodedString];
    
}
@end
