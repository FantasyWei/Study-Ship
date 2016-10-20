//
//  RWNewsDataView.h
//  Study-Ship
//
//  Created by ReoWei on 16/4/6.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWChannelModel.h"

@interface RWNewsDataView : UITableView
@property(nonatomic,strong) RWChannelModel *channels;
@property (nonatomic, assign) NSInteger index;
@property(nonatomic,weak) UIViewController *vc;
@end
