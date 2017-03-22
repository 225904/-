//
//  Carouselview.m
//  Carousel
//
//  Created by 只牵你手 on 2017/3/21.
//  Copyright © 2017年 shazhichao. All rights reserved.
//

#import "Carouselview.h"
@interface Carouselview ()<UIScrollViewDelegate>
{   //是否是本地数据
    BOOL _isLocalImagesArray;
    //记录当前图片下标
    int _currentImageIndex;
    //记录下一张图片下标
    int _nextImageIndex;
}

@property(nonatomic,strong)UIScrollView *ScrollView;
//第一个图片
@property (nonatomic, strong) UIImageView *firstImageView;
//第二个图片
@property (nonatomic, strong) UIImageView *secondImageView;
//第三个图片
@property (nonatomic, strong) UIImageView *thirdImageView;
//图片数组
@property (nonatomic, strong) NSMutableArray *imageData;


@property(nonatomic,strong)UIPageControl *Page;

@end
@implementation Carouselview

- (instancetype)initWithFrame:(CGRect)frame andScrollViewMode:(ScrollViewMode)scrollViewMode{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollViewMode = scrollViewMode;
        [self initScrollViewview];
    }
    return self;
}

- (void)addImagesArray:(NSArray *)imagesArray  currenblock:(CurrentImageClick)currenblock{
    self.currenblock = currenblock;
    // 判断是否是本地图片
    _isLocalImagesArray = NO;
    self.imageData = [[NSMutableArray alloc] init];
    for (int i = 0; i<imagesArray.count; i++) {
        UIImage *image = [UIImage imageNamed:imagesArray[i]];
        if (!image) {
            continue;
        }
        _isLocalImagesArray = YES;
        //如果是本地图片,则把数组中的图片名,转化成图片保存到图片数据源数组中
        [self.imageData addObject:image];
    }
    
    if (self.imageData.count==0) {
        //如果是网络图片,则把图片链接地址添加到图片数据源数组中
        self.imageData = [NSMutableArray arrayWithArray:imagesArray];
    }
  //page页数
    self.Page.numberOfPages = self.imageData.count;
    
  
    [self addTimer];
    
    [self addNextImageWith:self.firstImageView WithImageIndex:_currentImageIndex];
}
- (void)addNextImageWith:(UIImageView *)imageView WithImageIndex:(NSInteger)imageIndex;
{
    if (_isLocalImagesArray) {
        //添加将要出现视图的本地图片
        imageView.image = self.imageData[imageIndex];
    }else{
        //添加将要出现视图的网络图片
//        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageData[imageIndex]]];
    }
}


 //sc初始化
-(void)initScrollViewview{
    _currentImageIndex = 0;
    
    self.ScrollView =[[UIScrollView alloc] initWithFrame:self.bounds];
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.delegate = self;
    self.ScrollView.clipsToBounds = NO;
    [self addSubview:self.ScrollView];
    
    UITapGestureRecognizer *tapges =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureRecognizer:)];
    [self.ScrollView addGestureRecognizer:tapges];
    
    //添加两个imageview
    //为实现类型二 需要先添加secondImageView
    self.secondImageView =[[UIImageView alloc] initWithFrame:self.bounds];
    [self.ScrollView addSubview:self.secondImageView];
    
    self.firstImageView =[[UIImageView alloc] initWithFrame:self.bounds];
    [self.ScrollView addSubview:self.firstImageView];
    
  
    
    //设置sc初始化时的contentOffset与contentSize
    self.ScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    self.ScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame));
    //设置第一个imageview的 位置
    self.firstImageView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    //设置page
    self.Page =[[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 30)];
    self.Page.pageIndicatorTintColor = [UIColor redColor];
    self.Page.currentPageIndicatorTintColor =[UIColor greenColor];
    self.Page.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)-30);
     self.Page.numberOfPages = self.imageData.count;
    self.Page.currentPage = 0;
    [self addSubview:self.Page];
    
}
//点击事件
-(void)TapGestureRecognizer:(UITapGestureRecognizer *)tap{
    if (self.currenblock) {
        self.currenblock(_currentImageIndex+1);
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self ScrollWithParallaxAddImageViewWith:scrollView.contentOffset.x];
}
- (void)ScrollWithParallaxAddImageViewWith:(float)offsetX{
    //添加将要出现的视图的中心点X坐标
    static float nextImageViewCenterX = 0.f;
    //判断滚动方向
    if (offsetX < CGRectGetWidth(self.frame)) {
        //从左往右
        if (self.scrollViewMode == ScrollWithDefault) {
            nextImageViewCenterX = CGRectGetWidth(self.frame)/ 2;
        }else{
            nextImageViewCenterX = (CGRectGetWidth(self.frame)  + offsetX) / 2;
        }
        _nextImageIndex = _currentImageIndex - 1;
    }
    else if (offsetX > CGRectGetWidth(self.frame)){
        //从右往左
        if (self.scrollViewMode ==ScrollWithDefault) {
            nextImageViewCenterX = CGRectGetWidth(self.frame) * 2.5f;
        }else{
            nextImageViewCenterX = (CGRectGetWidth(self.frame) * 3 + offsetX) / 2;
        }
        _nextImageIndex = _currentImageIndex + 1;
    }else{
        nextImageViewCenterX = CGRectGetWidth(self.frame) / 2;
    }
    
    //这块是完成轮播的关键(比如有四张图片:一二三四,轮播的排列是这样的:四一二三四一)
    if (_nextImageIndex == -1) {
        _nextImageIndex = (int)self.imageData.count - 1;
    }else if (_nextImageIndex == self.imageData.count){
        _nextImageIndex = 0;
    }
    //添加将要出现的图片
    [self addNextImageWith:self.secondImageView WithImageIndex:_nextImageIndex];
    //设置将要出现图片的中心点
    CGPoint center = CGPointMake(nextImageViewCenterX , CGRectGetHeight(self.frame)/2);
    self.secondImageView.center = center ;
}
// 滑动停止调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endRollScrollViewWith:scrollView];
}
// 滑动动画结束 setContentOffset: animated:YES 动画结束调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self endRollScrollViewWith:scrollView];
}
//结束滚动后,重置页面
-(void)endRollScrollViewWith:(UIScrollView *)scrollView
{
    //判断是否完成翻页
    
        if (scrollView.contentOffset.x != CGRectGetWidth(self.frame)) {
            //更新当前图片下标
            _currentImageIndex = _nextImageIndex;
            //给第一张相框添加图片
            [self addNextImageWith:self.firstImageView WithImageIndex:_nextImageIndex];
            //让视图回到self.ScrollView中间位置
           
                 [self.ScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
          
           //设置page
            self.Page.currentPage = _currentImageIndex;
        }
   
}

//添加一个时间控制器
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.Intervaltime target:self selector:@selector(rollImages) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)rollImages{
    if (self.imageData.count ==0) {
        return;
    }
    [self.ScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*2, 0) animated:YES];
}
//清除时间控制器
- (void)clearTimer
{
    [_timer invalidate];
    _timer = nil;
}

//手动拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动的时候,清除时间控制器
    [self clearTimer];
}
//结束拖动的时候,新增时间控制器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
@end
