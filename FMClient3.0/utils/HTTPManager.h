//
//  HTTPManager.h
//  feimaxing
//
//  Created by will on 15/7/15.
//  Copyright (c) 2015年 FM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^success)(id responseObject);
typedef void (^failure)(NSURLSessionDataTask *dataTask, NSError *error);
typedef void(^successJson) (id JSON);

//网络状态
typedef enum {
    
    StatusUnknown           = -1,
    StatusNotReachable      =  0,
    StatusReachableViaWWAN  =  1,
    StatusReachableViaWiFi  =  2
    
}HTTPNetStaus;

@interface HTTPManager : NSObject

@property (nonatomic,assign) HTTPNetStaus netStaus;


+ (instancetype)sharedInstance;

#pragma mark ------------ 统一请求   ---------
-(void)requestWithAPI:(NSString *)api dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure;

#pragma mark ------------ POST请求  ----------
-(void)postWithAPI:(NSString *)api dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure;

#pragma mark ------------ get请求  ----------
-(void)getWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure;

-(void)getMailCodeWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure;

-(void)collectActionWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure;

//get  请求添加了forHTTPHeaderField
//- (void)getAllCity:(NSString *)Url Parameters:(NSDictionary *)dict headers:(NSDictionary *)headDict success:(success)success failure:(failure)failure;

#pragma mark -------- 下载 ------------
//- (void)downLoadWithUrlString:(NSString *)urlString;

#pragma mark --------  上传   ------------
- (void)uploadWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params upImg:(UIImage *)upImg withImageName:(NSString *)imageName andTheFileName:(NSString *)fileName imageType:(NSString *)imageType success:(success)success  failure:(failure)failure;

- (void)startCheckNetStatus;

@end
