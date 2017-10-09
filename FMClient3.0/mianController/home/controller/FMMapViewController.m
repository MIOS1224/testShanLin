//
//  FMMapViewController.m
//  FMClient3.0
//
//  Created by YT on 2016/11/25.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "FMMapViewController.h"
#import "EMManualLocViewController.h"
#import "FMLocationManager.h"
#import "SVProgressHUD.h"
#import "EMDriverAnnotationView.h"
#import "UIColor+MYColorString.h"
#import <BaiduMapAPI/BMKAnnotation.h>
#import <BaiduMapAPI/BMKShape.h>
#import "EMManualLocViewController.h"
#import "FMMapChooseDateView.h"


@interface FMMapViewController ()<BMKMapViewDelegate,UITextFieldDelegate,ManualLocDelegate,FMMapDateViewDelegate,BMKGeoCodeSearchDelegate>
{
    
    
    NSMutableArray *annotations;
    
    NSNumber *curlat; //用户手动或者程序定位的结果
    NSNumber *curlng; //用户手动或者程序定位的结果
    NSString *curAddress; //用户手动或者程序定位的结果
    
    BMKPointAnnotation *currentAnn;
    
}

@property (nonatomic,strong)BMKMapView * mapView;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;

@property (nonatomic,strong)FMMapChooseDateView * dateTimeView;

@property (nonatomic,strong)UIImageView * markImageView;
@property (nonatomic,strong)UILabel * markLabel;
@property (nonatomic,strong)UIImageView * carImageView;

@end

@implementation FMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self configSubWebView];
    [self configNavBar];
    [self addSubMapView];
    [self configSubInfo];
    [self addAnnotationSubViewWith:NO];
    
    
    [self addNoticiinfo];
    [self addChooseDateTimeView];
    
    [self setCurrentAddress];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    
    [self configDataDict];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    [self.mapView viewWillDisappear];
}
-(void)addNoticiinfo
{
    //获得当前位置信息
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(setCurrentAddress)
                                                name:kLoadCurrentAddressSuccess
                                              object:nil];
}
#pragma  mark  --------  获取网络数据 ---------------

-(void)configDataDict
{
    self.priceLabel.text   = [_dictData objectForKey:@"amount"];
    self.abolishLabel.text = [_dictData objectForKey:@"oriPrice"];
    
    Boolean  isShowTime = (Boolean) [self.dictData objectForKey:@"ShowTime"];
    NSString * canServe = [self.dictData objectForKey:@"CanService"];
    NSString * AreaMsg  = [self.dictData objectForKey:@"AreaMsg"];
    
    if ([[NSNumber numberWithBool:isShowTime]  isEqual: @1]) {
        
        self.dateTimeView.hidden = YES;
        
    }else{
        
        self.dateTimeView.hidden = YES;
    }
    
//    if ([self.dictData objectForKey:@"CanService"]) {
//        
//        
//    }
//    if ([self.dictData objectForKey:@"AreaMsg"]) {
//        
//    }
    
}
-(void)configNavBar
{
    self.navigationItem.title = @"车辆停放位置";
    UIImage * image = [UIImage imageNamed:@"back.png"];
    if (IOS7) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc]initWithImage:image style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtnClick)];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"更换车辆" style:(UIBarButtonItemStyleDone) target:self action:@selector(changeCarInfo)];
    
    self.navigationItem.leftBarButtonItem  = leftBar;
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

-(void)configSubInfo
{
    self.nextBtn.layer.borderColor  = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA].CGColor;
    self.nextBtn.layer.borderWidth  = 1;
    self.nextBtn.layer.cornerRadius = 5;
    
    NSDateFormatter * formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

    NSString * str = [formate stringFromDate:[NSDate date]];
    self.timeLabel.text = str;
    
    
}




