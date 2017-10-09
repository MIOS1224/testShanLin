//
//  UpdateManager.h
//  FMClient3.0
//
//  Created by YT on 2017/2/28.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateManager : NSObject

+ (instancetype)sharedInstance;
-(void)startUpdate;

@end
