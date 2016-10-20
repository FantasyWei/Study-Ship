//
//  RWNewsDataView.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/6.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWNewsDataView.h"
#import "RWNewsDataViewCell.h"
#import "RWNewsData.h"
#import "RWRefreshGifHeader.h"
#import "RWFootView.h"
#import "SVProgressHUD.h"
#import "RWWebController.h"

@interface RWNewsDataView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *news;

@property(nonatomic,weak) RWFootView *footView;

@end

@implementation RWNewsDataView
-(NSMutableArray *)news
{
    if (!_news) {
        _news = [NSMutableArray array];
    }
    return _news;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    // 还原 加载更过数据的值!
    self.index = 1;
    // 设置数据源和代理
    self.dataSource = self;
    
    self.delegate = self;
    
    self.estimatedRowHeight = 150;
    
    RWRefreshGifHeader *head = [RWRefreshGifHeader headerWithRefreshingBlock:^{
        self.index = 1;
        
        [self getNewsMainDataWithTid:self.channels.type_id];
        
    }];
    if(self.news != nil){
        [self.mj_header beginRefreshing];
    }
    head.automaticallyChangeAlpha = YES;
    self.mj_header = head;
    
    return self;
}
// 准备加载新的新闻数据
-(void)setChannels:(RWChannelModel *)channels
{
    _channels = channels;
    
    // 清空数据
    [self.news removeAllObjects];
    // 刷新数据源
    [self reloadData];
    
    // 显示状态栏菊花
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 加载对应的新闻数据!
    [self getNewsMainDataWithTid:channels.type_id];
}
-(void)getNewsMainDataWithTid:(NSString *)tid
{
    if (self.index != 1) {
        [self setupFootView];
    }
    NSString *urlString = @"http://www.imooc.com/api3/articlelist";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    request.HTTPMethod = @"POST";
    
    NSString *bodyString= [NSString stringWithFormat:@"uid=2087502&aid=0&type=0&page=%ld&typeid=%@&token=12063af801143ecb920bd0f26733fd00",self.index,self.channels.type_id];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil && data == nil) {
            NSLog(@"%@",error);
            return ;
        }
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *dataArr = dataDict[@"data"];
        NSInteger errorCode = [(NSNumber*)dataDict[@"errorCode"] integerValue] ;
        if (errorCode == 1000) {
            if (self.index == 1) {
                [self.news removeAllObjects];
            }
            [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                
                RWNewsData *model = [RWNewsData newsDataModelWithDictionay:dict];
                
                [self.news addObject:model];
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.mj_header endRefreshing];
                
                [self reloadData];
                // 隐藏状态栏菊花
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }
        if (errorCode == 1005){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableFooterView = nil;
            });
    }

    }]resume];
    
}
-(void)setupFootView{
    RWFootView *footView = [[[NSBundle mainBundle]loadNibNamed:@"FootView" owner:nil options:nil]lastObject];
    self.tableFooterView = footView;
    self.footView = footView;
    [footView showViewAlpha:YES];
    
}
#pragma UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}


#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *resumeCell = @"Message_DataView_Cell";
    
    RWNewsDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resumeCell];
    
    if (!cell) {
        cell = [[RWNewsDataViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resumeCell];
    }
    
    RWNewsData *newsData = self.news[indexPath.row];
    // 监听当前的行数,加载更过数据!
    if (indexPath.row == self.news.count - 2) {
        self.index ++;
        
        [self getNewsMainDataWithTid:newsData.type_id];
    }
    // 赋值!
    cell.newsData = newsData;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RWNewsData *newsData = self.news[indexPath.row];
    
    RWWebController *vc = [[RWWebController alloc]init];
    
    vc.newsData = newsData;
    
    [self.vc.navigationController pushViewController:vc animated:YES];
}


@end
