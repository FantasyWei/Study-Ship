//
//  RWChannelModel.h
//  Study-Ship
//
//  Created by ReoWei on 16/4/1.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWChannelModel : NSObject
@property(nonatomic,copy) NSString *type_id;
@property(nonatomic,copy) NSString *type_name;
+(instancetype)channelModelWithDict:(NSDictionary*)dict;
@end
