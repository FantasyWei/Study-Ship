//
//  RWNewsData.h
//  Study-Ship
//
//  Created by ReoWei on 16/4/6.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWNewsData : NSObject

@property(nonatomic,copy) NSString *img;
@property(nonatomic,assign) NSInteger ids;
@property(nonatomic,copy) NSString *type_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) NSInteger view;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *desc;

+(instancetype)newsDataModelWithDictionay:(NSDictionary *)dict;
@end
