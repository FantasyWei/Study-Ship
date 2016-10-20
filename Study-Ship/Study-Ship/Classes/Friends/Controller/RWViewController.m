//
//  RWViewController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWViewController.h"
#import "RWScrollView.h"
#import "Masonry.h"
#import "RWTableView.h"
#import "RWClassifyController.h"
#import "RWNavController.h"
#import "RWClassController.h"


@interface RWViewController ()<UIPopoverPresentationControllerDelegate>

@property(nonatomic,weak) RWTableView *tableView;
@end

@implementation RWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    
    //添加TaleView
    RWTableView *tableView = [[RWTableView alloc]init];
    
    self.tableView = tableView;
    
    tableView.vc = self;
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.topLayoutGuide);
    }];
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (![segue.identifier isEqualToString:@"showClassifyList"]) {
        return;
    }
     UIPopoverPresentationController *poppver = segue.destinationViewController.popoverPresentationController;
    
    segue.destinationViewController.preferredContentSize = CGSizeMake(200, 300);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(disissClassfiyVC:) name:@"disissClassfiyVC" object:nil];
    
    poppver.delegate = self;
    
    
}
-(void)disissClassfiyVC:(NSNotification*)notify{
    RWClassController *classLists = notify.object;
    
    // 一开始popover销毁的时候,topViewController是当前VC,满足条件跳转
    // 由于SB中popover时又加了一层nav,所以再第二次开始,popover的nav还在,他的topvc就是RWClassController,并且每次都会剩下,使得topvc是RWClassController的数目每次加1,如果不判断,就会导致程序奔溃,提示跳进没被释放掉的vc
    if(![self.navigationController.topViewController isKindOfClass:[RWClassController class]]) {
        [self.navigationController pushViewController:(UIViewController *)classLists animated:YES];
    }
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection{
    return UIModalPresentationNone;
}
@end
