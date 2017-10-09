//
//  FMMapView.m
//  FMClient3.0
//
//  Created by will on 16/12/16.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "FMMapView.h"
#import "EMManualLocViewController.h"
#import "FMLocationManager.h"
#import "SVProgressHUD.h"
#import "EMDriverAnnotationView.h"
#import "UIColor+MYColorString.h"
#import <BaiduMapAPI/BMKAnnotation.h>
#import <BaiduMapAPI/BMKShape.h>
#import "EMManualLocViewController.h"
#import "FMMapChooseDateView.h"
#import "FMAlertView.h"
#import "MYUtils.h"

@interface FMMapView ()<BMKMapViewDelegate,UITextFieldDelegate,FMMapDateViewDelegate,BMKGeoCodeSearchDelegate>
{
    
    
    NSMutableArray *annotations;
    
    NSNumber *curlat; //用户手动或者程序定位的结果
    NSNumber *curlng; //用户手动或者程序定位的结果
    NSString *curAddress; //用户手动或者程序定位的结果
    
    BMKPointAnnotation *currentAnn;
    
}

@property (nonatomic,assign)CLLocationCoordinate2D changeCoord;

@property (nonatomic,strong)FMMapChooseDateView * dateTimeView;

@property (nonatomic,strong)UIImageView * markImageView;
@property (nonatomic,strong)UIImageView * carImageView;

@property(nonatomic,strong)UIButton * carBtn;

@property (nonatomic,strong)UILabel * markLabel;
@property (nonatomic,strong)NSString * AreaMsg;

@property (nonatomic,assign)BOOL isChange;



@end
@implementation FMMapView


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [self configMapView];
    [self configSubInfo];
    
    
    [self addNoticiinfo];
    self.isChange = NO;
    
    
//    [self setCurrentAddress];
    
}

-(void)addNoticiinfo
{
//    获得当前位置信息
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(getSearchCityInfo:)
                                                name:@"manulocaselect"
                                              object:nil];
    
    
}
#pragma mark  ------------- 获得当前位置 ---------------//获得当前位置
-(void)getSearchCityInfo:(NSNotification *)info
{
    NSDictionary * dict = info.userInfo;
    BMKPoiInfo * poi = [dict objectForKey:@"BMKPoiInfo"];
    
    if (dict) {
        NSString * address = [NSString stringWithFormat:@"%@%@%@",poi.city,poi.address,poi.name];
        [self setDetailLabelInfo:address];
        
        [_mapView setCenterCoordinate:poi.pt animated:YES];
        
    }

}
#pragma  mark  --------  获取网络数据 ---------------
-(void)configDataDict:(NSDictionary *)dataDict
{
    self.dataDict = dataDict;
    self.priceLabel.text   = [NSString stringWithFormat:@"%@%@",@"￥",[self.dataDict objectForKey:@"amount"]];
    self.abolishLabel.text = [NSString stringWithFormat:@"%@%@",@"￥",[self.dataDict objectForKey:@"oriPrice"]];
    
    
//    Boolean  isShowTime = (Boolean) [self.dataDict objectForKey:@"ShowTime"];
    NSString *  isShowTime = [NSString stringWithFormat:@"%@",[self.dataDict objectForKey:@"ShowTime"]];
    NSString *  canServe   = [NSString stringWithFormat:@"%@",[self.dataDict objectForKey:@"CanService"]];
    self.AreaMsg        = [self.dataDict objectForKey:@"AreaMsg"];

    
    if ([canServe integerValue] == 1) {
        
        [self addAnnotationSubViewWith:YES];
        self.nextBtn.enabled = YES;
        
    }else{
        
        [self addAnnotationSubViewWith:NO];
        self.nextBtn.enabled = NO;
    }
    
    if ([isShowTime integerValue] == 1) {

        [self timeViewClick:nil];
        self.chooseTimeView.hidden = NO;
        self.dateTimeView.hidden   = NO;
    }else{
        
        self.dateTimeView.hidden   = YES;
        self.chooseTimeView.hidden = YES;
    }
    
}

