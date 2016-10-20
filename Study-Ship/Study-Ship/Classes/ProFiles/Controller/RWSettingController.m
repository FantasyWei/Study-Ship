//
//  RWSettingController.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/10.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWSettingController.h"
#import "RWAboutController.h"
#import "SSKeychain.h"
#import "RWTabBarController.h"


@interface RWSettingController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property(nonatomic,assign) BOOL isLogin;
@end

@implementation RWSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"myButton"];
    UIImage *imagePress = [UIImage imageNamed:@"myButtonPressed"];
    
    imagePress = [imagePress stretchableImageWithLeftCapWidth:imagePress.size.width * 0.5 topCapHeight:imagePress.size.height*0.5];
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    
    [self.logoutButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.logoutButton setBackgroundImage:imagePress forState:UIControlStateHighlighted];
    
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    NSString *username = [user objectForKey:kUserNameKey];
    
    NSString *password = [SSKeychain passwordForService:kAppBundleID account:username];
    if (username && password){
        self.isLogin = YES;
        self.logoutButton.enabled = YES;
    }
    
}
- (IBAction)didClickAboutButton:(id)sender {
    RWAboutController *about = [[RWAboutController alloc]init];
    [self.navigationController pushViewController:about animated:YES];
}
- (IBAction)didClickLogoutBtn:(id)sender {
    //清除用户密码
    [self deletePassword];
    self.isLogin = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
    RWTabBarController *vc = [[RWTabBarController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}
-(void)deletePassword{
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    NSString *username = [user objectForKey:kUserNameKey];
    
    
    [SSKeychain deletePasswordForService:kAppBundleID account:username];
}

@end
