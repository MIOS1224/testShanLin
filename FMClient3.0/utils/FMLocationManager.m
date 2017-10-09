//
//  FMLocationManager.m
//  feimaxing
//
//  Created by will on 15/8/10.
//  Copyright (c) 2015年 FM. All rights reserved.
//

#import "FMLocationManager.h"
#import "AFNetworkReachabilityManager.h"

@interface FMLocationManager ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>

@property (nonatomic, strong) BMKLocationService *locationManager;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;
//搜索
@property (nonatomic,strong)  BMKNearbySearchOption *option;
@property (nonatomic,strong)  BMKPoiSearch * search;

@property (nonatomic, strong, readwrite) NSNumber *curlat; //用户手动或者程序定位的结果
@property (nonatomic, strong, readwrite) NSNumber *curlng; //用户手动或者程序定位的结果

@property (nonatomic,strong)NSMutableArray * driverMessage;//车管家信息

@property (nonatomic,assign)BOOL isLocating;  //定位超时标记

@property (nonatomic,strong)NSTimer * timer;//定时定位





@end

@implementation FMLocationManager
+(instancetype)sharedManager{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if([CLLocationManager locationServicesEnabled]) {//获得用户定位授权
            
            //定位初始化
            self.locationManager = [[BMKLocationService alloc] init];
            self.locationManager.delegate = self;
            
            [BMKLocationService setLocationDistanceFilter:5];//设置最小的更新距离
            
            self.geoSearch  = [[BMKGeoCodeSearch alloc]init];
            self.geoSearch.delegate = self;
            
            self.option = [[BMKNearbySearchOption alloc] init];
            
            self.search = [[BMKPoiSearch alloc] init];
            self.search.delegate = self;
            
            //搜索数组
            _addressArray  = [[NSMutableArray alloc]init];
            
            //车管家信息
            _driverMessage = [[NSMutableArray alloc]init];
            
            _nearbyAllDrivers = [[NSMutableArray alloc]init];
            
            [self autoLocating];//设置每30秒定位一次
            
            
//            [self getLatitudeAndLongitudeWithCity:@"上海市" address:@"思贤路文吉路251"];
        }else {
            
            //提示用户无法进行定位操作
            [UIAlertController alertControllerWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位"preferredStyle:(UIAlertControllerStyleAlert)];
            
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alertView show];
        }
    }
    return self;
}
-(void)startLocationService
{
    if (!self.isLocating) {
        self.isLocating = YES;
        [_locationManager startUserLocationService];
        
        [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(locatingTimeout) userInfo:nil repeats:NO];
    }
}

-(void)locatingTimeout
{
    if (self.isUserAssigned) {
        [self stopLocationService];
        return;
    }
    
    if (self.isLocating) {
        [_locationManager stopUserLocationService];
        if (self.isManualLocating) {
            [_locationManager.delegate didFailToLocateUserWithError:nil];
            self.isManualLocating = NO;
        }
        
        self.isLocating = NO;
    }
}

-(void)stopLocationService
{
    [_locationManager stopUserLocationService];
    self.isLocating = NO;
    self.isManualLocating = NO;
}

-(void)assignLocation:(BMKPoiInfo*)poi
{
    self.isUserAssigned = YES;
    [self stopLocationService];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:poi.pt.latitude longitude:poi.pt.longitude];

    //保存定位数据
    _currentAddress = poi.name;
    _curlat = [NSNumber numberWithDouble:poi.pt.latitude];
    _curlng = [NSNumber numberWithDouble:poi.pt.longitude];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kManualSelectLocation
                                                       object:nil
                                                     userInfo:@{kManualSelectLocation:location}];//获得当前坐标
    
    self.currentAddress = [NSString stringWithFormat:@"%@", poi.address];
    self.currentCity    = poi.city;
    
    //添加到本地--适应集成代码
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:UD_LOC_TIME];
//    [[NSUserDefaults standardUserDefaults] setObject:self.currentAddress forKey:UD_CUR_ADDR];
//    [[NSUserDefaults standardUserDefaults] setObject:self.currentCity forKey:UD_CUR_CITY];
//    [[NSUserDefaults standardUserDefaults] setObject:_curlat forKey:UD_CUR_LAT];
//    [[NSUserDefaults standardUserDefaults] setObject:_curlng forKey:UD_CUR_LNG];
    
    //添加都搜索数组
    [_addressArray insertObject:poi atIndex:0];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadCurrentAddressSuccess object:nil userInfo:@{kCurrentAddress:self.currentAddress}];

}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //定位成功
    if (userLocation != nil) {
        _currentLocation     = userLocation;

        CLLocation *location = userLocation.location;
        CLLocationCoordinate2D coordinate= location.coordinate;
    
        //保存定位数据
        _curlat = [NSNumber numberWithDouble:coordinate.latitude];
        _curlng = [NSNumber numberWithDouble:coordinate.longitude];
        
//        NSLog(@"didUpdatelat===%@",_curlat);
//        NSLog(@"didUpdatelng===%@",_curlng);
        
        
      
        [[NSUserDefaults standardUserDefaults] setObject:self.currentCity forKey:UD_CUR_CITY];
        [[NSUserDefaults standardUserDefaults] setObject:_curlat forKey:UD_CUR_LAT];
        [[NSUserDefaults standardUserDefaults] setObject:_curlng forKey:UD_CUR_LNG];
        
        
        //发起反编码请求
        BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
        option.reverseGeoPoint = coordinate;
        [_geoSearch reverseGeoCode:option];
        
        //定位成功关闭定位
        [self stopLocationService];
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowAdViewController"
                                                 object:nil
                                                 userInfo:nil];//发送弹出广告视图的通知
            
        });
        
