//
//  RWLoginController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/27.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWLoginController.h"
#import "RWRegisterController.h"
#import "RWTabBarController.h"
#import "RWWelcomeController.h"
#import "RWNavController.h"
#import "SSKeychain.h"
#import "SVProgressHUD.h"
#import "NSString+MD5.h"

#define kUserNameKey  @"userNameKey"
#define kPassWordKey  @"passWordKey"
#define kAppBundleID @"appBundleID"

@interface RWLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *nametextField;
@property (weak, nonatomic) IBOutlet UITextField *passTexField;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation RWLoginController
- (IBAction)didClickBackButton:(UIBarButtonItem *)sender {
    
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([vc isKindOfClass:[RWNavController class]]) {
        [UIApplication sharedApplication].keyWindow.rootViewController =
        [[RWWelcomeController alloc]init];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nametextField becomeFirstResponder];
     self.view.layer.contents =(__bridge id) [UIImage imageNamed:@"111.jpg"].CGImage;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self loadUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeBtnEnabled) name:UITextFieldTextDidChangeNotification object:self.nametextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeBtnEnabled) name:UITextFieldTextDidChangeNotification object:self.passTexField];
    UIImage *image = [UIImage imageNamed:@"myButton"];
    UIImage *imagePress = [UIImage imageNamed:@"myButtonPressed"];
    
    imagePress = [imagePress stretchableImageWithLeftCapWidth:imagePress.size.width * 0.5 topCapHeight:imagePress.size.height*0.5];
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    
    [self.LoginBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.LoginBtn setBackgroundImage:imagePress forState:UIControlStateHighlighted];
    
    
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (![vc isKindOfClass:[RWNavController class]]) {
        

        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(profileDidClickRegister)];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(profileRegisterSuccess) name:@"profileRegisterSuccess" object:nil];
}
-(void)profileDidClickRegister{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RegisterSB" bundle:nil];
    UIViewController *vc = sb.instantiateInitialViewController;
    [self presentViewController:vc animated:YES completion:NULL];
}
-(void)profileRegisterSuccess{
    
    [SVProgressHUD showWithStatus:@"登录成功,正在为您跳转"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:^(){
            RWTabBarController *vc = [[RWTabBarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    
    }];
    });
}
- (IBAction)didLoginBtn:(id)sender {
    self.LoginBtn.enabled = NO;
    if (self.passTexField.text.length >= 6){
        [SVProgressHUD showWithStatus:@"正在登录"];
    
    [self sendUrlWithUrlString:@"http://115.29.139.232:8080/StudyShip/userAction_login.action"];
    }else{
        [self remindWithMessage:@"密码最少6位哦!"];
        self.passTexField.text = nil;
        [self makeBtnEnabled];
    }
}
-(void)sendUrlWithUrlString:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    request.HTTPMethod=@"POST";
    NSString *body =[NSString stringWithFormat:@"username=%@&password=%@",self.nametextField.text,[self.passTexField.text MD5]];
    request.HTTPBody=[body dataUsingEncoding:NSUTF8StringEncoding];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            [SVProgressHUD dismiss];
            
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            if ([result isEqualToString:@"yes"]) {
                //登录成功保存账号密码
                [self saveUserInfo];
                
                //跳转控制器
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showWithStatus:@"登录成功,正在为您跳转"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        
                        
                        UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                        
                        if ([vc isKindOfClass:[RWNavController class]]) {
                            RWTabBarController *vc = [[RWTabBarController alloc]init];
                            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                        }else{
                            
                            [self dismissViewControllerAnimated:YES completion:^(){
                                RWTabBarController *vc = [[RWTabBarController alloc]init];
                                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                            }];
                            
                        }
                        
                        
                        
                    });
                    
                });
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.LoginBtn.enabled = YES;
                    [self remindWithMessage:@"您输入的用户名或密码不正确"];
                    self.passTexField.text = nil;
                    [self reloadData];
                    
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                self.LoginBtn.enabled = YES;
                [self remindWithMessage:@"请检查网络!"];
                
            });
        }
        
        
    }]resume];
    
    
}
//保存账号
-(void)saveUserInfo{
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    [user setObject:self.nametextField.text forKey:kUserNameKey];
    [user synchronize];
    
    
    [SSKeychain setPassword:self.passTexField.text forService:kAppBundleID account:self.nametextField.text];

}
//读取信息
-(void)loadUserInfo{
    
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    self.nametextField.text = [user objectForKey:kUserNameKey];
    
    self.passTexField.text = [SSKeychain passwordForService:kAppBundleID account:[user objectForKey:kUserNameKey]];
}

//刷新
-(void)reloadData{
    if (!self.nametextField.text.length) {
        self.passTexField.text = nil;
    }
    [self makeBtnEnabled];
}
-(void)remindWithMessage:(NSString *)msm{
    NSString *string = msm;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)makeBtnEnabled{
    self.LoginBtn.enabled = (self.nametextField.text.length && self.passTexField.text.length);
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
