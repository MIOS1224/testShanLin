//
//  UpdateManager.m
//  FMClient3.0
//
//  Created by YT on 2017/2/28.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "UpdateManager.h"
#import "HTTPManager.h"
#import "ZipMode.h"
#import "FMProgressHUD.h"
#import <YYJSONHelper.h>
#import "MySecurities.h"
#import <GDataXMLNode.h>
#import "MD5FileData.h"
#import <XMLDictionary.h>
#import "FMProgressHUD.h"
#import "iToast.h"

#define PASSVALUEKEY @"come^on&www.fmars.cn"

@interface UpdateManager()

@property (nonatomic,strong)ZipMode   * zipModel;
@property (nonatomic,strong)NSString  * zipPath;
@property (nonatomic,strong)NSString  * resultPath;
@property (nonatomic,strong)NSString  * resTempPath;

@property (nonatomic,strong)NSArray   * zipArray;
@property (nonatomic,strong)NSArray   * fileNames;
@property(nonatomic,strong)NSString   * typeValue;
@property(nonatomic,strong)NSString   * verValue;
@property (nonatomic,assign)NSInteger  webIndex;


@property (nonatomic,assign)BOOL  isFirstLoad;

@end
@implementation UpdateManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
    });
    return _sharedObject;
}
-(void)startUpdate
{
    
}
-(void)loadZipFilesWith:(NSMutableDictionary *)param
{
    __weak __typeof(self)wself = self;
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@",LOADZIPURL,@"api.php/getUpdateVer"];
    [[HTTPManager sharedInstance]getWithAPI:urlStr dictionary:param success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray * responArr = (NSArray *)responseObject;
        NSInteger num = [[responArr firstObject] integerValue];
        self.zipArray = (NSArray *)[responArr lastObject];
        
        if (num == 0 && self.zipArray.count != 0) {
//            [[FMProgressHUD sharedManager]showProgress:self.view WithTextValue:@"正在更新，请稍后......."];
            //解压数组中的文件
            for (NSDictionary * dict in self.zipArray) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    wself.zipModel = [[dict YYJSONString]toModel:[ZipMode class]];
                    wself.zipModel.verID = [dict objectForKey:@"id"];
                    
                    wself.zipPath     = [BASICPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",wself.zipModel.ver]];
                    NSString * zipUrl = [NSString stringWithFormat:@"%@/%@",LOADZIPURL,[dict objectForKey:@"filename"]];
                    
                    NSURL*url   = [NSURL URLWithString:zipUrl];
                    
                    NSError * error   = nil;
                    NSData*data = [NSData dataWithContentsOfURL:url options:0 error:&error];
                    
                    if(!error){
                        [data writeToFile:wself.zipPath options:0 error:nil];
                        
#pragma mark --------  第一步校验 ------------ //文件MD5校验
                        NSString * fileMd5 =  [MD5FileData getFileMD5WithPath:wself.zipPath];
                        NSLog(@"fileMd5======%@",fileMd5);
                        
                        if ([fileMd5 isEqualToString:wself.zipModel.md5]) {
#pragma mark --------  第二步校验 ------------  //解压zip文件
                            
                            NSString * scrcrValue = [wself getSecuretyValueWithkeyStr:[dict objectForKey:@"keystr"]];
                            [wself releaseZipFilesWithPassValue:scrcrValue];
                            
                        }else{
//                            [self uploadWebView];
                        }
                    }
                });
            }
        }else{
            
//            [self uploadWebView];
        }
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
//        [self uploadWebView];
        
    }];
}
#pragma mark --------  解压zip文件   --------------
- (void)releaseZipFilesWithPassValue:(NSString *)passValue
{
    self.resTempPath = [self getResultTempPath];
    
    if (!self.resTempPath) {
        return;
    }
    NSError * unzipError =nil;
    BOOL success = [SSZipArchive unzipFileAtPath:self.zipPath
                                   toDestination:self.resTempPath
                                       overwrite:YES
                                        password:passValue
                                           error:&unzipError];
    if (!success) {


//        [self uploadWebView];
        return;
        
    }
    
    [self parseXMLFile];
}
#pragma mark -------- 解析LIST XML文件  ---------
-(void)parseXMLFile
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",self.resTempPath,@"source/list.xml"];
    NSData *data   = [[NSData alloc]initWithContentsOfFile:path];
    
    NSString * xmlNativeStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *xmlDictionary = [[XMLDictionaryParser sharedInstance]dictionaryWithFile:path];
    
    NSDictionary * tempXML = [xmlDictionary objectForKey:@"files"];
    self.fileNames  = [tempXML objectForKey:@"filename"];
    self.verValue   = [xmlDictionary objectForKey:@"ver"];
    self.typeValue  = [xmlDictionary objectForKey:@"type"];
    
