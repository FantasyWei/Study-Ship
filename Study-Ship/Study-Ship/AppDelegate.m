//
//  AppDelegate.m
//  Study-Ship
//
//  Created by ReoWei on 16/1/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "AppDelegate.h"
#import "RWTabBarController.h"
#import "RWNewfutureController.h"
#import "RWWelcomeController.h"
#import "SSKeychain.h"

#define kUserNameKey  @"userNameKey"
#define kPassWordKey  @"passWordKey"
#define kAppBundleID @"appBundleID"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:kScreenFrame];
//    self.window.rootViewController = [self chooseRootViewController];
    self.window.rootViewController = [self chooseRootViewController];
    [self.window makeKeyAndVisible];
    [self saveAppversion];
    
    return YES;
}
-(UIViewController *)chooseRootViewController{
    if ([[self readSavedAppversion]isEqualToString:[self readInfoPlistAppversion]]) {
        NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
        
        NSString *username = [user objectForKey:kUserNameKey];
        
        NSString *password = [SSKeychain passwordForService:kAppBundleID account:username];
        
        if (username && password) {
            //缺   指纹
            RWTabBarController *vc = [[RWTabBarController alloc]init];
            return vc;
        }else{
            RWWelcomeController *vc = [[RWWelcomeController alloc]init];
            return vc;
        }
        
    }else{
        RWNewfutureController *vc = [[RWNewfutureController alloc]init];
        return vc;
    }
}
-(NSString*)readInfoPlistAppversion{
    NSDictionary *info =[NSBundle mainBundle].infoDictionary;
    return info[@"CFBundleShortVersionString"];
}
-(NSString *)readSavedAppversion{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"Appversion"];
}
//保存当前版本号
-(void)saveAppversion{
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    NSString *version = infoDict[@"CFBundleShortVersionString"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:version forKey:@"Appversion"];
    [ud synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
