//
//  Carouselview.h
//  Carousel
//
//  Created by 只牵你手 on 2017/3/21.
//  Copyright © 2017年 shazhichao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ScrollWithDefault = 1,//默认情况..最常见的一屏一屏滚动
    ScrollWithParallax,//有视差的滚动
} ScrollViewMode ;

typedef void (^CurrentImageClick)(NSUInteger index);
@interface Carouselview : UIView
//定时器
@property (nonatomic, strong) NSTimer *timer;
//计时器的间隔时间
@property (nonatomic, assign) CGFloat Intervaltime;
//滚动视图的样式
@property (nonatomic, assign) ScrollViewMode    scrollViewMode;
@property(nonatomic, copy)CurrentImageClick  currenblock;

- (instancetype)initWithFrame:(CGRect)frame andScrollViewMode:(ScrollViewMode)scrollViewMode;
- (void)addImagesArray:(NSArray *)imagesArray  currenblock:(CurrentImageClick)currenblock;


/**
 *  添加一个时间控制器(用于手动控制)
 */
- (void)addTimer;
/**
 *  清除事件控制器(用于手动控制)
 */
- (void)clearTimer;
@end
