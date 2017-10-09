//
//  FMDBHelper.m
//  FMClient3.0
//
//  Created by YT on 2017/3/8.
//  Copyright © 2017年 YT.com. All rights reserved.
//
#define SQLITENAME @"webCacheFile"
#import "FMDBHelper.h"
#import <sqlite3.h>
#import <FMDB.h>

@interface FMDBHelper ()

@property (nonatomic,strong)FMDatabase *dataBase;
@property(nonatomic,strong)NSString * filePath;


@end

@implementation FMDBHelper
+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject createDataBase];
        
    });
    return _sharedObject;
}
-(void)closeDatabase
{
    [self.dataBase close];
}
-(void)openDataBase
{
    [self.dataBase open];
}
-(void)createDataBase
{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    self.filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",SQLITENAME,@"sqlite" ]];
    //2.获得数据库
    self.dataBase = [FMDatabase databaseWithPath:self.filePath];
    if ([self.dataBase open])
    {
        //4.创表
        BOOL result = [self.dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_cache (user_id integer PRIMARY KEY AUTOINCREMENT, keyPath TEXT NOT NULL, value TEXT NOT NULL);"];
        if (result)
        {
            NSLog(@"创建表成功");
        }else
        {
            NSLog(@"创建表失败");
        }
        
        [self.dataBase close];
    }
}
-(BOOL)addtargetDict:(NSDictionary *)dict
{
    if ([self.dataBase open] == NO)
    {
        [self.dataBase close];
        return NO;
    }
    [self.dataBase beginTransaction];
    @try {
        BOOL finalRes = YES;
//        NSLog(@"NSDate end===%@",[NSDate date]);
        NSArray * arr = [dict allKeys];
        for (NSString * keyPathStr in arr) {
            NSString * valueStr = [dict objectForKey:keyPathStr];
            if ([self isExistSeachText:keyPathStr]) {
               BOOL res =  [self updateValue:valueStr forKeyPath:keyPathStr];
                if (!res) {
                    
                    finalRes = NO;
                }
                
            }else{
                
                BOOL res  = [self.dataBase executeUpdate:@"INSERT INTO t_cache (keyPath, value) VALUES (?,?)",keyPathStr,valueStr];
                
                if (res) {
                    //  NSLog(@"插入成功");
                    
                }else{
                    
                    finalRes = NO;
                    // NSLog(@"插入失败");
                }
                
            }
        }
//        NSLog(@"NSDate end===%@",[NSDate date]);
        return finalRes;
        
    }
    @catch (NSException *exception)
    {
        [self.dataBase rollback];
        return NO;
    }
    @finally
    {
        [self.dataBase commit];
    }
    [self.dataBase close];

}
-(BOOL)addValue:(NSString *)value forKeyPath:(NSString *)keyPath
{
    if ([self.dataBase open] == NO)
    {
        [self.dataBase close];
        return NO;
    }
    [self.dataBase beginTransaction];
    @try {
//        NSLog(@"NSDate===%@",[NSDate date]);
        
        for (int i = 0;i < 2000 ; i ++) {
            NSString * valueStr   = [NSString stringWithFormat:@"%@%d",@"value",i+1];
            NSString * keyPathStr = [NSString stringWithFormat:@"%@%d",@"keyPathStr",i+1];
            if ([self isExistSeachText:keyPathStr]) {
                
                [self updateValue:valueStr forKeyPath:keyPathStr];
                
            }else{
                
                BOOL res  = [self.dataBase executeUpdate:@"INSERT INTO t_cache (keyPath, value) VALUES (?,?)",keyPathStr,valueStr];
                
                if (res) {
//                    NSLog(@"插入成功");
                }else{
                    
                    [self updateValue:valueStr forKeyPath:keyPathStr];
//                    NSLog(@"插入失败");
                }
                
            }
        }
//        NSLog(@"NSDate end===%@",[NSDate date]);
    }
    @catch (NSException *exception)
    {
        [self.dataBase rollback];
    }
    @finally
    {
        [self.dataBase commit];
    }
    [self.dataBase close];
    
}

-(BOOL)deleValueforKeyPath:(NSString *)keyPath
{
    if ([self.dataBase open]) {
        BOOL result = [self.dataBase executeUpdate:@"delete from t_cache where keyPath = ?",keyPath];
        
        [self.dataBase close];
        return result;
        
    }else{
        
        return NO;
    }
}


-(BOOL)updateValue:(NSString *)value forKeyPath:(NSString *)keyPath
{
    BOOL result = [self.dataBase executeUpdate:@"UPDATE t_cache SET keyPath = ?,value = ? WHERE keyPath = ?",
                   keyPath,value,keyPath];
    
    
    if (result) {
        
        return YES;
    }else
    {
        
        return NO;
    }
    
}
//查询数据库中是否包含当前搜索记录
- (BOOL)isExistSeachText:(NSString *)seachText
{
    
    FMResultSet *results = [self.dataBase executeQuery:@"SELECT * FROM t_cache WHERE keyPath = ?",seachText];
    
    while (results.next) {
        
        if ([seachText isEqualToString:[results stringForColumn:@"keypath"]]) {
            return YES;
        }
    }
    return NO;
}
-(NSString *)checkValueforKeyPath:(NSString *)keyPath
{
    NSString * result = nil;
    if ([self.dataBase open]) {
        FMResultSet *set = [self.dataBase executeQuery:@"SELECT * FROM t_cache WHERE keyPath = ?",keyPath];
        while ([set next]) {
            result = [set stringForColumn:@"value"];
        }
    }
    return result;
}

//获取所有搜索记录
- (NSMutableArray *)getAllSeachText
{
    NSString *sql = @"select * from t_cache";
    //保存所有数据的数组
    NSMutableArray *seachTexts = [NSMutableArray array];
    FMResultSet *results = [self.dataBase executeQuery:sql];
    while (results.next) {
        NSString *result = [results stringForColumn:@"seachText"];
        [seachTexts addObject:result];
    }
    
    return seachTexts;
}
//删除所有搜索记录
- (BOOL)deleAllValuePath
{
    NSString *sql = @"delete from t_cache";
    BOOL isDeleteOK = [self.dataBase executeUpdate:sql];
    
    if (isDeleteOK) {
        //        NSLog(@"删除成功");
        return YES;
    }
    return NO;
}

@end
