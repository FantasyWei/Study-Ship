//
//  RWTableModel.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWTableModel.h"

@implementation RWTableModel
+(instancetype)vidoesModelWithDictionay:(NSDictionary *)dict{
    RWTableModel *model = [[RWTableModel alloc]init];
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
