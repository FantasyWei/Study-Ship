//
//  RWCollectionViewFlowLayout.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/1.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWCollectionViewFlowLayout.h"

@implementation RWCollectionViewFlowLayout
-(instancetype)initWithClassString:(NSString *)classString
{
    // 实例化!
    RWCollectionViewFlowLayout *layout = [[RWCollectionViewFlowLayout alloc] init];
    // 设置滚动方向为 水平滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if ([classString isEqualToString:@"RWChannelView"]) {
        
        // 设置内边距
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.minimumLineSpacing = 20;
        
    }else
    {
        // 设置 item/cell 的大小!
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight -35-64-44);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
    }
    
    return layout;
}


@end
