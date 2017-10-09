//
//  DataBaseHelp.m
//  FMClient3.0
//
//  Created by YT on 2017/3/15.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#define SQLITENAME @"webCacheFile"
#import "DataBaseHelp.h"
#import <sqlite3.h>

@interface DataBaseHelp ()
{
    sqlite3 *dataBase;
}
@property(nonatomic,strong)NSString * filePath;

@end
@implementation DataBaseHelp
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
-(void)createDataBase
{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    self.filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",SQLITENAME,@"sqlite" ]];
    
   
    int databaseResult = sqlite3_open([[self filePath] UTF8String], &dataBase);
    
    if (databaseResult == SQLITE_OK) {
        
        char *error;
        
        const char *createSQL = "CREATE TABLE IF NOT EXISTS t_webCache (id integer PRIMARY KEY AUTOINCREMENT, keyPath text NOT NULL, value text NOT NULL)";
        
        sqlite3_exec(dataBase,"PRAGMA synchronous = OFF; ",0,0,0);
        int tableResult = sqlite3_exec(dataBase, createSQL, NULL, NULL, &error);
        
        if (tableResult != SQLITE_OK) {
            
            NSLog(@"创建表失败:%s",error);
        }
    }
    
}

-(BOOL)addValue:(NSString *)value forKeyPath:(NSString *)keyPath
{
    sqlite3_exec(dataBase,"begin;",0,0,0);
    sqlite3_stmt *stmt;
    
    const char *insertSQL = "INSERT INTO t_webCache (keyPath, value) VALUES (?,?)";
    sqlite3_prepare_v2(dataBase, insertSQL, -1, &stmt, nil);
    NSLog(@"start====%@",[NSDate date]);
    for(int i=0;i<100000;++i)
    {
        
        NSString * valueStr   = [NSString stringWithFormat:@"%@%d",value,i];
        NSString * keyPathStr = [NSString stringWithFormat:@"%@%d",keyPath,i];
        
//        if ([self isExitvalueWithKey:keyPathStr]) {
//        
//            NSString * sqlTemp = [NSString stringWithFormat:@"UPDATE t_webCache SET keyPath = %@ value = %@ WHERE keyPath = %@",keyPath,value,keyPath];
//            
//            const char *updateSql = [sqlTemp UTF8String];
//            
//            int updateResult = sqlite3_prepare_v2(dataBase, updateSql, -1, &stmt, nil);
//            
//            if (updateResult != SQLITE_OK) {
//                
//                NSLog(@"修改失败,%d",updateResult);
//                
//            }else{
//                
//                sqlite3_step(stmt);
//            }
//
//        }else{
        
            
            sqlite3_reset(stmt);
            sqlite3_bind_text(stmt, 1, [keyPathStr UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(stmt, 2, [valueStr UTF8String], -1, SQLITE_STATIC);
            
            sqlite3_step(stmt);
//        }
    
    }
    
    sqlite3_finalize(stmt);
    sqlite3_exec(dataBase,"commit;",0,0,0);
    sqlite3_close(dataBase);
    
    NSLog(@"end======%@",[NSDate date]);
     if ([self isExitvalueWithKey:@"keypath0"]) {
         
     }
    
    return YES;
    
}

-(BOOL)isExitvalueWithKey:(NSString * )keyPath
{
    NSString * sqlTemp = [NSString stringWithFormat:@"SELECT * FROM t_webCache WHERE keyPath = %@",keyPath];
    const char * sql = [sqlTemp UTF8String];
    sqlite3_stmt *stmt;
    
    int searchResult = sqlite3_prepare_v2(dataBase, sql, -1, &stmt, nil);
    if (searchResult != SQLITE_OK) {
//        NSLog(@"查询失败,%d",searchResult);
        return NO;
        
    }else{
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 查询的结果可能不止一条,直到 sqlite3_step(stmt) != SQLITE_ROW,查询结束。
            int idWord = sqlite3_column_int(stmt, 0);
            char *nameWord = (char *) sqlite3_column_text(stmt, 1);
            char *sexWord = (char *)sqlite3_column_text(stmt, 2);
            NSLog(@"%d,%s,%s",idWord,nameWord,sexWord);
            
            return YES;
        }
        
        return NO;
    }
}
-(void)updateDateBaseWithValue:(NSString *)value andKeyPath:(NSString *)keyPath
{
    sqlite3_stmt *stmt;
    NSString * sqlTemp = [NSString stringWithFormat:@"UPDATE t_webCache SET keyPath = %@ value = %@ WHERE keyPath = %@",keyPath,value,keyPath];
    
    const char *updateSql = [sqlTemp UTF8String];
    
    int updateResult = sqlite3_prepare_v2(dataBase, updateSql, -1, &stmt, nil);
    
    if (updateResult != SQLITE_OK) {
        
        NSLog(@"修改失败,%d",updateResult);
        
    }else{
        
        sqlite3_step(stmt);
    }
}
-(void)insetDictionVlaue:(NSDictionary *)dict
{
    NSArray * arr = [dict allKeys];
    sqlite3_exec(dataBase,"begin;",0,0,0);
    sqlite3_stmt *stmt;
    
    const char *insertSQL = "INSERT INTO t_webCache (keyPath, value) VALUES (?,?)";
    sqlite3_prepare_v2(dataBase, insertSQL, -1, &stmt, nil);
    for (NSString * key in arr) {
        
        NSString * value = [dict objectForKey:key];
        
        if ([self isExitvalueWithKey:key]) {
            
            [self updateDateBaseWithValue:value andKeyPath:key];
            
        }else{
            
            sqlite3_reset(stmt);
            sqlite3_bind_text(stmt, 1, [key UTF8String], -1, SQLITE_STATIC);
            sqlite3_bind_text(stmt, 2, [value UTF8String], -1, SQLITE_STATIC);
            
            sqlite3_step(stmt);
        }
    }
    
    sqlite3_finalize(stmt);
    sqlite3_exec(dataBase,"commit;",0,0,0);
    sqlite3_close(dataBase);
    
    NSLog(@"end======%@",[NSDate date]);
}
@end
