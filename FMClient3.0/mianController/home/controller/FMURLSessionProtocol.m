//
//  FMURLSessionProtocol.m
//  FMClient3.0
//
//  Created by YT on 2017/2/28.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "FMURLSessionProtocol.h"
#import "FMDBHelper.h"
#import <OHHTTPStubs.h>
#import "OHPathHelpers.h"

static NSString * const JWURLProtocolHandledKey = @"JWURLProtocolHandledKey";

@interface FMURLSessionProtocol()<NSURLSessionDataDelegate>

@property (atomic, strong, readwrite) NSURLSessionDataTask *task;
@property (nonatomic, strong        ) NSURLSession         *session;

@end
@implementation FMURLSessionProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //        NSLog(@"====>%@",request.URL);
        
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:JWURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    /** 可以在此处添加头等信息  */
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
   
    return mutableReqeust;
}


- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:JWURLProtocolHandledKey inRequest:mutableReqeust];
    NSArray * xmlArr  = [[NSUserDefaults standardUserDefaults]objectForKey:UD_LISTXML_ARRAY];
    
    //缓存操作
    [self setCacheMethod];
    
    
    //加载本地图片
    NSString * resTemp   = [NSString stringWithFormat:@"%@",mutableReqeust.URL];
    NSString * imagePath = [[resTemp componentsSeparatedByString:SUFFIXSTR] lastObject];
    imagePath = [[imagePath componentsSeparatedByString:@"?"] firstObject];

//    NSLog(@"resTemp==%@",resTemp);
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF == %@", imagePath];
    NSArray *results1 = [xmlArr filteredArrayUsingPredicate:predicate1];
    
    if (results1.count) {
        
        NSString * path = [NSString stringWithFormat:@"%@/result/source/%@",BASICPATH,[results1 firstObject]];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[mutableReqeust URL]
                                                            MIMEType:@"text"
                                               expectedContentLength:-1
                                                    textEncodingName:nil];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
        [[self client] URLProtocol:self didLoadData:data];
        [[self client] URLProtocolDidFinishLoading:self];
        
    }else{
        
        NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        self.session  = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:queue];
        self.task = [self.session dataTaskWithRequest:mutableReqeust];
        [self.task resume];
    }
}



- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    }else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    completionHandler(proposedResponse);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest *    redirectRequest;
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:JWURLProtocolHandledKey inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if (self) {
        
        // Some stuff
    }
    return self;
}
-(void)setCacheMethod
{
    
    
    NSString * setCache = [NSString stringWithFormat:@"%@/%@",LOADZIPURL,@"m3/iosSetCache"];
    NSString * getCache = [NSString stringWithFormat:@"%@/%@",LOADZIPURL,@"m3/iosGetCache"];
    NSString * delCache = [NSString stringWithFormat:@"%@/%@",LOADZIPURL,@"m3/iosDelCache"];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        
        NSString * url = request.URL.absoluteString;
        if ([url isEqualToString:setCache]){

            return YES;
        }else if ([url isEqualToString:getCache])
        {
            return YES;
            
        }else if ([url isEqualToString:delCache])
        {
            
            return YES;
        }
        else
        {
            return NO;
        }
        
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString * urlStr   = request.URL.absoluteString;
        NSString * dataTemp = [[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        NSString * returnValue = @"";
        
        if ([urlStr isEqualToString:setCache]){
            
            NSString * dataStr = [[dataTemp componentsSeparatedByString:@"value="] lastObject];
            
            
            NSDictionary * dict  =  [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            BOOL res = NO;
            
            if (dict) {
                
                res = [[FMDBHelper sharedInstance]addtargetDict:dict];
            }
            
            returnValue = res ? @"YES" : @"";
            
        }else if ([urlStr isEqualToString:getCache])
        {
            NSString * dataStr  = [[dataTemp componentsSeparatedByString:@"key="] lastObject];
            returnValue  =  [[FMDBHelper sharedInstance]checkValueforKeyPath:dataStr];
            
            
        }else if ([urlStr isEqualToString:delCache])
        {
            NSString * keyPath = [[dataTemp componentsSeparatedByString:@"key="] lastObject];
            BOOL res = NO;
            
            if ([MYUtils isNotEmpty:keyPath]) {
                
               res = [[FMDBHelper sharedInstance]deleValueforKeyPath:keyPath];
                
            }else
            {
                [[FMDBHelper sharedInstance]deleAllValuePath];
            }
            
            returnValue = res ? @"YES" : @"";
        }

        if ([MYUtils isEmpty:returnValue]) {
            returnValue = @"false";
            
        }else if ([returnValue isEqualToString:@"YES"])
        {
            returnValue = @"SUCCESS";
        }
        
        NSArray * arr = @[@0,returnValue];
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
        
        
        return [OHHTTPStubsResponse responseWithData:jsonData statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        
    }];

}


@end
