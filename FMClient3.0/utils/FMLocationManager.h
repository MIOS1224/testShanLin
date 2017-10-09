//
//  FMLocationManager.h
//  feimaxing
//
//  Created by will on 15/8/10.
//  Copyright (c) 2015年 FM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>
@interface FMLocationManager : NSObject

@property (nonatomic, strong) BMKUserLocation *currentLocation;
@property (nonatomic, strong) NSString *currentAddress;
@property (nonatomic, strong) NSString *currentCity;
//搜索附近地
@property (nonatomic,copy) NSString * searchName;
@property (nonatomic,copy) NSString * keyWords;
@property (nonatomic,copy) NSString * changeKey;

@property (nonatomic,strong)NSMutableArray * addressArray;

@property (nonatomic, strong)NSMutableArray * nearbyAllDrivers;

@property(nonatomic,assign)BOOL isManualLocating; //是否开启手动定位

@property(nonatomic,assign)BOOL isUserAssigned; //是否用户指定位置

+(instancetype)sharedManager;

-(void)startLocationService;

-(void)stopLocationService;

-(void)assignLocation:(BMKPoiInfo*)poi;

//-(void)findCurrentLocation;
//
//-(void)findCurrentAddress;


@end
