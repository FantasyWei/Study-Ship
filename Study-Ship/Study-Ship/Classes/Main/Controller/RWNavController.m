//
//  RWNavController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/21.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWNavController.h"

@interface RWNavController ()

@end

@implementation RWNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
     self.navigationBar.translucent = NO;
    
     [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.childViewControllers.count>0){
        NSString *backTitle = @"返回";
        if(self.childViewControllers.count == 1){
            backTitle = self.childViewControllers.firstObject.title;
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBtn)];
        [item setTitle:backTitle];
        
        self.navigationItem.leftBarButtonItem = item;

        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
}
-(void)didClickLeftBtn{
    [self popViewControllerAnimated:YES];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
