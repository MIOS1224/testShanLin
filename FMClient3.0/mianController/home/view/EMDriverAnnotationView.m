//
//  EMDriverAnnotationView.m
//  emclient
//
//  Created by mqs on 14/10/31.
//  Copyright (c) 2014年 easymin. All rights reserved.
//

#import "EMDriverAnnotationView.h"
//#import "FMStarRatingView.h"
#import "UIImageView+AFNetworking.h"

@interface EMDriverAnnotationView()

@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) UIImageView *headView;

@property(nonatomic,strong) UILabel *areaLabel;

@property(nonatomic,strong) UIButton * serverBtn;

@property (nonatomic,strong)UIImageView * martView;


//@property(nonatomic,strong) FMStarRatingView *ratingView;

@end

@implementation EMDriverAnnotationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubImageViewW];
    }
    return self;
}
-(void)setIsCanServe:(bool)isCanServe
{
    self.isCanServe = isCanServe;
    NSNumber * number = [NSNumber numberWithBool:isCanServe];
    
    if ([number isEqual:@1]) {
        
        self.martView.image = [UIImage imageNamed:@"icon-goodpos.png"];
        
    }else{
        
        self.martView.image = [UIImage imageNamed:@"icon-badpos.png"];
    }
}

-(void)addSubImageViewW
{
    
    CGRect rect = CGRectMake(0, -25, 180, 100);
    if (!self.bgView) {
        self.bgView = [[UIView alloc] initWithFrame:rect];
        self.bgView.backgroundColor = [UIColor redColor];
        self.bgView.userInteractionEnabled = YES;
        
        [self addSubview:self.bgView];
        [self setFrame:rect];
    }
    if (!self.martView) {
        self.martView = [[UIImageView alloc]init];
        self.martView.frame = CGRectMake(0, 0, 180, 30);
        
        self.martView.userInteractionEnabled = NO;
        [self.bgView addSubview:self.martView];
        
        self.areaLabel = [[UILabel alloc]init];
        self.areaLabel.frame = CGRectMake(2, 0, 120, 25);
        [self.martView addSubview:self.areaLabel];
        self.areaLabel.text = @"此区域暂未开通服务";
        self.areaLabel.textColor = [UIColor whiteColor];
        self.areaLabel.font = [UIFont systemFontOfSize:13];
        
        self.serverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.serverBtn.frame = CGRectMake(125, 0, 55, 25);
        
        [self.serverBtn setTitle:@"查看范围" forState:(UIControlStateNormal)];
        [self.serverBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.serverBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.martView addSubview:self.serverBtn];
//        self.serverBtn.backgroundColor = [UIColor blueColor];
        
        // action
        
        [self.serverBtn addTarget:self action:@selector(checkServicesArea) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }
    if (!self.headView) {
        rect = CGRectMake(70, 33, 40, 40);
        self.headView = [[UIImageView alloc] initWithFrame:rect];
        self.headView.image = [UIImage imageNamed:@"icon-point.png"];
        
        [self.bgView addSubview:self.headView];
    }
}
-(void)checkServicesArea
{
    if ([self.delegate respondsToSelector:@selector(DriverAnnotationView:)]) {
        [self.delegate DriverAnnotationView:self];
    }
}

@end
