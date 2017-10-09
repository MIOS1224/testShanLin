//
//  Tools.h
//  爱限免
//
//  Created by huangdl on 14-12-31.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tools : NSObject

+(CGSize)sizeOfStr:(NSString *)str withFont:(UIFont *)font withMaxWidth:(CGFloat)width withLineBreakMode:(NSLineBreakMode)mode;

+(NSAttributedString *)addStrikethroughLineWith:(NSString *)targetString;

+(CGSize)sizeOfStr:(NSString *)str withFont:(UIFont *)font withMaxHeight:(CGFloat)height withLineBreakMode:(NSLineBreakMode)mode;


@end
