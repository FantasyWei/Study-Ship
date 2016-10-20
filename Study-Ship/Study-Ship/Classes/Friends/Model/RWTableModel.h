//
//  RWTableModel.h
//  Study-Ship
//
//  Created by ReoWei on 16/3/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTableModel : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *pic;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,assign) NSInteger numbers;
@property(nonatomic,assign) NSInteger ids ;

+(instancetype)vidoesModelWithDictionay:(NSDictionary *)dict;
@end
