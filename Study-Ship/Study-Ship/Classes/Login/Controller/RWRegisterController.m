//
//  RWRegisterController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/28.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWRegisterController.h"
#import "RWTabBarController.h"
#import "RWWelcomeController.h"
#import "RWNavController.h"
#import "SSKeychain.h"
#import "NSString+MD5.h"
#import "SVProgressHUD.h"

#define kUserNameKey  @"userNameKey"
#define kPassWordKey  @"passWordKey"
#define kAppBundleID @"appBundleID"

@interface RWRegisterController ()
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassTF;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end

@implementation RWRegisterController
- (IBAction)didClickBackBtn:(id)sender {
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([vc isKindOfClass:[RWNavController class]]) {
        [UIApplication sharedApplication].keyWindow.rootViewController =
        [[RWWelcomeController alloc]init];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
- (IBAction)didClickRegisterBtn:(id)sender {
    [SVProgressHUD showWithStatus:@"正在注册"];
    self.registerBtn.enabled = NO;
    
    NSString *pass = self.passTextField.text;
    NSString *repeat = self.repeatPassTF.text;
    if ([pass isEqualToString:repeat]) {
        
        if (self.passTextField.text.length >= 6){
            self.registerBtn.enabled = NO;
            [self sendUrlWithUrlString:@"http://115.29.139.232:8080/StudyShip/userAction_register.action"];
        }else{
            [self remindWithMessage:@"密码最少6位哦!"];
            self.passTextField.text = nil;
            self.repeatPassTF.text = nil;
            [self makeBtnEnabled];
        }
        
        
    }else{
        [self remindWithMessage:@"两次输入的密码不一致,请重新输入!"];
        [SVProgressHUD dismiss];
        self.passTextField.text = nil;
        self.repeatPassTF.text = nil;
        [self makeBtnEnabled];
        [self.passTextField becomeFirstResponder];
        
    }
}
-(void)sendUrlWithUrlString:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    request.HTTPMethod=@"POST";
    NSString *body =[NSString stringWithFormat:@"username=%@&password=%@",self.nameTextField.text,[self.passTextField.text MD5]];
    request.HTTPBody=[body dataUsingEncoding:NSUTF8StringEncoding];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            self.registerBtn.enabled = YES;
            [SVProgressHUD dismiss];
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            if ([result isEqualToString:@"yes"]) {
                //跳转控制器
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showWithStatus:@"注册成功,正在为您跳转"];
                    
                    //登录成功保存账号密码
                    [self saveUserInfo];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                        
                        if ([vc isKindOfClass:[RWNavController class]]) {
                            RWTabBarController *vc = [[RWTabBarController alloc]init];
                            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                        }else{
                            
                            [self dismissViewControllerAnimated:YES completion:^(){
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"profileRegisterSuccess" object:nil];
                            }];
                            
                        }
                        
                    });
                    
                    
                });
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                [self remindWithMessage:@"用户名已经存在,请再取个名字吧!"];
                    self.nameTextField.text = nil;
                    [self makeBtnEnabled];
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.registerBtn.enabled = YES;
                [self remindWithMessage:@"请检查网络!"];
                [self makeBtnEnabled];
                
            });
        }
        
        
    }]resume];
    
    
}
-(void)saveUserInfo{
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    [user setObject:self.nameTextField.text forKey:kUserNameKey];
    [user synchronize];
    
    
    [SSKeychain setPassword:self.passTextField.text forService:kAppBundleID account:self.nameTextField.text];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.contents =(__bridge id) [UIImage imageNamed:@"MJ.jpg"].CGImage;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.nameTextField becomeFirstResponder];
    UIImage *image = [UIImage imageNamed:@"myButton"];
    UIImage *imagePress = [UIImage imageNamed:@"myButtonPressed"];
    
    imagePress = [imagePress stretchableImageWithLeftCapWidth:imagePress.size.width * 0.5 topCapHeight:imagePress.size.height*0.5];
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    [self.registerBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:imagePress forState:UIControlStateHighlighted];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeBtnEnabled) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeBtnEnabled) name:UITextFieldTextDidChangeNotification object:self.passTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeBtnEnabled) name:UITextFieldTextDidChangeNotification object:self.repeatPassTF];
    
}
-(void)makeBtnEnabled{
    self.registerBtn.enabled = ((self.passTextField.text.length && self.nameTextField.text.length)&&self.repeatPassTF.text.length);
}
-(void)remindWithMessage:(NSString *)msm{
    NSString *string = msm;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
   
}
@end
