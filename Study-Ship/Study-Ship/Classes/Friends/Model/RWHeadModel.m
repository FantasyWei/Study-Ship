//
//  RWHeadModel.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWHeadModel.h"
#import "RWListModel.h"

@implementation RWHeadModel
+(instancetype)headModelWithDictionay:(NSDictionary *)dict{
     return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        NSMutableArray *tempArray=[NSMutableArray array];
        for (NSDictionary *dict in self.skills) {
            RWListModel *model = [RWListModel listModelWithDictionay:dict];
            [tempArray addObject:model];
        }
        _skills = tempArray;
  
    }
    return self;
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