#pragma mark --------  第三步校验 ------------
    
    NSString * baseMd5 = [MySecurities md5String:xmlNativeStr];
    NSString * nextStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",baseMd5,@",[",self.verValue,@"],[",self.typeValue,@"]"];
    NSString * resultValue =[MySecurities md5String:nextStr];
    
    if ([resultValue isEqualToString:self.zipModel.keystr] || self.isFirstLoad) {
        
        [self handleUnzipFiles];
        
    }else{
        
        [iToast makeText:@"验证错误"];
    }
    
    xmlNativeStr = @"";
    
    
}
#pragma mark  ------------- 解压文件 ------------
-(void)handleUnzipFiles
{
    
    if ([MYUtils isEmpty:self.resultPath]) {
        
        self.resultPath = [BASICPATH stringByAppendingPathComponent:@"result"];
    }
    
    if ([self.zipModel.type isEqualToString:@"all"]) {//全量更新
        
        [self handleAllTypefiles];
        
    }else if ([self.zipModel.type isEqualToString:@"inc"]){//变量更新
        
        [self handleIncTypefiles];//处理增量文件
        
    }else{
        
        return;
    }
    
}
#pragma mark  ------------- 处理全量文件 --------
-(void)handleAllTypefiles
{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:self.resultPath ]) {
        [fileManager removeItemAtPath:self.resultPath error:nil];
        
    }
    NSError * moveRrror = nil;
    BOOL isMove =  [fileManager moveItemAtPath:self.resTempPath toPath:self.resultPath error:&moveRrror];
    
    if (isMove) {
        
        [[NSUserDefaults standardUserDefaults]setObject:self.fileNames forKey:UD_LISTXML_ARRAY];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self saveVersionInfo];
        
    }else{
        
        NSLog(@"%@",[moveRrror localizedDescription]);
    }
}
#pragma mark  ------------- 处理增量文件 --------
-(void)handleIncTypefiles
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString * incPath = [NSString stringWithFormat:@"%@/%@",self.resTempPath,@"source"];
    NSMutableArray * detailPaths = [[NSMutableArray alloc]init];
    
    //获取增量路径
    NSDirectoryEnumerator *myDirectoryEnumerator;
    myDirectoryEnumerator=[fileManager enumeratorAtPath:incPath];
    
    while((incPath = [myDirectoryEnumerator nextObject])!=nil)
    {
        if ([incPath rangeOfString:@"."].location != NSNotFound && ![incPath isEqualToString:@"list.xml"]) {
            
            [detailPaths addObject:incPath];
        }
    }
    self.fileNames = detailPaths;
    
    //逐层替换文件
    for (NSString * pathVlaue in detailPaths) {
        NSString * changPath    = [NSString stringWithFormat:@"%@/%@/%@",self.resultPath,@"source",pathVlaue];
        NSString * preChangPath = [NSString stringWithFormat:@"%@/%@/%@",self.resTempPath,@"source",pathVlaue];
        
        if (![fileManager fileExistsAtPath:changPath] )
        {
            //            NSLog(@"createFileAtPath===%@",changPath);
            [fileManager createFileAtPath:changPath contents:nil attributes:nil];
            [fileManager createDirectoryAtPath:changPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [fileManager removeItemAtPath:changPath error:nil];
        NSError * changError = nil;
        
        [fileManager copyItemAtPath:preChangPath toPath:changPath error:&changError];
        
        if (changError) {
            
            NSLog(@"changError==%@",changError);
            break;
        }
    }
    
    
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:UD_LISTXML_ARRAY]];
    for (NSString * fileName in self.fileNames) {
        if (![tempArray containsObject:fileName]) {
            
            [tempArray addObject:fileName];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:tempArray forKey:UD_LISTXML_ARRAY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self saveVersionInfo];
    
}
#pragma mark  ------------- //保存当前版本号 --------
-(void)saveVersionInfo
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:self.zipModel.verID forKey:UD_CURRENT_ID];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setObject:self.zipModel.ver forKey:UD_CURRENT_VER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
#pragma mark  ------------- //删除temp文件 --------
    [fileManager removeItemAtPath:self.resTempPath error:nil];
    
    NSString * path  = [BASICPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",self.verValue]];
    
    BOOL isZip = [fileManager removeItemAtPath:path error:nil];
    
    self.webIndex ++;
    
    if (self.isFirstLoad) {
        
//        [self FirstLoadMethod];
        
    }else if(self.webIndex == self.zipArray.count)
    {
//        [self uploadWebView];
        
    }
    
}


- (NSString *)getResultTempPath {
    NSString * path = [NSString stringWithFormat:@"%@/%@",
                       BASICPATH,@"temp"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    
    if (error) {
        return nil;
    }
    return url.path;
}

-(NSString *)getSecuretyValueWithkeyStr:(NSString *)keyStr
{
    NSString * temp = [NSString stringWithFormat:@"%@%@",keyStr,PASSVALUEKEY];
    NSString * value = [MySecurities md5String:temp];
    return value;
    
}




@end
