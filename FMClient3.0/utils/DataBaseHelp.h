//
//  DataBaseHelp.h
//  FMClient3.0
//
//  Created by YT on 2017/3/15.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseHelp : NSObject

+ (instancetype)sharedInstance;

-(BOOL)addValue:(NSString *)value forKeyPath:(NSString *)keyPath;


@end
