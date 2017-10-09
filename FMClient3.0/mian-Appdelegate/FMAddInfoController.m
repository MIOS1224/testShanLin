//
//  FMAddInfoController.m
//  FMClient3.0
//
//  Created by YT on 2016/10/20.
//  Copyright © 2016年 YT.com. All rights reserved.
//
#define SCREEN_FRAME ([UIScreen mainScreen].bounds)

#import "FMAddInfoController.h"
#import "UIColor+MYColorString.h"
#import "MYUtils.h"
#import "HomeViewController.h"
#import "FMTabbarViewController.h"
#import "FMProgressHUD.h"

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
#import "FMURLSessionProtocol.h"

#import <AVFoundation/AVFoundation.h>

#import "FMHomeViewController.h"

#define PASSVALUEKEY @"come^on&www.fmars.cn"

@interface FMAddInfoController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)NSArray * addImages;


@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,assign)NSInteger indexCount;

@property(nonatomic,strong)UIButton *cancleBtn;

@property(nonatomic,assign)NSInteger  turnIndex;
@property(nonatomic,strong)FMHomeViewController * homeController;
@property(nonatomic,strong)FMTabbarViewController * tabController;


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

@implementation FMAddInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.addImages  = @[@"addimage1.jpg",@"addimage2.jpg",@"addimage3.jpg",@"addimage4.jpg"];
    self.indexCount = 5;
    self.turnIndex  = 0;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * isShow = [[NSUserDefaults standardUserDefaults] objectForKey:kShowWelcome];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString * verision = [[NSUserDefaults standardUserDefaults]valueForKey:@"BundleShortVersion"];
   
    
    if([MYUtils isEmpty:isShow]|| ![verision isEqualToString:currentVersion])
    {
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"BundleShortVersion"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self addSubView];
        [self createImageView];
    }
    
     [self addSubWebView];
    