-(void)backBtnClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#warning --------- 更换车辆界面 --------------
-(void)changeCarInfo
{
    [self.view endEditing:YES];
//    NSLog(@"更换车辆信息");
}
#pragma mark --------- init FMMapChooseDateView ------------------
-(void)addChooseDateTimeView
{
    
    self.dateTimeView.hidden = NO;
    if (!self.dateTimeView) {
        
        self.dateTimeView = [[[NSBundle mainBundle]loadNibNamed:@"FMMapChooseDateView" owner:self options:nil] firstObject];
        
        self.dateTimeView.bgView.alpha = 0.3;
        self.dateTimeView.delegate = self;
        self.dateTimeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:self.dateTimeView];
        
        NSArray * arr = [self.dictData objectForKey:@"AllowTime"];
        if (arr.count > 0) {
            
            self.dateTimeView.dataArray = arr;
        }
        
    }
    
}
#pragma mark ------- FMMapChooseDateView delegate -------
-(void)addAnnotationSubViewWith:(BOOL)isCanServe
{
    NSInteger width = 200;
    
    if (!self.carImageView) {
        
        self.carImageView = [[UIImageView alloc]init];
        self.carImageView.bounds = CGRectMake(0, 0, 35, 35);
        self.carImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
        self.carImageView.image  = [UIImage imageNamed:@"icon-point.png"];
        [self.view addSubview:self.carImageView];
    }
    
    
    if (!self.markImageView) {
        
        self.markImageView = [[UIImageView alloc]init];
        self.markImageView.bounds = CGRectMake(0, 0, width, 40);
        self.markImageView.center = CGPointMake(self.carImageView.center.x, self.carImageView.center.y - 50);
        [self.view addSubview:self.markImageView];
        
        self.markLabel = [[UILabel alloc]init];
        self.markLabel.textColor = [UIColor whiteColor];
        self.markLabel.textAlignment = NSTextAlignmentCenter;
        self.markLabel.font = [UIFont systemFontOfSize:13];
        
        self.markImageView.userInteractionEnabled = YES;
        
        [self.markImageView addSubview:self.markLabel];
        
    }
    
    NSNumber * number = [NSNumber numberWithBool:isCanServe];
    if ([number isEqual:@1]) {
        
        self.markImageView.image = [UIImage imageNamed:@"icon-goodpos.png"];
        self.markLabel.text = @"此区域可为您服务";
        self.markLabel.frame = CGRectMake(0, -3, width, 35);
        
    }else{
        
        self.markImageView.image = [UIImage imageNamed:@"icon-badpos.png"];
        self.markLabel.text = @"此区域暂未开通服务";
        self.markLabel.frame = CGRectMake(0, -3, width - 55, 35);
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width - 55, -3, 55, 35);
        [btn setTitle:@"查看范围" forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(checkServeScop) forControlEvents:(UIControlEventTouchUpInside)];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.markImageView addSubview:btn];
    
    }
    
}
-(void)checkServeScop
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"show CanServe" message:@"CanServe" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil];
    [alertView show];
}
-(void)mapDateView:(FMMapChooseDateView *)dateView andTimeValue:(NSString *)timeValue
{
    self.timeLabel.text = timeValue;
}


#pragma mark  ------------- 获得当前位置 ---------------//获得当前位置
-(void)setCurrentAddress
{
    [SVProgressHUD dismiss];
    
    curAddress = [FMLocationManager sharedManager].currentAddress;
    
    NSString * addressStr = [NSString stringWithFormat:@"%@%@",[FMLocationManager sharedManager].currentCity,[FMLocationManager sharedManager].currentAddress];
    
    self.addressLabel.text = addressStr;

}
#pragma mark  ------------- config mapView ---------------

