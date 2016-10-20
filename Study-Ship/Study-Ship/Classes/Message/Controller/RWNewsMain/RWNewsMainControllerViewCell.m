//
//  RWNewsMainControllerViewCell.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/6.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWNewsMainControllerViewCell.h"

@implementation RWNewsMainControllerViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    // 加载 tableView
    RWNewsDataView *dataView = [[RWNewsDataView alloc] initWithFrame:self.bounds];
    
    self.dataView = dataView;
    
    dataView.index = 1;
    
    // 将新闻主界面的 tableView 添加在 collectionViewCell 上!
    [self.contentView addSubview:dataView];
    
    
    return self;
}
@end
