//
//  RWChannelView.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/1.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWChannelView.h"
#import "RWChannelViewCell.h"
#import "RWChannelModel.h"

#define kChannelCellID @"Message_channel_cell"

@interface RWChannelView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation RWChannelView
-(NSMutableArray *)channels
{
    if (!_channels) {
        _channels = [NSMutableArray array];
    }
    
    return _channels;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    NSString *path = [[NSBundle mainBundle]pathForResource:@"message_channel.plist" ofType:nil];
    NSArray *channelArray = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *dict in channelArray) {
        RWChannelModel *model = [RWChannelModel channelModelWithDict:dict];
        [self.channels addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginLoadMainDataView" object:self.channels];
    });
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor whiteColor];
    // 注册 cell
    [self registerClass:[RWChannelViewCell class] forCellWithReuseIdentifier:kChannelCellID];
    // 设置数据源和代理
    self.dataSource = self;
    
    self.delegate = self;
    
    // 隐藏滚动条
    self.showsHorizontalScrollIndicator = NO;
    
    // 取消弹簧效果
    self.bounces = NO;

    // 设置第一行的 indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    // 选中第一行
    [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];

    
    
    
    // 注册通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToIndexPathWithNotify:) name:@"RWNewsChannelViewScrollToIndexPath" object:nil];
    
    return self;

}
- (void)scrollToIndexPathWithNotify:(NSNotification *)notify
{
    NSIndexPath *indexPath = notify.object;
    
    // 刷新数据
    // 必须刷新之后,才能保证滚动和选中成功
    [self reloadData];
    
    // 选中对应的位置
    [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    // 滚动到对应的位置
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.channels.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RWChannelViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kChannelCellID forIndexPath:indexPath];
    RWChannelModel *model = self.channels[indexPath.item];
    cell.channel = model;
    return cell;
}
#pragma UICollectionViewDelegateFlowLayout
// itemSize : 如果不手动设置代理,以 layout.itemSize 为准!
// 如果设置了代理,就动态改变 itemSize 这个方法类似于 tableView代理的heightforrow
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWChannelModel *channel = self.channels[indexPath.item];
    
    return [self getItemSizeWithString:channel.type_name];
}
// 根据文字,自动生成宽高!
- (CGSize)getItemSizeWithString:(NSString *)tname
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18];
    
    label.text = tname;
    [label sizeToFit];
    
    return label.bounds.size;
}
#pragma UICollectionViewDelegate

// 选中/点击的时候
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 让新闻主界面滚动到相应的位置! 发出通知,让他滚动!
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToIndexPath" object:indexPath];
    
    // 让选中的位置位于水平中心!
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // 取出选中时候对应的数据模型!
    RWChannelModel *channel = self.channels[indexPath.item];
    
    // 取出选中的时候对应的 cell
    RWChannelViewCell *cell = (RWChannelViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // 给选中的 cell 赋值!
    cell.channel = channel;
}

// 取消选中
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出选中时候对应的数据模型!
    RWChannelModel *channel = self.channels[indexPath.item];
    
    // 取出选中的时候对应的 cell
    RWChannelViewCell *cell = (RWChannelViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // 给选中的 cell 赋值!
    cell.channel = channel;
}

@end