-(void)addSubMapView
{
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 -64)];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    
    //    self.mapView.backgroundColor = [UIColor redColor];
    self.mapView.userInteractionEnabled = YES;
    //    self.mapView.mapType = 1;
    
    //    _mapView.buildingsEnabled = YES;//设定地图是否现显示3D楼块效果
    //    _mapView.overlookEnabled = YES; //设定地图View能否支持俯仰角
    //    _mapView.showMapScaleBar = YES; // 设定是否显式比例尺
    //    //    _mapView.overlooking = -45;     // 地图俯视角度，在手机上当前可使用的范围为－45～0度
    //
    _mapView.zoomLevel = 19;//设置放大级别
    //
    //    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    //    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.bgView addSubview:_mapView];
    
    self.geoSearch  = [[BMKGeoCodeSearch alloc]init];
    self.geoSearch.delegate = self;
    
}
#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    [_mapView updateLocationData:[FMLocationManager sharedManager].currentLocation];
    [self setMapCenterCoor:[FMLocationManager sharedManager].currentLocation.location];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    CLLocation * centerCoordinate = userLocation.location;
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];

}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    
    [self.view endEditing:YES];
}
#pragma mark -------   地图被拖动 获得对应的经纬度 -------------

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status{
    
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    NSLog(@"regionDidChangeAnimated");
    
    
    CGPoint touchPoint = self.carImageView.center;
    
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
//    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = touchMapCoordinate;
    

    BOOL flag =  [_geoSearch reverseGeoCode:option];
    
    if (flag) {
        //        _mapView.showsUserLocation=NO;//不显示自己的位置
    }
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSString *detailAddress  = @"";
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        BMKAddressComponent *addressComponent = result.addressDetail;//获得详细信息
        
        NSString *currentCity  = addressComponent.city;
        NSString *district     = addressComponent.district;
        NSString *streetName   = addressComponent.streetName;
        NSString *streetNumber = addressComponent.streetNumber;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MAPGETCHANGELOCATION" object:nil];
        
//        [self getLocationInfo];
        
    }
}

#pragma mark  ------- loadCurrentMethod  ---------
//获得当前坐标
-(void)loadCurrentLocation:(NSNotification * )userLocation
{
    NSDictionary *location = userLocation.userInfo;
    
    BMKUserLocation *currentLocation = location[kCurrentLocation];
    [_mapView updateLocationData:currentLocation];
    
    [self setMapCenterCoor:currentLocation.location];
}

-(void)manualSelectLocation:(NSNotification * )userLocation
{
    NSDictionary *location = userLocation.userInfo;
    
    CLLocation *currentLocation = location[kManualSelectLocation];
    
    [self setMapCenterCoor:currentLocation];
}

-(void)setMapCenterCoor:(CLLocation * )currentLocation
{
    curlat = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    curlng = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    
    //设置地图中心点
    [_mapView setCenterCoordinate:currentLocation.coordinate animated:YES];
    
    if (currentAnn) {
        
        [_mapView removeAnnotation:currentAnn];
    }
    
    currentAnn = [[BMKPointAnnotation alloc] init];
    currentAnn.coordinate = currentLocation.coordinate;
    currentAnn.title = @"当前位置";
    [_mapView addAnnotation:currentAnn];
    
}
- (IBAction)timeLabelClick:(id)sender {
    [self addChooseDateTimeView];
}
#pragma mark  ------   搜索界面 -----------
- (IBAction)addressTapClick:(id)sender {
    
    [self.view endEditing:YES];
    
    EMManualLocViewController * manu = [[EMManualLocViewController alloc]initWithNibName:@"EMManualLocViewController" bundle:nil];
    manu.delegate = self;
    [self presentViewController:manu animated:YES completion:nil];
    
}
#pragma mark ManualLocDelegate  //获取当前所选的位置信息
- (void)manualLocViewController:(EMManualLocViewController*)ctrl didSelectedPoi:(BMKPoiInfo*)poi
{
//    [[FMLocationManager sharedManager] assignLocation:poi];
//    
//    [FMLocationManager sharedManager].currentAddress  = poi.name;
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadCurrentAddressSuccess
//                                                        object:nil
//                                                      userInfo:@{kCurrentAddress: poi.name}];
//    
//    [ctrl dismissViewControllerAnimated:YES completion:^{
//    }];
}

#pragma mark -----  textField Delegate ------------
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect fram = self.chooseServerView.frame;
    fram.origin.y = SCREEN_HEIGHT - 230 - 300;
    self.chooseServerView.frame = fram;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect fram = self.chooseServerView.frame;
    fram.origin.y = SCREEN_HEIGHT - 230;
    self.chooseServerView.frame = fram;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)nextBtnClick:(id)sender {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
