//
//  FMShareView.m
//  FMClient3.0
//
//  Created by YT on 2017/2/21.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "FMShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "iToast.h"

@implementation FMShareView
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self addWechatBtn];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self addWechatBtn];
    }
    return self;
}
-(void)addWechatBtn
{
    CGFloat width  = 45;
    CGFloat height = 45;
    CGFloat margin = (SCREEN_WIDTH - width * 5)/6;
    CGFloat Yvalue = 20;
    
    NSArray * titleArr = @[@"微 信",@"朋友圈",@"手机QQ",@"微 博",@"QQ空间"];
    NSArray * imageArr = @[@"chatWeb",@"chat",@"login_qq",@"login_weibo",@"qqzone"];
    
    for (NSInteger i = 0;i < imageArr.count; i++) {
        
        NSString * imageSth = imageArr[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(margin + (margin + width) * i, Yvalue, width, height);
        [btn setImage:[UIImage imageNamed:imageSth] forState:(UIControlStateNormal)];
        [self addSubview:btn];
        btn.tag = 1000 + i;
        
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, width, height);
        label.center = CGPointMake(btn.center.x, btn.center.y + height/2 + 10);
        
        label.text = titleArr[i];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
    }
    
}
-(void)shareBtnClick:(UIButton *)btn
{
    UMSocialPlatformType  type = UMSocialPlatformType_WechatSession;
    NSInteger index  = btn.tag - 1000;
    switch (index) {
        case 0:
            type = UMSocialPlatformType_WechatSession;
            
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2:
            type = UMSocialPlatformType_QQ;
            break;
        case 3:
            type = UMSocialPlatformType_Sina;
            break;
        case 4:
            type = UMSocialPlatformType_Qzone;
            break;
            break;
        default:
            break;
    }
    
    [self shareFuncetionWithType:type andImagePath:self.imagePath title:self.title descInfo:self.descInfo shareUrl:self.shareUrl];
    
}
#pragma mark --------  分享功能 ---------
-(void)shareFuncetionWithType:(UMSocialPlatformType)platformType andImagePath:(NSString * )imagePath title:(NSString *)title descInfo:(NSString *)descInfo shareUrl:(NSString *)shareUrl
{
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descInfo thumImage:imagePath];
    shareObject.descr = self.descInfo;
    
    shareObject.webpageUrl = shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            
            NSLog(@"errorshare====%@",error.localizedDescription);
            NSString * result = nil;
            switch (error.code) {
                case UMSocialPlatformErrorType_Unknow:
                    result = @"未知错误";
//                    break;
                case UMSocialPlatformErrorType_NotSupport:
                    result = @"不支持（url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持";
                    break;
                case UMSocialPlatformErrorType_AuthorizeFailed:
                    result = @"授权失败";
                    break;
                case UMSocialPlatformErrorType_ShareFailed:
                    result = @"分享失败";
                    break;
                case UMSocialPlatformErrorType_RequestForUserProfileFailed:
                    result = @"请求用户信息失败";
                    break;
                case UMSocialPlatformErrorType_ShareDataNil:
                    result = @"分享内容为空";
                    break;
                case UMSocialPlatformErrorType_ShareDataTypeIllegal:
                    result = @"分享内容不支持";
                    break;
                case UMSocialPlatformErrorType_CheckUrlSchemaFail:
                    result = @"schemaurl fail";
                    break;
                case UMSocialPlatformErrorType_NotInstall:
                    result = @"应用未安装";
                    break;
                case UMSocialPlatformErrorType_Cancel:
                    result = @"您已取消分享";
                    break;
                case UMSocialPlatformErrorType_NotNetWork:
                    result = @"网络异常";
                    break;
                case UMSocialPlatformErrorType_SourceError:
                    result = @"第三方错误";
                    break;
                case UMSocialPlatformErrorType_ProtocolNotOverride:
                    result = @"对应的  UMSocialPlatformProvider的方法没有实现";
                    break;
                default:
                    break;
            }
            [[iToast makeText:@"分享失败"] show];
            [self removeFromSuperview];
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SHARESUCESS" object:nil];
                
                
            }else{
                
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end
