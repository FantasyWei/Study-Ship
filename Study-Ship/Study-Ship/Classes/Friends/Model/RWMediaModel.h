//
//  RWMediaModel.h
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWMediaModel : NSObject
@property(nonatomic,assign) NSInteger ids;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *media_url;
@property(nonatomic,assign) NSInteger duration;
@property(nonatomic,assign) NSInteger media_size;


+(instancetype)mediaModelWithDictionay:(NSDictionary *)dict;
@end
