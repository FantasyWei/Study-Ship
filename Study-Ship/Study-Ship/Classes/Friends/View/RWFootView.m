//
//  RWFootView.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/24.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWFootView.h"
#import "Masonry.h"

@interface RWFootView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RWFootView

-(void)showViewAlpha:(BOOL)isShow{
    
    if (isShow) {
        [_activity startAnimating];
    }else{
        [_activity stopAnimating];
        _activity.hidesWhenStopped = YES;
        self.titleLabel.text = @"没网咯!!!请检查网络吧!";
       
        [self.titleLabel sizeToFit];

    }
    
}

@end
