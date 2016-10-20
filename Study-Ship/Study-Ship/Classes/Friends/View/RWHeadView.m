//
//  RWHeadView.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWHeadView.h"

@interface RWHeadView ()
@property (nonatomic, weak) UIButton *headerButton;

@property (nonatomic, weak) UILabel *numberLabel;
@end

@implementation RWHeadView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self ==[super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    UIButton *button = [[UIButton alloc]init];
    self.headerButton = button;
    
    [button setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self
                    action:@selector(didClickButton:)
          forControlEvents:UIControlEventTouchUpInside];
    
    button.imageEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 25, 0, 0);
    button.imageView.contentMode=UIViewContentModeCenter;
    //clipsToBounds 默认为YES 会把超出bounds 的部分给裁剪掉
    button.imageView.clipsToBounds = NO;
    UILabel *numberLabel =[[UILabel alloc]init];
    numberLabel.textColor=[UIColor blackColor];
    self.numberLabel = numberLabel;
    numberLabel.textAlignment=NSTextAlignmentRight;
    [button addSubview:numberLabel];
    self.numberLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:button];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];//先调用父类的
    _headerButton.frame=self.contentView.frame;
    CGFloat labelWidth = 100;
    CGFloat labelX=kheaterViewSize.width -labelWidth-30;
    self.numberLabel.frame = CGRectMake(labelX, 0, labelWidth, 44);
}
-(void)didClickButton:(UIButton *)button{
    if (self.didClickBtnBlock) {
        self.didClickBtnBlock(self,button);
    }
}

-(void)setHeadModel:(RWHeadModel *)headModel{
    _headModel = headModel;
    NSString *numbers = [NSString stringWithFormat:@"共%ld项",headModel.skills.count];
    self.numberLabel.text = numbers;
    [self.headerButton setTitle:headModel.name forState:UIControlStateNormal];
}
-(void)setIsRotate:(BOOL)isRotate{
    _isRotate = isRotate;
    
    if (isRotate) {
        _headerButton.imageView.transform=CGAffineTransformMakeRotation(M_PI_2);
        
    }else{
        _headerButton.imageView.transform=CGAffineTransformIdentity;
        
    }
    
    
}
@end
