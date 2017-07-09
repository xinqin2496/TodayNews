//
//  WQGifHeader.m
//  Swift3.0Test
//
//  Created by 郑文青 on 2017/5/21.
//  Copyright © 2017年 zhengwenqing’s mac. All rights reserved.
//

#import "WQGifHeader.h"
#import "UIImageView+JWWebCache.h"

@interface WQGifHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *gifImageView;
@end

@implementation WQGifHeader

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 60;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [self addSubview:label];
    self.label = label;
    
    //添加 GIF 图
    NSString  *name = @"reload.gif";
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImageView *gifImageView = [[UIImageView alloc]init];
    gifImageView.image = [UIImage jw_gifWithData:imageData];
    gifImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:gifImageView];
    self.gifImageView = gifImageView;
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = CGRectMake(0, 40, self.bounds.size.width, 20);
    
    self.gifImageView.frame = CGRectMake((self.bounds.size.width - 30 ) * 0.5, 10, 30, 30);
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"下拉推荐";
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开推荐";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"推荐中";
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}

@end
