//
//  RWClassController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWClassController.h"
#import "YYWebImage.h"
#import "RWTableModel.h"
#import "RWRefreshGifHeader.h"
#import "RWTableViewCell.h"
#import "Masonry.h"
#import "RWCellListsController.h"
@interface RWClassController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic)  UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageIndex;
@end

@implementation RWClassController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.pageIndex = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self sendHttpRequest];
}
-(void)setupUI{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(88);
    }];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView yy_setImageWithURL:[NSURL URLWithString:self.pic] placeholder:[UIImage imageNamed:@"ic_chat_placeHolder"]];
    imageView.layer.cornerRadius = 22;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(4);
        make.width.equalTo(44);
        make.height.equalTo(imageView.width);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = self.name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:25];
    [label sizeToFit];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.bottom).offset(4);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.backgroundColor = kColor;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.bottom);
        make.leading.equalTo(view);
        make.bottom.equalTo(self.view);
        make.trailing.equalTo(view);
    }];
    
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 80;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource=self;
    self.pageIndex = 1;
    
    
    RWRefreshGifHeader *head = [RWRefreshGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        
        [self sendHttpRequest];
        
    }];
    if(self.dataArray != nil){
        [self.tableView.mj_header beginRefreshing];
    }
    head.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = head;

}
-(void)sendHttpRequest{
    NSString *urlString = @"http://www.imooc.com/api3/courselist_ver2";
    //uid=0&cid=637&token=9bb4b17710b70a920a1a121cba84c1c2
    NSString *dataString = [NSString stringWithFormat:@"easy_type=0&timestamp=1459000827995&uid=2087502&all_type=0&page=%ld&cat_type=%ld&token=ad5f8cadc103cd1b6681d7006e23f48b",self.pageIndex,self.ids];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody =data;
    request.HTTPMethod = @"POST";
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error:%@",error);
            return ;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSArray *dataArr = dict[@"data"];
        
        if (self.pageIndex == 1) {
            [self.dataArray removeAllObjects];
        }
        
        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            
            RWTableModel *model = [RWTableModel vidoesModelWithDictionay:dict];
            
            [self.dataArray addObject:model];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView.mj_header endRefreshing];
            
            [self.tableView reloadData];
            
        });
        
    }]resume];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"home_Class_cellID";
    RWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (indexPath.row == self.dataArray.count - 2 ) {
        
        self.pageIndex++;
        [self sendHttpRequest];
        
    }
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    RWTableModel *model = self.dataArray[indexPath.row];
    
    cell.model = model;
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        RWTableModel *model = self.dataArray[indexPath.row];
        
        RWCellListsController *cellLists = [[RWCellListsController alloc]init];
        cellLists.ids = model.ids;
        
        [self.navigationController pushViewController:cellLists animated:YES];
}
@end
