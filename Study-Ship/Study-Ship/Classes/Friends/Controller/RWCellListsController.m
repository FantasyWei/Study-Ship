
//
//  RWCellListsController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWCellListsController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RWMediaModel.h"

@interface RWCellListsController ()
@property(nonatomic,copy) NSString *share_url;
@property (strong,nonatomic) NSMutableArray *dataArray;
@end

@implementation RWCellListsController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self sendCellListRequest];
}
-(void)setupUI{
    self.navigationController.title = @"课程介绍";
    
}
-(void)didClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendCellListRequest {
    
    NSString *urlString = @"http://www.imooc.com/api3/getmediainfo_ver2";
    //uid=0&cid=637&token=9bb4b17710b70a920a1a121cba84c1c2
    NSString *dataString = [NSString stringWithFormat:@"uid=2087502&cid=%ld&token=439619c3bc2c481084fa85ed2e9702c4",self.ids];
    
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
        
        NSDictionary *dataDict = dict[@"data"];
        
        NSDictionary *mediaDict = dataDict[@"media"];
        
        NSString *share_url = mediaDict[@"share_url"];

        self.share_url = share_url;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendRequestForlist];
//            [self playTheMovieWithUrlString:movieUrlString];
        });
        
    }]resume];
    
}
-(void)sendRequestForlist{
    NSString *urlString = @"http://www.imooc.com/api3/getcpinfo_ver2";
    //uid=0&cid=637&token=9bb4b17710b70a920a1a121cba84c1c2
    NSString *dataString = [NSString stringWithFormat:@"uid=2087502&cid=%ld&token=b86ba2ba1722100c501e66d190279e12",self.ids];
    
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
        
        for (NSDictionary *dict in dataArr) {
            
            NSArray *media = dict[@"media"];
            
            for (NSDictionary *dict in media) {
          
//                NSLog(@"%@",dict[@""]);
                
                RWMediaModel *model = [RWMediaModel mediaModelWithDictionay:dict];
                [self.dataArray addObject:model];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            //            [self playTheMovieWithUrlString:movieUrlString];
        });
        
    }]resume];
}
#pragma mark - 视频播放
-(void)playTheMovieWithMediaModel:(RWMediaModel *)model{
    
    NSString *urlString = model.media_url;
    
    AVPlayerViewController *vc = [[AVPlayerViewController alloc]init];
    
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:urlString]];
    
    vc.player = player;
    
    [player play];
    
    [self presentViewController:vc animated:YES completion:NULL];
    
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"home_Media_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    RWMediaModel *model = self.dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"networkPlayDefault"];
    cell.textLabel.text = model.name;
    NSInteger m = model.duration/60000;
    NSInteger s = (model.duration - m*60000)/1000;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"视频总长:%ld:%-ld   共计%.2fMB",m ,s,(float)model.media_size/(1024 * 1024)];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RWMediaModel *model = self.dataArray[indexPath.row];
    
    [self playTheMovieWithMediaModel:model];
}

@end
