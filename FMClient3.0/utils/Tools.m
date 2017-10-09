//
//  Tools.m
//  爱限免
//
//  Created by huangdl on 14-12-31.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import "Tools.h"

@implementation Tools

/*
 适配:屏幕大小,系统版本(UI,方法)
 */
+(CGSize)sizeOfStr:(NSString *)str withFont:(UIFont *)font withMaxWidth:(CGFloat)width withLineBreakMode:(NSLineBreakMode)mode
{
    if (IOS7) {
        
        CGSize size = [str boundingRectWithSize:CGSizeMake(width, 0) options:3 attributes:@{NSFontAttributeName: font} context:nil].size;
        
        return size;
    }
    else
    {
        CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, 999999) lineBreakMode:mode];
        
        return size;
    }
}
+(CGSize)sizeOfStr:(NSString *)str withFont:(UIFont *)font withMaxHeight:(CGFloat)height withLineBreakMode:(NSLineBreakMode)mode{
    if (IOS7) {
        CGSize size = [str boundingRectWithSize:CGSizeMake(0, height) options:3 attributes:@{NSFontAttributeName: font} context:nil].size;
        return size;
    }else{
        CGSize size = [str sizeWithFont: font constrainedToSize:CGSizeMake(999999, height) lineBreakMode:mode];
        return size;
    }
}

@end