//    AVPlayer * player = [[AVPlayer alloc]init];
//    
//    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:[NSURL URLWithString:@""] options:nil];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:urlAsset];
//    [player replaceCurrentItemWithPlayerItem:item];
////    [self addObserverToPlayerItem:item];
//    
//    
//    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *myPathDocument = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[_source.videoUrl MD5]]];
//    
//    
//    NSURL *fileUrl = [NSURL fileURLWithPath:myPathDocument];
//    
//    if (asset != nil) {
//        AVMutableComposition *mixComposition = [[AVMutableComposition alloc]init];
//        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0] atTime:kCMTimeZero error:nil];
//        
//        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0] atTime:kCMTimeZero error:nil];
//        
//        AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
//        exporter.outputURL = fileUrl;
//        if (exporter.supportedFileTypes) {
//            exporter.outputFileType = [exporter.supportedFileTypes objectAtIndex:0] ;
//            exporter.shouldOptimizeForNetworkUse = YES;
//            [exporter exportAsynchronouslyWithCompletionHandler:^{
//                
//            }];
//            
//        }
//    }
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)addSubWebView
{
    if (self.webView == nil) {
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:self.webView];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@/%@",LOADZIPURL,@"act/index.html"];
        
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
        self.webView.delegate  = self;
        [self.webView loadRequest:request];
    }
    
    
    if (self.label == nil) {
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
        self.label.text =  [NSString stringWithFormat:@"%ld",self.indexCount];
        self.label.font = [UIFont boldSystemFontOfSize:13];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.layer.cornerRadius = 10;
        self.label.layer.borderColor  = [UIColor whiteColor].CGColor;
        self.label.layer.borderWidth  = 1;
        [self.view addSubview:self.label];
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLabelValue) userInfo:nil repeats:YES];
    
    if (self.cancleBtn == nil) {
        
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 20, 60, 35);
        [self.cancleBtn setTitle:@"点此跳过" forState:(UIControlStateNormal)];
        self.cancleBtn.titleLabel.textColor = [UIColor whiteColor];
        self.cancleBtn.titleLabel.font  = [UIFont boldSystemFontOfSize:14];
        [self.view addSubview:self.cancleBtn];
        
        [self.cancleBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
}
-(void)changeLabelValue
{
    self.indexCount --;
    self.label.text = [NSString stringWithFormat:@"%ld",self.indexCount];
    if (self.indexCount == 0) {
        
        [self removeWebViewAndLabel];
        
    }
}
-(void)cancleBtnAction
{
    [self removeWebViewAndLabel];
    
}
-(void)removeWebViewAndLabel
{
    [self.webView removeFromSuperview];
    [self.label removeFromSuperview];
    
    self.label   = nil;
    self.webView = nil;
    
    NSString * isShow = [[NSUserDefaults standardUserDefaults] objectForKey:kShowWelcome];
    if([MYUtils isNotEmpty:isShow])
    {
        self.turnIndex ++;
        [self goMainCtrl];
    }
}
- (void)addSubView
{
    if (self.scrollView == nil) {
        
        self.scrollView=[[UIScrollView alloc]initWithFrame:SCREEN_FRAME];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled=YES;
        [self.view addSubview:self.scrollView];
        
        self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 10)];
        self.pageControl.currentPageIndicatorTintColor=[UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self.view addSubview:self.pageControl];
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.addImages.count, 0);
        
        self.pageControl.numberOfPages= self.addImages.count;
    }
    
    
}
-(void)createImageView{
    
    for (NSInteger i=0 ; i<self.addImages.count;i++) {
        
        NSString * imgStr = self.addImages[i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_FRAME.size.width * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [imageView setUserInteractionEnabled:true];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:imgStr];
        
        [self.scrollView addSubview:imageView];
        
        if (i == self.addImages.count - 1) {
            UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((SCREEN_WIDTH - 100)/2,SCREEN_HEIGHT - 50, 100, 35);
            [button setTitle:@"立即体验" forState:(UIControlStateNormal)];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithDtString:MYNAVIGATIONCOLORDATA] forState:(UIControlStateNormal)];
            
            button.layer.borderColor  = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA].CGColor;
            button.layer.borderWidth  = 1.0f;
            button.layer.cornerRadius = 5;
            
            [button addTarget:self action:@selector(beginClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetWidth = self.scrollView.contentOffset.x;
    int pageNum = offsetWidth / SCREEN_WIDTH;
    self.pageControl.currentPage = pageNum;
}

#pragma mark - 点击事件

- (void)beginClick
{
    
//    [SVProgressHUD showWithStatus:@"正在准备初始运行，请稍后......."];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [[FMProgressHUD sharedManager]showProgress:self.view WithTextValue:@"正在准备初始运行，请稍后......."];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.scrollView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@"isShow" forKey:kShowWelcome];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.turnIndex ++;
        [self goMainCtrl];
    
    }];
}
-(void)goMainCtrl
{
        if (!self.tabController) {
//            self.tabController  = [[FMTabbarViewController alloc] init];
            self.homeController = [[FMHomeViewController alloc] init];
        }
    if (self.turnIndex == 1) {
        
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        window.rootViewController = self.homeController;
//        window.rootViewController = self.homeController;
    }
    
}
#pragma mark ----- UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self FirstLoadMethod];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self goMainCtrl];
}

