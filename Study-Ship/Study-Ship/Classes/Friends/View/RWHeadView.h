//
//  RWHeadView.h
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWHeadModel.h"
#define kheaterViewSize   (self.frame.size)
@interface RWHeadView : UITableViewHeaderFooterView
@property(nonatomic,strong) RWHeadModel *headModel;
@property(nonatomic,assign)  BOOL isRotate;
@property(nonatomic,copy) void(^didClickBtnBlock)(RWHeadView * ,UIButton *);
@end
