//
//  MYUtils.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/3.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MYUtils.h"
#import <UIKit/UIKit.h>

@implementation MYUtils
+ (BOOL) isEmpty:(NSString*)str
{
    if (str == nil) {
        return TRUE;
    }
    
    if ([str isEqual:[NSNull null]]) {
        return TRUE;
    }
    
    if ([str isKindOfClass:[NSString class]]) {
        
        if (str.length == 0) {
            return TRUE;
        }
        
        NSString *str1 = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([str1 isEqual:@""]) {
            return TRUE;
        }
    }
    return FALSE;
}

+ (BOOL)isNotEmpty:(NSString *)str
{
    return ![MYUtils isEmpty:str];
}
+ (void)userDefaultsValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+ (id)userDefaultsForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

@end
