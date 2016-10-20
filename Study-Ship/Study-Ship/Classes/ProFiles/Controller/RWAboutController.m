//
//  RWAboutController.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/10.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWAboutController.h"
#import "Masonry.h"

@interface RWAboutController ()

@end

@implementation RWAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setupUI];
}
-(void)setupUI{
    
    UILabel *chineseLabel = [UILabel new];
    
    [chineseLabel setText:@"目前木有其他的产品哦"];
    chineseLabel.textColor = [UIColor whiteColor];
    chineseLabel.textAlignment = NSTextAlignmentCenter;
    chineseLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:chineseLabel];
    [chineseLabel sizeToFit];
    
    [chineseLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [label setText:@"Currently no other products"];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Zapfino" size:18];
    [self.view addSubview:label];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}
@end
