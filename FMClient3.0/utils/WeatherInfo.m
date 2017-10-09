//
//  WeatherInfo.m
//  FMClient3.0
//
//  Created by YT on 2016/12/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "WeatherInfo.h"

@implementation WeatherInfo
#pragma mark ------ 解析天气数据 ------
+(NSString *)analysisWeatherInfoWith:(NSString *)indexStr
{
    NSDictionary * dict  = @{
                             @"00": @"晴",
                             @"01": @"多云",
                             @"02": @"阴",
                             @"03": @"阵雨",
                             @"04": @"雷阵雨",
                             @"05": @"雷阵雨伴有冰雹",
                             @"06": @"雨夹雪",
                             @"07": @"小雨",
                             @"08": @"中雨",
                             @"09": @"大雨",
                             @"10":@"暴雨",
                             @"11": @"大暴雨",
                             @"12": @"特大暴雨",
                             @"13": @"阵雪",
                             @"14": @"小雪",
                             @"15": @"中雪",
                             @"16": @"大雪",
                             @"17": @"暴雪",
                             @"18": @"雾",
                             @"19": @"冻雨",
                             @"20": @"沙尘暴",
                             @"21": @"小到中雨",
                             @"22": @"中到大雨",
                             @"23": @"大到暴雨",
                             @"24": @"暴雨到大暴雨",
                             @"25": @"大暴雨到特大暴雨",
                             @"26": @"小到中雪",
                             @"27": @"中到大雪",
                             @"28": @"大到暴雪",
                             @"29": @"浮尘",
                             @"30": @"扬沙",
                             @"31": @"强沙尘暴",
                             @"53": @"霾",
                             @"99": @"无"
                             };
    
    NSString * str = [dict objectForKey:indexStr];
    
    return  str;
}
+(NSString *)washCarDataWith:(NSInteger )indexValue
{
    NSString * zs = @"";
    
    if (indexValue <= 1) {
        zs = @"适宜洗车";
    } else if (indexValue == 2) {
        zs = @"较适宜洗车";
    } else if (indexValue == 7) {
        zs = @"较不适宜洗车";
    } else if (indexValue == 99) {
        zs = @"不清楚";
    } else {
        zs = @"不适宜洗车";
    }
    return zs;
    
}
+(NSString *)getWeatherIMmageWith:(NSInteger )imageIndex withFaValue:(NSString *)faValue
{
    
    if (imageIndex == 0) {
        if (faValue.length == 0) {
            return @"ye.png";
        }else{
            return @"qing.png";
        }
    } else if (imageIndex == 1) {
        return  @"yun.png";
    } else if (imageIndex == 2) {
        return  @"yun.png";
    } else if ((imageIndex >= 3 && imageIndex <= 12) || (imageIndex >= 21 && imageIndex <= 25)) {
        return  @"yu.png";
    } else if ((imageIndex >= 13 && imageIndex <= 17) || (imageIndex >= 26 && imageIndex <= 28)) {
        return  @"xue.png";
    } else {
        return  @"";
    }
}



@end
