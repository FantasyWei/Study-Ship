//
//  RWTableViewCell.h
//  Study-Ship
//
//  Created by ReoWei on 16/3/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWTableModel.h"

@interface RWTableViewCell : UITableViewCell
@property(nonatomic,strong) RWTableModel *model;
@end
