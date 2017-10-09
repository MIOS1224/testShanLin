//
//  EMDriverAnnotationView.h
//  emclient
//
//  Created by mqs on 14/10/31.
//  Copyright (c) 2014年 easymin. All rights reserved.
//
#import <BaiduMapAPI/BMapKit.h>

@class EMDriverAnnotationView;

@protocol EMDriverPointDelegate <NSObject>

-(void)DriverAnnotationView:(EMDriverAnnotationView *)pointView;


@end
@interface EMDriverAnnotationView : UIView

@property(nonatomic,assign)id<EMDriverPointDelegate>delegate;

@property (nonatomic,assign)bool  isCanServe;

@end
