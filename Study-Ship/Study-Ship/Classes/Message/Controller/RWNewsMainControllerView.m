//
//  RWNewsMainController.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/6.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWNewsMainControllerView.h"
#import "RWNewsMainControllerViewCell.h"
#import "RWChannelModel.h"

@interface RWNewsMainControllerView ()<UICollectionViewDataSource,UICollectionViewDelegate>
// 数据源
@property (nonatomic, strong) NSMutableArray *channelArray;
@end

@implementation RWNewsMainControllerView
-(NSMutableArray *)channelArray{
    if(!_channelArray){
        _channelArray = [NSMutableArray array];
    }
    return _channelArray;
}

static NSString * const reuseIdentifier = @"Message_NewsMain_Cell";

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor whiteColor];

    // 注册 cell
    [self registerClass:[RWNewsMainControllerViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // 设置数据源/代理
    self.dataSource = self;
    self.delegate = self;
    
    // 取消滚动条
    self.showsHorizontalScrollIndicator = NO;
    
    // 取消弹簧效果
    self.bounces = NO;
    
    // 设置分页
    self.pagingEnabled = YES;
    
    // 注册通知观察者!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToIndexPathWithNotify:) name:@"ScrollToIndexPath" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChannelsWithNotify:) name:@"BeginLoadMainDataView" object:nil];
    
    return self;
}
#pragma UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    // 发送通知,让新闻频道界面滚动到相应的位置!
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RWNewsChannelViewScrollToIndexPath" object:indexPath];
}
-(void)dealloc
{
    // 移除通知观察者!
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 获得通知发送的新闻频道数据!
- (void)getChannelsWithNotify:(NSNotification *)notify
{
    // 给数据源赋值!
    self.channelArray = notify.object;
    // 刷新数据!
    [self reloadData];
}
-(void)scrollToIndexPathWithNotify:(NSNotification *)notify
{
    NSIndexPath *indexPath = notify.object;
    
    // 滚动
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.channelArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RWNewsMainControllerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    RWChannelModel *model = self.channelArray[indexPath.item];
    cell.dataView.channels = model;
    cell.dataView.vc = self.vc;
    return cell;
}
@end