//        [self loadDriverMeaasege];//加载周边车管家信息
    }

}

#pragma mark 设置持续定位
- (void)autoLocating
{
//    if (!self.isLocating && !self.isUserAssigned) {
//        [self startLocationService];
//    }
    AFNetworkReachabilityManager * reachManager = [AFNetworkReachabilityManager sharedManager];
    [reachManager startMonitoring];
    
    
    if (!self.isLocating && !self.isUserAssigned) {
        [self startLocationService];
    }
    // after 30s auto locating again
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    
    //添加--有网络才自动更新
    if (reachManager.networkReachabilityStatus){
        
        _timer = [NSTimer timerWithTimeInterval:3000
                                       target:self
                                       selector:@selector(autoLocating)
                                       userInfo:nil
                                        repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
   
}


- (void)didFailToLocateUserWithError:(NSError *)error
{
//    NSLog(@"FMLoccationMagager.error==%@",error.localizedDescription);
    //定位失败
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadCurrentAddressError object:nil];
    self.isManualLocating = NO;
    self.isLocating = NO;
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BMKAddressComponent *addressComponent = result.addressDetail;//获得详细信息
        
        NSString *district     = addressComponent.district;
        NSString *streetName   = addressComponent.streetName;
        NSString *streetNumber = addressComponent.streetNumber;
        NSString *currentCity  = addressComponent.city;
        
        NSString *address = district;
        
        if (streetName) {
            
            address = [address stringByAppendingString:streetName];
        }
        if (streetNumber) {
            address = [address stringByAppendingString:streetNumber];
        }
        
        self.currentAddress = [NSString stringWithFormat:@"%@",address];
        self.currentCity    = currentCity;
        
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoadCurrentLocationSuccess
                                                           object:nil
                                                         userInfo:@{kCurrentLocation:_currentLocation}];//获得当前坐标
        
        //添加到本地--适应集成代码
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:UD_LOC_TIME];
        [[NSUserDefaults standardUserDefaults] setObject:address forKey:UD_CUR_ADDR];
        [[NSUserDefaults standardUserDefaults] setObject:addressComponent.city forKey:UD_CUR_CITY];
        
        //添加都搜索数组
        BMKPoiInfo *poi = [[BMKPoiInfo alloc] init];
        poi.name = self.currentAddress;
        poi.pt = _currentLocation.location.coordinate;
        poi.address = streetName;
        
        
        [_addressArray insertObject:poi atIndex:0];
    }
    else
    {
        self.currentAddress = @"定位成功，但未能获取到所在地名称";
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadCurrentAddressSuccess object:nil userInfo:@{kCurrentAddress:self.currentAddress}];
}

-(void)setKeyWords:(NSString *)keyWords
{
    _keyWords = keyWords;
    if (![_changeKey isEqual:_keyWords]) {
        _option.keyword  = keyWords;
        
        _option.location = _currentLocation.location.coordinate;
        
        [_search poiSearchNearBy:_option];
        
        _keyWords = _changeKey;
        
    }

}


//
////根据地理位置求得用户预约地的经纬度,然后根据经纬度求得附近的车管家,进行下单,
//- (void)getLatitudeAndLongitudeWithCity:(NSString *)city address:(NSString *)address {
//
//    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geoCodeSearchOption.city= city;
//    geoCodeSearchOption.address = address;
//    BOOL flag = [_geoSearch geoCode:geoCodeSearchOption];
//    
//    if(flag)
//    {
//        NSLog(@"geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"geo检索发送失败");
//    }
//}
//
//
//
//
////实现Deleage处理回调结果
////接收正向编码结果
//- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
//    if (error == BMK_SEARCH_NO_ERROR) {
//        //在此处理正常结果
//    }
//    else {
//        NSLog(@"抱歉，未找到结果");
//    }
//}

#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
//    BMKPoiInfo *poiInfo = [_addressArray firstObject];
    
    [_addressArray removeAllObjects];
   
    
//    NSString *prefix = @"当前位置：";
//    
//    if ([poiInfo.name hasPrefix:prefix]) {
//        [_addressArray addObject:poiInfo];
//    }
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        [_addressArray addObjectsFromArray:poiResult.poiInfoList];
        
    }
    else
    {
        CLLocationCoordinate2D coor;
        coor.latitude   = -1;
        coor.longitude  = -1;
        
        BMKPoiInfo *poi = [[BMKPoiInfo alloc] init];
        poi.name        = @"没有搜索结果";
        poi.pt          = coor;
        
        [_addressArray addObject:poi];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNearbySearchOptionSuccess object:nil userInfo:@{kSearchAddressArray:_addressArray}];
}

#pragma mark 加载车管家所有信息
-(void)loadDriverMeaasege
{
}
-(void)dealloc
{
    [_locationManager stopUserLocationService];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
