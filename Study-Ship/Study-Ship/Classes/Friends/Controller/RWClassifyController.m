//
//  RWClassifyController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/26.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWClassifyController.h"
#import "RWClassController.h"
#import "RWListModel.h"
#import "RWHeadModel.h"
#import "RWHeadView.h"
#import "YYWebImage.h"


@interface RWClassifyController ()
@property (strong,nonatomic) NSMutableArray *dataArray;
@property(nonatomic,strong) RWClassController *classLists;
@end

@implementation RWClassifyController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}
static NSString  *reuseIdentifier = @"home_List_Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self sendHttpRequest];
    
    [self setupUI];
}
-(void)setupUI{
    self.tableView.rowHeight = 44;
    self.tableView.sectionHeaderHeight = 44;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}
-(void)sendHttpRequest{
    NSString *paramaters = @"uid=2087502&token=a09b17265edd3a58a6149c74d0c27924";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.imooc.com/api3/newcourseskill"]];
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [paramaters dataUsingEncoding:NSUTF8StringEncoding];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        if (data) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSDictionary *datas = dataDict[@"data"];
            
            NSArray *categories = datas[@"categories"];
            
            for (NSDictionary *dict in categories) {
                RWHeadModel *headModel = [RWHeadModel headModelWithDictionay:dict];
                [self.dataArray addObject:headModel];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    }]resume];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RWHeadModel *model = self.dataArray[section];
    NSInteger rows = model.isExplan?model.skills.count:0;
    return rows;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        UIView *lines=[[UIView alloc]initWithFrame:CGRectMake(0, 44-0.5,kScreenSize.width , 0.5)];
        lines.backgroundColor=[UIColor grayColor];
        [cell addSubview:lines];
    }
    RWHeadModel *headModel = self.dataArray[indexPath.section];
    RWListModel *listModel = headModel.skills[indexPath.row];
    
    [cell.imageView yy_setImageWithURL:[NSURL URLWithString:listModel.pic] placeholder:[UIImage imageNamed:@"ic_chat_placeHolder"]];
    cell.textLabel.text = listModel.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 个视频",listModel.numbers];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString  *reuseHeadIdentifier = @"home_HeadView_Cell";
    
    RWHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeadIdentifier];
    
    if (!headView) {
        headView = [[RWHeadView alloc]initWithReuseIdentifier:reuseHeadIdentifier];
    }
    RWHeadModel *headModel = self.dataArray[section];
    headView.headModel = headModel;
    headView.tag = section;
    headView.isRotate = headModel.isExplan;
    
    __weak __typeof(self) weakSelf = self;
    headView.didClickBtnBlock = ^(RWHeadView *headView, UIButton *button){
        headView.isRotate = !headView.isRotate;
        RWHeadModel *model = weakSelf.dataArray[headView.tag];
        model.isExplan = !model.isExplaned;
        
        NSIndexSet *index = [NSIndexSet indexSetWithIndex:headView.tag];
        [weakSelf.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationFade];
    };
    
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        RWHeadModel *headModel = self.dataArray[indexPath.section];
    
        RWListModel *listModel = headModel.skills[indexPath.row];
    
        RWClassController *classLists = [[RWClassController alloc]init];
    
        classLists.ids = listModel.ids;
    
        classLists.name = listModel.name;
    
        classLists.pic = listModel.pic;
    
        self.classLists = classLists;
    
     [self dismissViewControllerAnimated:YES completion:^{
         [[NSNotificationCenter defaultCenter]postNotificationName:@"disissClassfiyVC" object:classLists];
     }];
    
    
}
    
    

@end
