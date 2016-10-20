//
//  RWChannelView.h
//  Study-Ship
//
//  Created by ReoWei on 16/4/1.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWChannelView : UICollectionView
// 存放 channel 模型的数据源!
@property (nonatomic, strong) NSMutableArray *channels;
@end