-(void)setDetailLabelInfo:(NSString *)currentAddress
{
    if ([MYUtils isNotEmpty:currentAddress]) {
        
        self.addressLabel.text = currentAddress;
        self.currentAddress    = currentAddress;
    }
}

-(void)configSubInfo
{
    self.addressView.clipsToBounds = YES;
    
    self.chooseTimeView.layer.cornerRadius = 4;
    self.addressView.layer.cornerRadius    = 4;
    
    self.navBarView.backgroundColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    self.nextBtn.layer.borderColor  = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA].CGColor;
    
    self.nextBtn.layer.borderWidth  = 1;
    self.nextBtn.layer.cornerRadius = 5;
    
    NSDateFormatter * formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString * str = [formate stringFromDate:[NSDate date]];
    
    self.timeValue = [[str componentsSeparatedByString:@" "] firstObject];
    NSString * spanValue = [[str componentsSeparatedByString:@" "] lastObject];
    
    NSInteger num = [[[spanValue componentsSeparatedByString:@":"] firstObject] integerValue];
    self.spanValue = [NSString stringWithFormat:@"%ld:00-%ld:00",num,num + 1];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",self.timeValue,self.spanValue];
    
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
        [self addSubview:self.dateTimeView];
        
        NSArray * arr = [self.dataDict objectForKey:@"AllowTime"];
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
        self.carImageView.bounds = CGRectMake(0, 0, 30, 40);
        self.carImageView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - 15);
        self.carImageView.image  = [UIImage imageNamed:@"icon-point.png"];
//        self.carImageView.backgroundColor = [UIColor redColor];
        [self addSubview:self.carImageView];
    }
    
    
    if (!self.markImageView) {
        
        self.markImageView = [[UIImageView alloc]init];
        self.markImageView.bounds = CGRectMake(0, 0, width, 40);
        self.markImageView.center = CGPointMake(self.carImageView.center.x, self.carImageView.center.y - 50);
        [self addSubview:self.markImageView];
        
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
        self.carBtn.hidden = YES;
        
    }else{
        
        self.markImageView.image = [UIImage imageNamed:@"icon-badpos.png"];
        self.markLabel.text = @"此区域暂未开通服务";
        self.markLabel.frame = CGRectMake(0, -3, width - 50, 35);
        self.carBtn.hidden = NO;
        
        
        if (self.carBtn == nil) {
            
            self.carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.carBtn.frame = CGRectMake(width - 55, -3, 55, 35);
            [self.carBtn setTitle:@"查看范围" forState:(UIControlStateNormal)];
            [self.carBtn addTarget:self action:@selector(checkServeScop) forControlEvents:(UIControlEventTouchUpInside)];
            self.carBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.markImageView addSubview:self.carBtn];
        }
        
        
    }
    
}
-(void)checkServeScop
{
    FMAlertView * alertView = [[[NSBundle mainBundle]loadNibNamed:@"FMAlertView" owner:self options:nil] firstObject];
    alertView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    
    [alertView configAlertViewData:self.AreaMsg];
    
    [self addSubview:alertView];
    
    
}


-(void)mapDateView:(FMMapChooseDateView *)dateView andTimeValue:(NSString *)timeValue
{
    self.carImageView.hidden  = NO;
    self.markLabel.hidden     = NO;
    self.markImageView.hidden = NO;
    self.timeValue = dateView.dateValue;
    self.spanValue = dateView.spanValue;
    
    self.timeLabel.text = timeValue;
}
-(void)mapDateViewBackClick:(FMMapChooseDateView *)dateView
{
    
    self.carImageView.hidden = NO;
    self.markLabel.hidden = NO;
    self.markImageView.hidden = NO;
}
-(void)configMapView
{
    if(self.mapView == nil){
        
        self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64)];
        self.mapView.delegate = self;
        self.mapView.userInteractionEnabled = YES;
        self.mapView.zoomLevel = 19;
        
        self.geoSearch  = [[BMKGeoCodeSearch alloc]init];
        self.geoSearch.delegate = self;
        
        [self.bgView addSubview:self.mapView];
    }
    
    
    
}


#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
//    [self.mapView updateLocationData:[FMLocationManager sharedManager].currentLocation];
    [self setMapCenterCoor:[FMLocationManager sharedManager].currentLocation.location];
}

