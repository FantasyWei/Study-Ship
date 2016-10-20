//
//  RWTableViewCell.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWTableViewCell.h"
#import "YYWebImage.h"

@interface RWTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation RWTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(RWTableModel *)model{
    _model = model;
    [self.iconView yy_setImageWithURL:[NSURL URLWithString:model.pic] placeholder:[UIImage imageNamed:@"bg_mooc_placeholder"]];
    self.titleLabel.text = model.name;
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    self.titleLabel.textColor = kColor;
    
    self.numbersLabel.text = [NSString stringWithFormat:@"喜欢人数: %ld",(long)model.numbers];
    
    self.descLabel.text = [NSString stringWithFormat:@"简介: %@",model.desc];
    
}

@end
