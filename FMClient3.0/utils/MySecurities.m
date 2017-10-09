//
//  MySecurities.m
//  FMClient3.0
//
//  Created by YT on 2017/2/8.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import "MySecurities.h"
#import "CommonCrypto/CommonDigest.h"

@implementation MySecurities
+(NSString *)md5String:(NSString *)sourceString{
    if(!sourceString){
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    const char *cStr = [sourceString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


+ (NSString *)MD5ForFileWithPath:(NSString *)path
{
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if( handle== nil ) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        
        if( [fileData length] == 0 ) done = YES;
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(result, &md5);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
    
}

@end