#pragma mark -------------- 下载压缩文件  ----------
- (void)FirstLoadMethod
{

    NSInteger veridValue = 33;
    self.resultPath  = [BASICPATH stringByAppendingPathComponent:@"result"];
    NSString * verID = [[NSUserDefaults standardUserDefaults]objectForKey:UD_CURRENT_ID];
    NSString * verValue = [[NSUserDefaults standardUserDefaults]objectForKey:UD_CURRENT_VER];
    
    if ([MYUtils isEmpty:verID] || [MYUtils isEmpty:verValue]  || [verID integerValue] < veridValue) {
        self.isFirstLoad = YES;
        self.zipModel = [[ZipMode alloc]init];
        self.zipModel.verID  = [NSString stringWithFormat:@"%ld",veridValue];
        self.zipModel.ver    = @"ver8.0.72.20170228174052";
        self.zipModel.type   = @"all";
        self.zipModel.keystr = @"cfe08203bf90b50fbff42184a38d9156";
        
        self.zipPath     = [[NSBundle mainBundle] pathForResource:@"fmars" ofType:@".zip"];
        NSString * scrcrValue = [self getSecuretyValueWithkeyStr:self.zipModel.keystr];
        [self releaseZipFilesWithPassValue:scrcrValue];

    }else{
        
        
        self.isFirstLoad = NO;
        self.webIndex    = 0;
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        [param setObject:verID forKey:@"id"];
        [param setObject:verValue forKey:@"ver"];
        [self loadZipFilesWith:param];
    }
    
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
            [[FMProgressHUD sharedManager]showProgress:self.view WithTextValue:@"正在载入资源，请稍后......."];
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
//                        NSLog(@"fileMd5======%@",fileMd5);
                        
                        if ([fileMd5 isEqualToString:wself.zipModel.md5]) {
#pragma mark --------  第二步校验 ------------  //解压zip文件
                            
                            NSString * scrcrValue = [wself getSecuretyValueWithkeyStr:[dict objectForKey:@"keystr"]];
                            [wself releaseZipFilesWithPassValue:scrcrValue];
                            
                        }else{
                            
                            [self goMainCtrl];
                        }
                    }
                });
            }
        }else{
            
            [self goMainCtrl];
        }
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
        [self goMainCtrl];
        
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
        
        
        [self goMainCtrl];
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
        
        [iToast makeText:@"第三步验证错误"];
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
        
//        NSLog(@"%@",[moveRrror localizedDescription]);
    }
}
#pragma mark  ------------- 处理增量文件 --------
-(void)handleIncTypefiles
{
    
    
    NSString * incPath = [NSString stringWithFormat:@"%@/%@",self.resTempPath,@"source"];
    NSMutableArray * detailPaths = [[NSMutableArray alloc]init];
    
    //获取增量路径
    NSDirectoryEnumerator *myDirectoryEnumerator;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    myDirectoryEnumerator = [fileManager enumeratorAtPath:incPath];
    
    while((incPath = [myDirectoryEnumerator nextObject])!=nil)
    {
        if ([incPath rangeOfString:@"."].location != NSNotFound && ![incPath isEqualToString:@"list.xml"]) {
            
            [detailPaths addObject:incPath];
        }
    }
    self.fileNames = detailPaths;
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:UD_LISTXML_ARRAY]];
    
    //逐层替换文件
    for (NSString * pathVlaue in detailPaths) {
        NSString * changPath    = [NSString stringWithFormat:@"%@/%@/%@",self.resultPath,@"source",pathVlaue];
        NSString * preChangPath = [NSString stringWithFormat:@"%@/%@/%@",self.resTempPath,@"source",pathVlaue];
        
        if (![fileManager fileExistsAtPath:changPath] )
        {
            //NSLog(@"createFileAtPath===%@",changPath);
            [fileManager createFileAtPath:changPath contents:nil attributes:nil];
            [fileManager createDirectoryAtPath:changPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [fileManager removeItemAtPath:changPath error:nil];
        NSError * changError = nil;
        
        [fileManager copyItemAtPath:preChangPath toPath:changPath error:&changError];
        
        if (changError) {
            
//            NSLog(@"changError==%@",changError);
            break;
            
        }else{
            
            if (![tempArray containsObject:pathVlaue]) {
                
                [tempArray addObject:pathVlaue];
            }
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
        
        [self FirstLoadMethod];
        
    }else if(self.webIndex == self.zipArray.count)
    {
        [self goMainCtrl];
        
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
