//
//  ViewController.m
//  Carousel
//
//  Created by 只牵你手 on 2017/3/21.
//  Copyright © 2017年 shazhichao. All rights reserved.
//

#import "ViewController.h"
#import "Carouselview.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Carouselview *scrollView = [[Carouselview alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height) andScrollViewMode:ScrollWithParallax];
    
    scrollView.Intervaltime = 2;
    NSArray *array = @[
                       @"火影01",
                       @"火影02",
                       @"火影03",
                       @"火影04",
                       ];

    
//    [scrollView addImagesArray:array  currentImageClick:^(NSInteger index) {
//        NSLog(@"--->我点的这是第%ld张图片",(long)index);
//    }];
    [scrollView addImagesArray:array currenblock:^(NSUInteger index) {
          NSLog(@"--->我点的这是第%ld张图片",(long)index);
    }];
    
    
    //添加带父视图上
    [self.view addSubview:scrollView];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
