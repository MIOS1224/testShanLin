//
//  FMTabbarAppear.h
//  FMClient3.0
//
//  Created by YT on 2017/3/28.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTabbarAppear : NSObject

+(instancetype)sharedManager;
-(BOOL)checkTabbarWithUrl:(NSString *)urlStr;

@end
