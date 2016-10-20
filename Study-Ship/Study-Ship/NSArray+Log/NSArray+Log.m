//
//  NSArray+Log.m
//  05-打印输出
//
//  Created by 李凯宁 on 15/5/28.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

// 本地化打印,方便调试.重写这个方法之后,直接添加这个分类到项目中就可以,不需要导入.程序中所有的NSLog数组方法都会被替代.
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithFormat:@"( \n"];
    // 遍历数组,拼接字符串.
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendString:[NSString stringWithFormat:@"\t%@,\n",obj]];
    }];
    
    [strM appendString:@")\n"];
    
    return [strM copy];
}

@end


@implementation NSDictionary (Log)

// 本地化方法.重写这个方法之后,直接将分类加入项目中就可以,不需要单个导入.程序中所有的NSLog数组方法都会被替代.
-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithFormat:@"(\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //
        NSString *str = [NSString stringWithFormat:@"\t%@=%@,\n",key,obj];
        
        [strM appendString:str];
    
    }];
    
    [strM appendString:@")\n"];
    
    return [strM copy];
}

@end
