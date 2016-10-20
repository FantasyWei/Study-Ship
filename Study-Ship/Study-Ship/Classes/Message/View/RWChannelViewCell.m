//
//  RWChannelViewCell.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/1.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWChannelViewCell.h"
#import "Masonry.h"
@interface RWChannelViewCell ()
@property (nonatomic, strong) UILabel *tNameLabel;
@property(nonatomic,strong) UIView *lineView;
@end
@implementation RWChannelViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    // 设置 展示界面
    self.tNameLabel = [[UILabel alloc] init];
    
    self.tNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tNameLabel.font = [UIFont systemFontOfSize:18];
    
    self.lineView = [[UIView alloc]init];
    
    self.lineView.backgroundColor = kColor;
    
    // 添加UI
    [self.contentView addSubview:self.tNameLabel];
    [self.contentView addSubview:self.lineView];
    return self;
}
// 赋值!
-(void)setChannel:(RWChannelModel *)channel
{
    _channel = channel;
    
    self.tNameLabel.text = channel.type_name;
    
    if (self.isSelected) {// 选中状态!
        
        // 颜色
        self.tNameLabel.textColor = kColor;
        
        self.lineView.alpha = 1;
        
    }else
    {
        self.tNameLabel.textColor = [UIColor lightGrayColor];
        self.lineView.alpha = 0;
    }
    
    [self.tNameLabel sizeToFit];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 选中状态的 label 比 为选中状态的 大!
    // 需要提前给 label 一个能够变大的空间(frame)
    
//    self.tNameLabel.frame = CGRectMake(0, 0 ,self.tNameLabel.bounds.size.width, self.tNameLabel.bounds.size.height);
    [self.tNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(self.tNameLabel);
        make.height.equalTo(self.tNameLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.trailing);
        make.bottom.equalTo(self.bottom);
        make.height.equalTo(2);
    }];
    
}
@end
