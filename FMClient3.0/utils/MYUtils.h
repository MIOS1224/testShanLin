//
//  MYUtils.h
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/3.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYUtils : NSObject

+ (BOOL) isEmpty:(NSString*)str;

+ (BOOL) isNotEmpty:(NSString*)str;

+ (void)userDefaultsValue:(id)value forKey:(NSString *)key;

+ (id)userDefaultsForKey:(NSString *)key;

@end
