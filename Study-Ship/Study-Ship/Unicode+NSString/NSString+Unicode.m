//
//  NSString+Unicode.m
//  url
//
//  Created by ReoWei on 16/3/22.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "NSString+Unicode.h"

@implementation NSString (Unicode)
+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization
                           propertyListWithData:tempData
                           options:NSPropertyListImmutable
                           format:NULL
                           error:NULL
                           ];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
@end
