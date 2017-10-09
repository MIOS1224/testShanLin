//
//  ZipMode.h
//  FMClient3.0
//
//  Created by YT on 2017/2/9.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipMode : NSObject
@property(nonatomic,strong)NSString * createTm;
@property(nonatomic,strong)NSString * filename;
@property(nonatomic,strong)NSString * keystr;
@property(nonatomic,strong)NSString * md5;
@property(nonatomic,strong)NSString * prver;

@property(nonatomic,strong)NSString * type;
@property(nonatomic,strong)NSString * ver;
@property(nonatomic,strong)NSString * verID;

//createTm = "2017-02-08 12:51:44";
//filename = "m2/updatefiles/inc_ver8.0.06@20170208125143.zip";
//id = 40;
//keystr = f0a6b78210258a6bd6253eba72864f56;
//md5 = 0be2eb0e28bca3658a7b9d49f48c599c;
//prver = "ver8.0.05.20170208125135";
//type = inc;
//ver = "ver8.0.06.20170208125143"

@end