//-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//    
////    CLLocation * centerCoordinate = userLocation.location;
//    self.mapView.centerCoordinate = userLocation.location.coordinate;
//    
//    
//}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    return nil;
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    
    [self endEditing:YES];
}
#pragma mark -------   地图被拖动 获得对应的经纬度 -------------
-(void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.isChange = YES;
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (self.isChange) {
        
        CGPoint touchPoint = self.carImageView.center;
        
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
//        NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
        
        self.changeCoord = touchMapCoordinate;
        
        BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc]init];
        option.reverseGeoPoint = touchMapCoordinate;
        
        
        BOOL flag =  [_geoSearch reverseGeoCode:option];
        
        if (flag) {
            _mapView.showsUserLocation=NO;//不显示自己的位置
        }
    }
    
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSString *detailAddress  = @"";
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
//        BMKAddressComponent *addressComponent = result.addressDetail;//获得详细信息
        
        BMKPoiInfo * poiInfo = [result.poiList firstObject];
        
        detailAddress = [NSString stringWithFormat:@"%@%@",poiInfo.address,poiInfo.name];
        [self setDetailLabelInfo:detailAddress];
        
        if ([self.delegate respondsToSelector:@selector(mapViewChangeCurrentCoord:city:andAddress:)]) {

            if (self.changeCoord.longitude == 0) {
                self.changeCoord = [FMLocationManager sharedManager].currentLocation.location.coordinate;
            }
            if ([MYUtils isNotEmpty:poiInfo.city] || [MYUtils isNotEmpty:poiInfo.address]) {
                
                [self.delegate mapViewChangeCurrentCoord:self.changeCoord city:poiInfo.city andAddress:poiInfo.address];
            }
        }
        
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



#pragma mark -----  textField Delegate ------------
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.addressBottomConst.constant = 300;
    self.carImageView.hidden  = YES;
    self.markImageView.hidden = YES;
    self.markLabel.hidden     = YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.addressBottomConst.constant = 50;
    self.carImageView.hidden  = NO;
    self.markImageView.hidden = NO;
    self.markLabel.hidden     = NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}
#pragma mark -----  Button Click  ------------
- (IBAction)backBtnClick:(id)sender {
    [self endEditing:YES];
//    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(mapViewBackBtnClik)]) {
        [self.delegate mapViewBackBtnClik];
        
    }
    
}

- (IBAction)changeCarClick:(id)sender {
//    NSLog(@"更换车辆");
    
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(mapViewChangeCarClick)]) {
        [self.delegate mapViewChangeCarClick];
    }
}

- (IBAction)timeViewClick:(id)sender {
    
    [self endEditing:YES];
//    self.dateTimeView.hidden = NO;
    
    self.carImageView.hidden = YES;
    self.markLabel.hidden = YES;
    self.markImageView.hidden = YES;
    [self addChooseDateTimeView];
    
    
//    if ([self.delegate respondsToSelector:@selector(mapViewChooseDetailTime)]) {
//        [self.delegate mapViewChooseDetailTime];
//    }
}

- (IBAction)addressClick:(id)sender {
    
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(mapViewSearchAddress)]) {
        [self.delegate mapViewSearchAddress];
    }
}

- (IBAction)nextBtnClick:(id)sender {
    
    [self endEditing:YES];
    [self performSelector:@selector(nextBtnDelayClick) withObject:nil afterDelay:1.0f];

}

-(void)nextBtnDelayClick
{
    
    if (self.changeCoord.latitude == 0) {
        self.changeCoord = [FMLocationManager sharedManager].currentLocation.location.coordinate;
    }
    
    if ([self.delegate respondsToSelector:@selector(mapViewNextBtnClickWithCoord:andAddress:timeValue:spanValue:)]) {
        NSString * address = [NSString stringWithFormat:@"%@%@",self.currentAddress,self.detaileLabel.text];
        
        [self.delegate mapViewNextBtnClickWithCoord:self.changeCoord andAddress:address timeValue:self.timeValue spanValue:self.spanValue];
        
    }else{
        
        [self addAnnotationSubViewWith:NO];
    }
}


@end
