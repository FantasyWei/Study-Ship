//
//  RWScrollView.m
//  Study-Ship
//
//  Created by ReoWei on 16/3/23.
//  Copyright © 2016年 ReoWei. All rights reserved.
//

#import "RWScrollView.h"
#import "AFHTTPSessionManager.h"
#import "SVProgressHUD.h"
#import "YYWebImage.h"
#import "Masonry.h"

#define kScrollViewSize (self.frame.size)


@interface RWScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,assign) CGFloat imageW;

@end

@implementation RWScrollView
+(instancetype)sharedView{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame: frame]){
        [self setupUI];
        
    }
    return self;
}

-(UIPageControl *)pageControll{
    if (!_pageControll) {
        _pageControll =[[UIPageControl alloc]init];
        
    }
    return _pageControll;
}
-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
-(void)setupUI{
    
    self.delegate = self;
    [self sendHttpRequest];

}
-(void)sendHttpRequest{
    
    NSDictionary *dict = @{@"marking":@"ipbanner",@"token":@"0b620a96c05c99d610ba4ce65b417962",@"uid":@"2087502"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"%@",[NSThread currentThread]);
    [manager POST:@"http://www.imooc.com/api3/getadv" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject!=nil) {
            NSLog(@"%@",[NSThread currentThread]);
            NSData *data = responseObject;
            // 解析json
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSArray *dataArr = [dict objectForKey:@"data"];
            //            NSLog(@"%@",dataArr);
            [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                NSString *image = dict[@"pic"];
                [self.images addObject:image];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupImageView];
                [self setupPageContol];
                [self initTimer];
                
            });
        }
    } failure:NULL];
}
- (void)setupPageContol {
    
    // 设置有几页
    self.pageControll.numberOfPages = self.images.count;
    
    // 当前所在的页码
    self.pageControll.currentPage = 0;
    
    // 设置 指示器的颜色
    // 设置当前指示器的颜色
    self.pageControll.currentPageIndicatorTintColor = [UIColor redColor];
    
    // 设置非当前指示器的颜色
    self.pageControll.pageIndicatorTintColor = [UIColor grayColor];
}
- (void)setupImageView {
   
    
    for (int i = 0; i < self.images.count ; i++) {
        // 计算imageView的x 值
       
        CGFloat imageViewX = i * kScrollViewSize.width;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, 0, kScrollViewSize.width, kScrollViewSize.height)];
        
        //       NSLog(@"%@",NSStringFromCGRect(imageView.frame));
        
        [imageView yy_setImageWithURL:[NSURL URLWithString:self.images[i]] options:YYWebImageOptionShowNetworkActivity]  ;
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self addSubview:imageView];
    }
    
    
    // 设置scrollview的 contentSize
    self.contentSize = CGSizeMake(self.images.count * kScreenWidth, 0);
    
    // 隐藏水平指示器
    self.showsHorizontalScrollIndicator = NO;
    
    // 设置分页效果
    self.pagingEnabled = YES;
    
    _pageControll.currentPage = 0;
}

- (void)changePages {
    // 1. 让scrollView 滚动起来
    
    
    NSInteger currentPage = _pageControll.currentPage;
    
    if (currentPage == self.images.count - 1) {
        // 说明是最后一张图片, 让currentPage 显示到第0个点上
        currentPage = 0;
        
        // 当回到最初位置的时候, offset 的 x = 0, y = 0
        //        offset = CGPointZero;
        
    } else {
        currentPage++;
        
        //        offset.x += kScrollViewSize.width;
    }
    
    // 赋值回去
    _pageControll.currentPage = currentPage;
    
    [self setContentOffset:CGPointMake(currentPage * kScrollViewSize.width, 0) animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 修改 pageControl的 currentPage
    _pageControll.currentPage = scrollView.contentOffset.x / kScrollViewSize.width +0.5 ;
}

// 在用户开始拖拽的时候, 停止计时器, invalidate : 无效
- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView {
    [_timer invalidate];
}

// 用户手指离开屏幕的时候, 开启计时器
- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //    [_timer fire];
    // timer 一旦无效之后, 想再次使用的时候, 就必须重新创建
    
    [self initTimer];
}
/**
 初始化timer
 */
- (void)initTimer {
    
    /**
     interval : 间隔多长时间,调用 selector 对应的方法(changePages)
     target :  selector 的方法属于的对象 (控制器)
     userInfo :  自定义的一些参数
     repeats : 重复 ,
     */
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                              target:self
                                            selector:@selector(changePages)
                                            userInfo:nil
                                             repeats:YES];
    /**
     [_timer fire];
     
     fire 是立即执行的意思, 不会等待 interval 上设置的时间
     */
    
    /**
     系统会优先处理用户交互事件, 当用户交互事件发生的时候, timer就会被暂停
     提高timer的优先级
     */
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    
    [mainLoop addTimer:_timer forMode:NSRunLoopCommonModes];
}

@end
