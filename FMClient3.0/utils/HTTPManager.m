//
//  HTTPManager.m
//  GMJCB_PROJECT
//
//  Created by Danny_Yan on 15/4/1.
//  Copyright (c) 2015年 Winsafe. All rights reserved.
//

#define kTimeOutInterval 100

#import "HTTPManager.h"
#import "NSData+CommonCrypto.h"
#import "iToast.h"
#import "SVProgressHUD.h"


@interface  HTTPManager()

@property (nonatomic,strong)MYBaseConfigUtils * cfg;
@property (nonatomic,strong)AFHTTPSessionManager * sessManager;
@property (nonatomic,strong)__block AFNetworkReachabilityManager *netStatusManager;

@end

__strong static id _sharedObject = nil;


@implementation HTTPManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
        //监测网络
        [_sharedObject checkAFNetworkStatus];
        
    });
    return _sharedObject;
}
+(id)allocWithZone:(NSZone *)zone{
    
    
    @synchronized(self){
        if (!_sharedObject) {
            _sharedObject = [super allocWithZone:zone]; //确保使用同一块内存地址
            return _sharedObject;
        }
        return nil;
    }
}
- (id)init;
{
    @synchronized(self) {
        if (self = [super init]){
            return self;
        }
        return nil;
    }
}

// 懒加载
- (AFHTTPSessionManager *)sessManager {
    
    if (!_sessManager) {
        _sessManager = [AFHTTPSessionManager manager];
        
        self.sessManager.requestSerializer.timeoutInterval = kTimeOutInterval;// 设置超时时间
        self.sessManager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 设置上传格式
        self.sessManager.requestSerializer = [AFJSONRequestSerializer serializer]; // JSON格式
        
//        application/json
        
        self.sessManager.responseSerializer = [AFJSONResponseSerializer serializer]; //声明返回数据
        self.sessManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/json",@"application/json",@"text/javascript", nil];
        
    }
    return _sessManager;
}

#pragma mark ----   配置基础的URL ---------
- (NSString *)getBaseUrlWithUrlString:(NSString *)apiString
{
    //配置Url
    NSString * baseUrl = [NSString stringWithFormat:@"http://%@/",[self.cfg host]];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",baseUrl,apiString];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return  url;
}

-(MYBaseConfigUtils *)cfg
{
    if (!_cfg) {
        _cfg = [MYBaseConfigUtils sharedInstance];
    }
    return _cfg;

}
#pragma mark ----- 统一方法  -------
-(void)requestWithAPI:(NSString *)api dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure
{
    
//    if ([HTTPREQUESTTYPE isEqualToString:@"GET"]) {
//        
//        [self getWithAPI:api dictionary:params success:success failure:failure];
//        
//    }else if([HTTPREQUESTTYPE isEqualToString:@"POST"])
//    {
//        [self postWithAPI:api dictionary:params success:success failure:failure];
//    }else
//    {
//        [[iToast makeText:@"网络请求配置错误 ！"] show];
//    }

}

#pragma mark ----- POST方法 --------
- (void)thirdPostWithAPI:(NSString *)api dictionary:(NSMutableDictionary *)params success:(success)success failure:(failure)failure
{
    
    [self.sessManager POST:[self getBaseUrlWithUrlString:api] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        NSLog(@"当前post请求进度为:%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //取消加载转动
        [SVProgressHUD dismiss];
        
        // 请求成功
        if(responseObject){
            if (success) {
                success(responseObject);
            }
            
        } else {
            
            [[iToast makeText:@"暂无数据！"] show];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(task,error);
//            NSLog(@"post,error--%@",[error debugDescription]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
                [[iToast makeText:@"当前网络不稳定！"] show];
                
            });
        }
        //取消请求
        [task cancel];
    }];

}
-(void)postWithAPI:(NSString *)api dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure{
//    if ([self checkAFNetworkStatus]) {
    
        [self.sessManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.sessManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [self.sessManager POST:[self getBaseUrlWithUrlString:api] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
//            NSLog(@"当前post请求进度为:%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //取消加载转动
            [SVProgressHUD dismiss];
            
            // 请求成功
            if(responseObject){
                
                if (success) {
                    
                    success(responseObject);
                }
                
            } else {
                
                [[iToast makeText:@"暂无数据！"] show];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                
                failure(task,error);
                NSLog(@"post,error--%@",[error debugDescription]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    
                    [[iToast makeText:@"当前网络不稳定！"] show];
                    
                });
            }
            
            //取消请求
            [task cancel];
        }];
        
        
//    }else{
//    
//            [[iToast makeText:@"当前网络不稳定！"] show];
//    
//    }
    
}

#pragma mark ------------ get请求  ----------
-(void)getWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure{
    
//    NSString * url = [self getBaseUrlWithUrlString:api];
    
//    if ([self checkAFNetworkStatus]) {
    
        [self.sessManager GET:api parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
            NSLog(@"当前get请求进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            // 请求成功
            if(responseObject){
                
                if (success) {
                    
                    success(responseObject);
                }
                
            } else {
                
                [[iToast makeText:@"暂无数据！"] show];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failure) {
                
                failure(task,error);
                NSLog(@"post,error--%@",[error debugDescription]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[iToast makeText:@"当前网络不稳定！"] show];
                    
                });
                
            }
            //取消请求
            [task cancel];
            
        }];
