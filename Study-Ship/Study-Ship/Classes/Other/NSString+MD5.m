//
//  NSString+MD5.m
//  d
//
//  Created by Dong on 15/5/27.
//  Copyright (c) 2015年 xindong. All rights reserved.
//

#import "NSString+MD5.h"
@implementation NSString (MD5)
-(NSString *)MD5
{
    // create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, (unsigned)strlen(ptr), md5Buffer);
    
    // convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }
    return output;
    
}
@end
