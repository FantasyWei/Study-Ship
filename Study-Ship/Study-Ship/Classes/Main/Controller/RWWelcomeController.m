//
//  RWWelcomeController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/27.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWWelcomeController.h"
#import "RWTabBarController.h"
#import "RWNavController.h"
#import "RWLoginController.h"
#import "RWRegisterController.h"
#import "Masonry.h"

@interface RWWelcomeController ()

@end

@implementation RWWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI{
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"background_login_guide"].CGImage;
    
    UIView *lineView = [[UIView alloc]init];
    
    lineView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(44);
        make.trailing.equalTo(self.view).offset(-44);
        make.height.equalTo(2);
        make.centerY.equalTo(self.view).offset(-100);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"您将免费享受以下服务";
    label1.textColor = kColor;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:18];
    [label1 sizeToFit];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(lineView.top).offset(-30);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"注册登录之后";
    label.numberOfLines = 2;
    label.textColor = kColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(150);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(label1.top).offset(-20);
    }];
  
    //白线一下的label
    UILabel *bottom_label = [[UILabel alloc]init];
    bottom_label.textAlignment = NSTextAlignmentCenter;
    bottom_label.textColor = [UIColor redColor];
    bottom_label.text = @"随时随地,轻松掌握科技动态";
    bottom_label.font = [UIFont systemFontOfSize:15];
    [bottom_label sizeToFit];
    [self.view addSubview:bottom_label];
    [bottom_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(lineView).offset(44);
    }];
    
    UILabel *bottom_label1 = [[UILabel alloc]init];
    bottom_label1.textAlignment = NSTextAlignmentCenter;
    bottom_label1.textColor = [UIColor whiteColor];
    bottom_label1.text = @"社区新闻,每天轻松了解新技术新产品";
    bottom_label1.font = [UIFont systemFontOfSize:13];
    [bottom_label1 sizeToFit];
    [self.view addSubview:bottom_label1];
    [bottom_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(bottom_label).offset(30);
    }];
    
    UILabel *bottom_label3 = [[UILabel alloc]init];
    bottom_label3.textAlignment = NSTextAlignmentCenter;
    bottom_label3.textColor = [UIColor redColor];
    bottom_label3.text = @"海量视频,轻松学习牛X技术";
    bottom_label3.font = [UIFont systemFontOfSize:15];
    [bottom_label3 sizeToFit];
    [self.view addSubview:bottom_label3];
    [bottom_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(bottom_label1).offset(44);
    }];
    
    UILabel *bottom_label4 = [[UILabel alloc]init];
    bottom_label4.textAlignment = NSTextAlignmentCenter;
    bottom_label4.textColor = [UIColor whiteColor];
    bottom_label4.text = @"免费视频,每天吃饭睡觉打豆豆";
    bottom_label4.font = [UIFont systemFontOfSize:13];
    [bottom_label4 sizeToFit];
    [self.view addSubview:bottom_label4];
    [bottom_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(bottom_label3).offset(30);
    }];
    //三个btn
    //register
    UIImage *image = [UIImage imageNamed:@"myButton"];
    UIImage *imagePress = [UIImage imageNamed:@"myButtonPressed"];
    
    imagePress = [imagePress stretchableImageWithLeftCapWidth:imagePress.size.width * 0.5 topCapHeight:imagePress.size.height*0.5];
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    
    UIButton *registerButton = [[UIButton alloc]init];
    [registerButton setBackgroundImage:image forState:UIControlStateNormal];
    [registerButton setBackgroundImage:imagePress forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerButton setTitle:@"注            册" forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    registerButton.layer.cornerRadius = 10;
    registerButton.layer.masksToBounds = YES;
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(bottom_label4.bottom).offset(44);
        make.width.equalTo(220);
        make.height.equalTo(30);
    }];
    [registerButton addTarget:self action:@selector(didClickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    //login
    UIButton *loginButton = [[UIButton alloc]init];
//    [loginButton setBackgroundColor:kColor];

    [loginButton setBackgroundImage:image forState:UIControlStateNormal];
    [loginButton setBackgroundImage:imagePress forState:UIControlStateHighlighted];
    [loginButton setTitle:@"登            录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:loginButton];
    loginButton.layer.cornerRadius = 10;
    loginButton.layer.masksToBounds = YES;
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(registerButton.bottom).offset(22);
        make.width.equalTo(220);
        make.height.equalTo(30);
    }];
    [loginButton addTarget:self action:@selector(didClickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    //直接进入
    UIButton *enterButton = [[UIButton alloc]init];
    [enterButton setBackgroundColor:[UIColor clearColor]];
    [enterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    enterButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [enterButton setTitle:@"直接进入" forState:UIControlStateNormal];
    [self.view addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(loginButton.bottom).offset(22);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    [enterButton addTarget:self action:@selector(didClickEnterButton) forControlEvents:UIControlEventTouchUpInside];

}
-(void)didClickRegisterButton{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RegisterSB" bundle:nil];
    UIViewController *vc = sb.instantiateInitialViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}
-(void)didClickLoginButton{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginSB" bundle:nil];
    UIViewController *vc = sb.instantiateInitialViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}
-(void)didClickEnterButton{
    [self dismissViewControllerAnimated:NO completion:NULL];
    RWTabBarController *vc = [[RWTabBarController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
