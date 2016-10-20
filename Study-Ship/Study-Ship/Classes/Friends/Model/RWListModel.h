//
//  RWListModel.h
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWListModel : NSObject
@property(nonatomic,assign) NSInteger ids;
@property(nonatomic,copy) NSString *pic;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *numbers;

+(instancetype)listModelWithDictionay:(NSDictionary *)dict;
@end
