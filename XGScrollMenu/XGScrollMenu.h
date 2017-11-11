//
//  XGScrollMenu.h
//  XGScrollMenu-master
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGScrollMenuFlowLayout.h"

@protocol XGScrollMenuDelegate <NSObject>

/**
 点击menu菜单的点击回调
 
 @param index 当前点击menu
 @return 主页面的scrollView是否有滚动动画，必须一致，不一致会导致显示异常
 */
- (BOOL)scrollMenuDidSelectedMenu:(NSInteger)index;

@end

@interface XGScrollMenu : UIView

/* 当前页码 */
@property(nonatomic, assign)NSInteger curPageNumb;
/* 代理 */
@property(nonatomic, weak)id<XGScrollMenuDelegate> delegate;

/**
 构造方法
 
 @param frame 视图Frame
 @param layout 配置信息
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame scrollMenuLayout:(XGScrollMenuFlowLayout *)layout;

/**
 在scrollViewDidScroll中执行
 
 @param scrollView 滚动视图
 */
- (void)scrollMenuDidScroll:(UIScrollView *)scrollView;

/**
 在scrollViewDidEndDecelerating中执行
 
 @param scrollView 滚动视图
 */
- (void)scrollMenuDidEndDecelerating:(UIScrollView *)scrollView;

@end

