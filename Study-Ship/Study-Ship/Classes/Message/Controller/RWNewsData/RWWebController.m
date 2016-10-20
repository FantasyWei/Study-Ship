//
//  RWWebController.m
//  Study-Ship
//
//  Created by ReoWei on 16/4/6.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWWebController.h"
#import <WebKit/WebKit.h>

@interface RWWebController ()<UIWebViewDelegate>
@property(nonatomic,copy) NSString *share_url;
@end

@implementation RWWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *bodyStr = [NSString stringWithFormat:@"uid=2087502&aid=%ld&token=37d2fcd358a9212e00a2198705a72f5b",self.newsData.ids];
    NSString *urlString = @"http://www.imooc.com/api3/articlecomment";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error && !data ) {
            NSLog(@"%@",error);
            return ;
        }
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *dataArr = dataDict[@"data"];
        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            if (dict[@"shareurl"]) {
                self.share_url = dict[@"shareurl"];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.share_url]];
            webView.delegate = self;
            [webView loadRequest:request];
            [self.view addSubview:webView];
        });
    }]resume];

}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('toapp-banner')[0].style.display = 'none'"];
}
@end
