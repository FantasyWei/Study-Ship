//
//  RWViewController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/19.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWTabBarController.h"
#import "RWNavController.h"
#import "UIImageView+YYWebImage.h"

@interface RWTabBarController ()

@end

@implementation RWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.backgroundImage  = [UIImage imageNamed:@"tabbarBkg"];
    
    [self addChildViewControllers];
}
-(void)addChildViewControllers{

    [self addChildViewController:@"Friends" image:@"tabbar_home" title:@"首页"];
    [self addChildViewController:@"Message" image:@"tabbar_mainframe" title:@"动态"];
    [self addChildViewController:@"Movie" image:@"tabbar_discover" title:@"发现"];
    
    [self addChildViewController:@"Profile" image:@"tabbar_contacts" title:@"我"];
}
-(void)addChildViewController:(NSString *)SBName image:(NSString *)imageNamed title:(NSString *)title{
    
       UIViewController *VC = [self  loadViewControllerWithStoryboardName:SBName];
    
    VC.title = title;
    
    VC.tabBarItem.image = [[UIImage imageNamed:imageNamed]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSString *high = [NSString stringWithFormat:@"%@HL",imageNamed];
    
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:high]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kColor} forState:UIControlStateSelected];
    
    [self addChildViewController: VC ];
}
-(UIViewController *)loadViewControllerWithStoryboardName:(NSString *)name{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *VC = sb.instantiateInitialViewController;
    
    return  VC;
 
}

@end
