//
//  RWChannelViewCell.h
//  Study-Ship
//
//  Created by ReoWei on 16/4/1.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWChannelModel.h"

@interface RWChannelViewCell : UICollectionViewCell
// 给 cell 绑定数据模型!
@property (nonatomic, strong) RWChannelModel *channel;
@end
