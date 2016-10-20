//
//  RWHeadModel.h
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWHeadModel : NSObject
@property(nonatomic,assign) NSInteger ids;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *marking;
@property(nonatomic,strong) NSArray *skills;
@property(nonatomic,assign,getter=isExplaned) BOOL  isExplan;

+(instancetype)headModelWithDictionay:(NSDictionary *)dict;
@end
