//
//  RWNewfutureController.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/27.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWNewfutureController.h"
#import "RWTabBarController.h"
#import "RWWelcomeController.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>
#import "SSKeychain.h"

#define kUserNameKey  @"userNameKey"
#define kPassWordKey  @"passWordKey"
#define kAppBundleID @"appBundleID"

#define kVideoCount 3

@interface RWNewfutureController ()<UIScrollViewDelegate>
@property(nonatomic,weak) UIScrollView  *scroll;
@property(nonatomic,strong) NSMutableDictionary *players;
@property(nonatomic,weak) UIPageControl *pageControll;
@end

@implementation RWNewfutureController
-(NSMutableDictionary *)players{
    if (!_players) {
        _players = [NSMutableDictionary dictionaryWithCapacity:kVideoCount];
    }
    return _players;
}
-(AVPlayerItem *)getPlayItem:(int )videoIndex{
    NSString *Str=[NSString stringWithFormat:@"welcome_%d.mp4",videoIndex];
    NSURL *url=[[NSBundle mainBundle]URLForResource:Str withExtension:nil];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:kScreenFrame];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.delegate = self;
    self.scroll = scroll;
    self.scroll.bounces = NO;
    [self.view addSubview:scroll];
    [self loadVideos];
    
    [self addPageControl];
    
}
-(void)addPageControl{
    UIPageControl *page = [[UIPageControl alloc]init];
    [self.view addSubview:page];
    [self.view bringSubviewToFront:page];
    self.pageControll = page;
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.bottom).offset(-44);
    }];
    // 设置有几页
    _pageControll.numberOfPages = kVideoCount;
    
    // 当前所在的页码
    _pageControll.currentPage = 0;
    
    // 设置当前指示器的颜色
    _pageControll.currentPageIndicatorTintColor = kColor;
    
    // 设置非当前指示器的颜色
    _pageControll.pageIndicatorTintColor = [UIColor grayColor];
}
-(void)loadVideos{
    
    for (int i=0; i<kVideoCount; i++) {
        CGFloat ViewX = i * kScreenWidth ;
        
        NSString *imageStr = [NSString stringWithFormat:@"welcome_%d",i];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageStr]];
        
        imageView.frame = kScreenFrame;
        
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(ViewX, 0, kScreenWidth, kScreenHeight)];
        
        [self.scroll addSubview:view];
        
     
        AVPlayerItem *playerItem=[self getPlayItem:i];
        
        AVPlayer *player=[AVPlayer playerWithPlayerItem:playerItem];
        
        AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
        // 为防止三个视频播放同时停止，为三个播放视频分别存储
        [self.players setValue:player forKey:[NSString stringWithFormat:@"%@",urlAsset.URL]];
        
        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.frame=kScreenFrame;
        playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
        [view.layer addSublayer:playerLayer];
        [playerLayer addSublayer:imageView.layer];
        //视频播放完成发送通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
        //播放视频
        [player play];
        if (i == kVideoCount -1) {
            //进入btn
            UIButton* enterButton = [[UIButton alloc] init];
            
            [enterButton setTitle:@"立即进入->" forState:UIControlStateNormal];
            enterButton.layer.cornerRadius = 5;
            enterButton.layer.masksToBounds = YES;
            // 设置背景图片
            [enterButton setBackgroundColor:kColor];
            
            // 设置大小和图片一样大
            [enterButton sizeToFit];
            [view addSubview:enterButton];
            //            [view bringSubviewToFront:enterButton];
            [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.centerY.equalTo(view.bottom).offset(-100);
                make.width.equalTo(150);
                make.height.equalTo(30);
            }];
            [enterButton addTarget:self action:@selector(enterButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.scroll.contentSize = CGSizeMake(kVideoCount * kScreenWidth, 0);
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.pagingEnabled = YES;
}
-(void)didFinishPlay:(NSNotification *)notify{
    AVPlayerItem *item = notify.object;
    AVURLAsset *urlAsset = (AVURLAsset *)item.asset;
    AVPlayer *player =(AVPlayer *) [self.players valueForKey:[NSString stringWithFormat:@"%@",urlAsset.URL]];
    [player seekToTime:CMTimeMake(0, 1)];
    [player play];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControll.currentPage = scrollView.contentOffset.x / kScreenWidth + 0.5;
}
-(void)enterButtonClick{
//    NSLog(@"新特性展示完毕,切换控制器");
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    NSString *username = [user objectForKey:kUserNameKey];
    
    NSString *password = [SSKeychain passwordForService:kAppBundleID account:username];
    
    if (username && password) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[RWTabBarController alloc]init];
    }else{
    [UIApplication sharedApplication].keyWindow.rootViewController =
        [[RWWelcomeController alloc]init];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
