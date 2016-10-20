//
//  RWNewsDataViewCell.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/6.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWNewsDataViewCell.h"
#import "YYWebImage.h"
#import "Masonry.h"

@interface RWNewsDataViewCell()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property(nonatomic,strong) UILabel *typeLabel;

@property(nonatomic,strong) UILabel *readLabel;

@property (nonatomic, strong) UILabel * descLabel;
@end

@implementation RWNewsDataViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    // cell
    
    self.iconView = [[UIImageView alloc]init];
    
    
    
    UILabel *title = [[UILabel alloc]init];
    self.titleLabel = title;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.font = [UIFont systemFontOfSize:12];
    
    self.readLabel = [[UILabel alloc]init];
    self.readLabel.font = [UIFont systemFontOfSize:12];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.numberOfLines = 0;
    self.descLabel.textColor = [UIColor lightGrayColor];
    self.descLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.readLabel];
    [self.contentView addSubview:self.descLabel];
    
    return self;
}
-(void)setNewsData:(RWNewsData *)newsData{
    _newsData = newsData;
    [self.iconView yy_setImageWithURL:[NSURL URLWithString:newsData.img] placeholder:nil];
    self.titleLabel.text = newsData.title;
    self.typeLabel.text = newsData.type;
    self.readLabel.text = [NSString stringWithFormat:@"阅读: %ld",newsData.view];
    self.descLabel.text = newsData.desc;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(23);
        make.height.equalTo(20);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(0);
        make.width.equalTo(80);
        make.height.equalTo(16);
    }];
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLabel.trailing).offset(30);
        make.top.equalTo(self.typeLabel);
        make.width.equalTo(self.typeLabel);
        make.height.equalTo(self.typeLabel);
    }];
    if(self.newsData.img.length > 0){
        self.iconView.frame = CGRectMake(kScreenWidth -88-16, 65, 88, 66);
    }else{
        self.iconView.frame = CGRectMake(kScreenWidth-16, 65, 0, 0);
    }
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.typeLabel);
            make.trailing.equalTo(self.iconView.leading).offset(-10);
            make.top.equalTo(self.iconView);
            make.bottom.equalTo(self.contentView.bottom).offset(-23);
        }];
 
    
}
@end
