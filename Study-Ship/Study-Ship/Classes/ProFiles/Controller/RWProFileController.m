//
//  RWProFileController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/19.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWProFileController.h"
#import "SSKeychain.h"
#import "Masonry.h"
#import "RWLoginController.h"
#import "RWNavController.h"


@interface RWProFileController ()
@property(nonatomic,assign) BOOL isLogin;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@property (weak, nonatomic) IBOutlet UIButton *Loginbutton;

@end

@implementation RWProFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    NSString *username = [user objectForKey:kUserNameKey];
    
    NSString *password = [SSKeychain passwordForService:kAppBundleID account:username];
    
    self.iconButton.layer.cornerRadius = 60;
    self.iconButton.layer.masksToBounds = YES;
    
    if (username && password){
        self.isLogin = YES;
        
        [self.Loginbutton setTitle:@"当前等级: LV 1" forState:UIControlStateNormal];
        
        [self.iconButton setBackgroundImage:[UIImage imageNamed:@"Profile"] forState:UIControlStateNormal];
        
        [self.Loginbutton sizeToFit];
        
    }else{
        self.isLogin = NO;
        
        [self.iconButton setBackgroundImage:[UIImage imageNamed:@"bg_head"] forState:UIControlStateNormal];
        [self.Loginbutton setTitle:@"立即登录" forState:UIControlStateNormal];
        [self.Loginbutton sizeToFit];
    }
}
- (IBAction)didClickLoginBtn:(id)sender {
    if (self.isLogin == NO) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginSB" bundle:nil];
        UIViewController *vc = sb.instantiateInitialViewController;
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
}

@end
