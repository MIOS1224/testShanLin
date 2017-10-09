//
//  FMTabbarAppear.m
//  FMClient3.0
//
//  Created by YT on 2017/3/28.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "FMTabbarAppear.h"
#import "FMTabbar.h"
@interface FMTabbarAppear()

@property (nonatomic,strong)FMTabbar * tabbar;
@property (nonatomic,strong)NSArray * bottomArr;
@property (nonatomic,strong)NSArray * headArr;


@end
@implementation FMTabbarAppear

+(instancetype)sharedManager{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    NSArray * arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"NativeUrlConfig"];
    if (arr.count) {
        [_sharedManager refineNativeURLConfigWith:arr];
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(configNativeUrl:) name:@"NativeUrlConfig" object:nil];
    
    return _sharedManager;
}
-(void)refineNativeURLConfigWith:(NSArray *)arr
{
    if ([[arr lastObject] isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        
        NSDictionary * arrDict = [arr lastObject];
        
        NSArray * allKeys = [arrDict allKeys];
        
        if ([allKeys containsObject:@"Bottom"]) {
            
            self.bottomArr = [arrDict objectForKey:@"Bottom"];
            self.headArr   = [arrDict objectForKey:@"HeadAndBottom"];
        }
    }
    
}
-(void)configNativeUrl:(NSNotification *)userInfo
{
    NSDictionary * dict = userInfo.userInfo;
    
    NSArray * arr = [dict objectForKey:@"NativeUrlConfig"];
    [self refineNativeURLConfigWith:arr];
    
}
-(BOOL)checkTabbarWithUrl:(NSString *)urlStr
{
    for (NSString * str  in self.headArr) {
        if ([self findStr:urlStr andTarget:str]) {
            [self.tabbar setHidden:YES];
            return YES;
        }
    }
    if ([self findStr:urlStr andTarget:@"#mybalance"]) {
        [self.tabbar setHidden:YES];
        return YES;
    }
    self.tabbar = [FMTabbar sharedManager];
    
    if ([self findStr:urlStr andTarget:@"#home"]||[self findStr:urlStr andTarget:self.bottomArr[0]] ) {
        [self.tabbar chooseHomePage];
        return NO;
        
    }else if ([self findStr:urlStr andTarget:self.bottomArr[1]])
    {
        [self.tabbar chooseStorePage];
         return NO;
        
    }else if ([self findStr:urlStr andTarget:@"#orders"]||[self findStr:urlStr andTarget:self.bottomArr[2]])
    {
        [self.tabbar chooseOrderPage];
         return NO;
        
    }else if ([self findStr:urlStr andTarget:@"#me"]||[self findStr:urlStr andTarget:self.bottomArr[3]])
    {
        [self.tabbar chooseMinePage];
         return NO;
        
    }else{
        
        self.tabbar.hidden = YES;
         return YES;
    }
}
-(BOOL)findStr:(NSString *)urlStr andTarget:(NSString *)target
{
    if ([urlStr rangeOfString:target].location != NSNotFound) {
        return YES;
    }else
    {
        return NO;
    }
}
@end
