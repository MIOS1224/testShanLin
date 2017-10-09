//
//  WeatherInfo.h
//  FMClient3.0
//
//  Created by YT on 2016/12/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject

+(NSString *)analysisWeatherInfoWith:(NSString *)indexStr;
+(NSString *)washCarDataWith:(NSInteger )indexValue;
+(NSString *)getWeatherIMmageWith:(NSInteger )imageIndex withFaValue:(NSString *)faValue;

@end
