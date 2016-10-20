//
//  RWMessageController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/19.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWMessageController.h"
#import "RWChannelView.h"
#import "RWCollectionViewFlowLayout.h"
#import "RWNewsMainControllerView.h"

@interface RWMessageController ()

@end

@implementation RWMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    RWChannelView *channel = [[RWChannelView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35) collectionViewLayout:[[RWCollectionViewFlowLayout alloc]initWithClassString:@"RWChannelView"]];
    
    [self.view addSubview:channel];
    
    // 2.创建新闻主界面
    RWNewsMainControllerView *newsMain = [[RWNewsMainControllerView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, kScreenHeight - 35-64-44) collectionViewLayout:[[RWCollectionViewFlowLayout alloc]initWithClassString:@"RWNewsMainControllerView"]];
    
    newsMain.vc = self;
    
    [self.view addSubview:newsMain];
}

@end
