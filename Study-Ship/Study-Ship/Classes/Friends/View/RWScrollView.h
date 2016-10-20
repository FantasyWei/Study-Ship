//
//  RWScrollView.h
//  Study-Ship
//
//  Created by ReoWei on 16/3/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWScrollView : UIScrollView
@property(nonatomic,strong) UIPageControl *pageControll;
@property(nonatomic,strong) NSMutableArray *images;
-(void)sendHttpRequest;
@end
