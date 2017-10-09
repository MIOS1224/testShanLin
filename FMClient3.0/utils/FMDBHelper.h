//
//  FMDBHelper.h
//  FMClient3.0
//
//  Created by YT on 2017/3/8.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBHelper : NSObject

+ (instancetype)sharedInstance;

-(NSString *)checkValueforKeyPath:(NSString *)keyPath;

-(BOOL)addValue:(NSString *)value forKeyPath:(NSString *)keyPath;
-(BOOL)updateValue:(NSString *)value forKeyPath:(NSString *)keyPath;
-(BOOL)addtargetDict:(NSDictionary *)dict;

-(BOOL)deleValueforKeyPath:(NSString *)keyPath;
-(BOOL)deleAllValuePath;

-(void)closeDatabase;
-(void)openDataBase;

@end