//    }else
//    {
//         [[iToast makeText:@"当前网络不稳定！"] show];
//    
//    }
}
-(void)getMailCodeWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure{
    
    NSString * url = [self getBaseUrlWithUrlString:api];
    [self.sessManager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"当前get请求进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //取消加载转动
        [SVProgressHUD dismiss];
        
        // 请求成功
        if(responseObject){
            
            if (success) {
                
                success(responseObject);
            }
            
        } else {
            
            [[iToast makeText:@"暂无数据！"] show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //取消请求
        [task cancel];
        
    }];
}
-(void)collectActionWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure
{
    NSString * url = [self getBaseUrlWithUrlString:api];
    [self.sessManager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"当前get请求进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //取消加载转动
        [SVProgressHUD dismiss];
        
        // 请求成功
        if(responseObject){
            
            if (success) {
                
                success(responseObject);
            }
            
        } else {
            
            [[iToast makeText:@"暂无数据！"] show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //取消请求
        if (failure) {
            
            failure(task,error);
            NSLog(@"post,error--%@",[error debugDescription]);
            
        }
        [task cancel];
        
    }];

}
#pragma mark ------------ getTest请求  ----------
-(void)getTestWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params success:(success)success  failure:(failure)failure{
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer new];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSString * url = [self getBaseUrlWithUrlString:api];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"当前get请求进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //取消加载转动
        [SVProgressHUD dismiss];
        
        // 请求成功
        if(responseObject){
            
            if (success) {
                
                success(responseObject);
            }
            
        } else {
            
            [[iToast makeText:@"暂无数据！"] show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(task,error);
            NSLog(@"post,error--%@",[error debugDescription]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
                [[iToast makeText:@"当前网络不稳定！"] show];
                
            });
            
        }
        //取消请求
        [task cancel];
        
    }];
}
#pragma mark -------- 下载 ------------
- (void)downLoadWithUrlString:(NSString *)urlString andFileName:(NSString *)fileName
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [self.sessManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 下载地址
        NSLog(@"默认下载地址%@",targetPath);
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        
        return [NSURL fileURLWithPath:filePath]; // 返回NSURL对象放在沙盒的地址
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        // 下载完成
        if (response) {
            
            NSLog(@"%@---%@", response, filePath);
            
        }
        //下载失败
        if (error) {
            
            NSLog(@"post,error--%@",[error debugDescription]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
                [[iToast makeText:@"当前网络不稳定！"] show];
                
            });
            
        }
        //取消请求
        [task cancel];
        
    }];
    // 5.启动下载任务
    [task resume];
}
#pragma mark --------  上传   ------------
- (void)uploadWithAPI:(NSString *)api  dictionary:(NSMutableDictionary *)params upImg:(UIImage *)upImg withImageName:(NSString *)imageName andTheFileName:(NSString *)fileName imageType:(NSString *)imageType success:(success)success  failure:(failure)failure
{
    if ([MYUtils isEmpty:imageType]) {
        imageType = @"image/png";
    }
    [self.sessManager POST:[self getBaseUrlWithUrlString:api] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        NSData *data = UIImagePNGRepresentation(upImg);
        
        [formData appendPartWithFileData:data name:imageName fileName:fileName mimeType:imageType];
        
        /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:imageName fileName:fileName mimeType:@"application/octet-stream" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        if (responseObject) {
            
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            
            if (success) {
                
                success(json);
            }
            
            
        }else
        {
            [[iToast makeText:@"无相关上传数据"] show];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        if (failure) {
            
            failure(task,error);
            NSLog(@"post,error--%@",[error debugDescription]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
//                [[iToast makeText:@"当前网络不稳定！"] show];
                
            });
            
        }
        
        //取消请求
        [task cancel];
    }];
}

#pragma mark --------  获取网络状态 ----------

- (void)startCheckNetStatus
{
    
    [self checkAFNetworkStatus];
}


- (BOOL)checkAFNetworkStatus{
    
     self.netStaus = -2;//默认
    //1.创建网络监测者
    if (!_netStatusManager) {
        
        _netStatusManager = [AFNetworkReachabilityManager sharedManager];
    }
    
    /*
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     */
//    
//    [_netStatusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//        
//        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
//            
//            self.netStaus =  YES;
//            
//        }else{
//            
//            self.netStaus =  NO;
//        }
//        [manager.netStatusManager stopMonitoring];
//        
//        
//    }] ;
    if (_netStatusManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN || _netStatusManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        
        MYLog(@"%ld",(long)_netStatusManager.networkReachabilityStatus);
        
        return  YES;
        
    }else{
        
        return  NO;
    }
    
    
}
#pragma mark --------  加密方法 -----------
-(NSString*)generateToken:(NSDictionary*)params
{
    MYBaseConfigUtils * cfg = [MYBaseConfigUtils sharedInstance];
    
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:params.allValues];
    
    [array addObject:[cfg secretKey]];
    
    NSArray *temp = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2];
        
    }];
    
    NSString *str = [temp componentsJoinedByString:@", "];
    
    NSString *json = [NSString stringWithFormat:@"[%@]",str];
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
- (void)dealloc {
    
    [self.sessManager invalidateSessionCancelingTasks:YES];
}

@end
