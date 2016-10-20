//
//  RWTableView.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWTableView.h"
#import "RWTableViewCell.h"
#import "RWTableModel.h"
#import "AFHTTPSessionManager.h"
#import "SVProgressHUD.h"
#import "YYWebImage.h"
#import "Masonry.h"
#import "RWFootView.h"
#import "RWRefreshGifHeader.h"
#import "RWScrollView.h"
#import "RWCellListsController.h"


@interface RWTableView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *videos;
@property(nonatomic,strong) RWTableModel *model;
@property(nonatomic,assign) NSInteger pageIndex;
@property(nonatomic,weak) UIView *coverView;
@property(nonatomic,strong) RWScrollView *scroll;
@property(nonatomic,weak) RWFootView *footView;
@end

@implementation RWTableView

-(NSMutableArray *)videos{
    if (!_videos) {
        _videos = [NSMutableArray array];
        [_videos addObject:[RWTableModel new]];
    }
    return _videos;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.separatorStyle =UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 80;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource=self;
        self.pageIndex = 1;
        [self sendHttpRequest];
        
        RWRefreshGifHeader *head = [RWRefreshGifHeader headerWithRefreshingBlock:^{
            self.pageIndex = 1;
    
            [self sendHttpRequest];
            
        }];
        if(self.videos != nil){
            [self.mj_header beginRefreshing];
        }
        head.automaticallyChangeAlpha = YES;
        self.mj_header = head;
        
        
        self.backgroundColor = [UIColor whiteColor];
    }
       return self;
}

-(void)setupFootView{
    RWFootView *footView = [[[NSBundle mainBundle]loadNibNamed:@"FootView" owner:nil options:nil]lastObject];
    self.tableFooterView = footView;
    self.footView = footView;
    [footView showViewAlpha:YES];
    
}
-(void)sendHttpRequest{
    
    if (self.pageIndex != 1) {
        [self setupFootView];
        
    }
   
    NSString *urlString =@"http://www.imooc.com/api3/courselist_ver2";
    //cat_type=0&easy_type=0&page=1&sort_type=0&token=7f75e24cb1f7e5c358f03a7b40a60976&uid=0
//    timestamp=1458837521562&uid=2087502&page=2&token=ad5f8cadc103cd1b6681d7006e23f48b
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageIndex];
    
     NSDictionary *dict = @{@"page":page,@"token":@"ad5f8cadc103cd1b6681d7006e23f48b",@"uid":@"2087502",@"timestamp":@"1458837521562"};
    
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager]; 
    
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject != nil) {
            
            NSData *data = responseObject;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                
                NSArray *dataArr = dict[@"data"];
            
                NSInteger errorCode = [(NSNumber*)dict[@"errorCode"] integerValue] ;

//            NSLog(@"%ld",errorCode);
            
            if (self.pageIndex == 1) {
                
                [self.videos removeAllObjects];
                [self.videos addObject:[RWTableModel new]];
            }
            
            
            if (errorCode == 1000) {
                
                [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = obj;
                    
                    RWTableModel *model = [RWTableModel vidoesModelWithDictionay:dict];
                    
                    [self.videos addObject:model];
                    
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.mj_header endRefreshing];
                    
                    [self reloadData];
                    
//                    [self.scroll removeFromSuperview];
                });
            }
            if (errorCode == 1005){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableFooterView = nil;
                });
                [self remindWithMessage:@"没有更多数据咯!"];
            }

            }else{
                [SVProgressHUD showErrorWithStatus:@"未知错误"];
            }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"联网失败" ];
        [self.mj_header endRefreshing];
        if (self.videos.count == 1) {
            [self setupCoverView];
        }else{
            [self.footView showViewAlpha:NO];
        }
        
    }];
}
-(void)remindWithMessage:(NSString *)msm{
    NSString *string = msm;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sure];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.vc presentViewController:alert animated:YES completion:nil];
    });
    
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videos.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.mj_header endRefreshing];

    if (indexPath.row == 0 && self.videos.count !=0){
        RWTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"head_Table_Cell"];
        
        if (!cell) {
            cell = [[RWTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head_Table_Cell"];
        }
        
        if (self.scroll == nil ){//防止每次刷新,都会创建scrollView
            
            RWScrollView *scroll = [RWScrollView new];
        
            self.scroll = scroll;
            
            [cell.contentView addSubview:self.scroll];
            
            [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.leading);
                make.trailing.equalTo(cell.contentView);
                make.top.equalTo(cell.contentView);
                make.height.equalTo(cell.contentView);
            }];
            
            UIPageControl *page = [[UIPageControl alloc]init];
            
            self.scroll.pageControll = page;
            
            [cell.contentView addSubview:page];
            
            [page mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.scroll.centerX);
                make.centerY.equalTo(self.scroll.bottom).offset(-20);
                make.width.equalTo(100);
            }];
        }
       
  
        

        
        return cell;
    }
    if (indexPath.row == self.videos.count - 2 ) {
        
        self.pageIndex++;
        [self sendHttpRequest];
    }
    
    static NSString *cellID = @"home_Table_Cell";
    
    RWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    RWTableModel *model = self.videos[indexPath.row];
    
    cell.model = model;
    
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return 180;
    else
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != 0) {
        
        RWTableModel *model = self.videos[indexPath.row];
        
        RWCellListsController *cellLists = [[RWCellListsController alloc]init];
        cellLists.ids = model.ids;
        
        [self.vc.navigationController pushViewController:cellLists animated:YES];

    }
    
    
}

-(void)setupCoverView{
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.vc.view addSubview:coverView];
    coverView.backgroundColor=[UIColor whiteColor];
    UIButton *button = [[UIButton alloc]init];
    
    [button setBackgroundImage:[UIImage imageNamed:@"ic_no_net"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(didClickLoadButton) forControlEvents:UIControlEventTouchUpInside];
    
    [coverView addSubview:button];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"没网咯!请点击图片重新加载吧!";
    label.textColor = kColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [label sizeToFit];
    [coverView addSubview:label];
    
    self.coverView = coverView;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(coverView);
        make.centerY.equalTo(coverView).offset(-40);
        make.width.equalTo(180);
        make.height.equalTo(button.width);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(coverView);
        make.top.equalTo(button.bottom).offset(44);
    }];
    
}
-(void)didClickLoadButton{
//    [self sendHttpRequest];
    [self.coverView removeFromSuperview];
    [self sendHttpRequest];
    [self.scroll sendHttpRequest];
}
@end
