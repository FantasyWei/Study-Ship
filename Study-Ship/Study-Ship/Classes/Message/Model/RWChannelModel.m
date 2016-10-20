//
//  RWChannelModel.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/1.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWChannelModel.h"

@implementation RWChannelModel
+(instancetype)channelModelWithDict:(NSDictionary*)dict{
    RWChannelModel *model = [[RWChannelModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
