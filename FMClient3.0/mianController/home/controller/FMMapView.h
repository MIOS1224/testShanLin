//
//  FMMapView.h
//  FMClient3.0
//
//  Created by will on 16/12/16.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMMapDelegate<NSObject>
-(void)mapViewBackBtnClik;
-(void)mapViewChangeCarClick;
-(void)mapViewChooseDetailTime;
-(void)mapViewSearchAddress;
-(void)mapViewNextBtnClickWithCoord:(CLLocationCoordinate2D )coord andAddress:(NSString *)address timeValue:(NSString * )timeValue spanValue:(NSString *)spanValue;

-(void)mapViewChangeCurrentCoord:(CLLocationCoordinate2D )coord city:(NSString *)city andAddress:(NSString *)address;

@end

@interface FMMapView : UIView
{
    NSString * _currentAddress;
    
}
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIView *chooseTimeView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UITextField *detaileLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *abolishLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressBottomConst;

@property (nonatomic,strong)BMKMapView * mapView;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;

@property (nonatomic,strong)NSDictionary * dataDict;

@property (nonatomic,strong)NSString * currentAddress;
@property (nonatomic,strong)NSString * timeValue;
@property (nonatomic,strong)NSString * spanValue;


@property (nonatomic,weak)id<FMMapDelegate> delegate;






-(void)setDetailLabelInfo:(NSString *)currentAddress;
-(void)configDataDict:(NSDictionary *)dataDict;
-(void)setMapCenterCoor:(CLLocation * )currentLocation;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)changeCarClick:(id)sender;
- (IBAction)timeViewClick:(id)sender;
- (IBAction)addressClick:(id)sender;


- (IBAction)nextBtnClick:(id)sender;

@end
