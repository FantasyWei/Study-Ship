//
//  RWNewsData.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/6.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWNewsData.h"

@implementation RWNewsData
+(instancetype)newsDataModelWithDictionay:(NSDictionary *)dict{
    RWNewsData *model = [[RWNewsData alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        key = @"ids";
    }
    [super setValue:value forKey:key];
}
@end
