//
//  RWListModel.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWListModel.h"

@implementation RWListModel
+(instancetype)listModelWithDictionay:(NSDictionary *)dict{
    RWListModel *model = [[RWListModel alloc]init];
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
