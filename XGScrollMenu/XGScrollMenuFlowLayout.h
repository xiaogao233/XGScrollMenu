//
//  XGScrollMenuFlowLayout.h
//  XGScrollMenu-master
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 展示类型

 - XGScrollMenuTypeUnderLineFixedWidth: 固定下划线宽度
 - XGScrollMenuTypeUnderLineAutoWidth: 下划线宽度自适应
 - XGScrollMenuTypeWithOutUnderLine: 不展示下划线
 */
typedef NS_ENUM(NSInteger, XGScrollMenuType) {
    XGScrollMenuTypeUnderLineFixedWidth,
    XGScrollMenuTypeUnderLineAutoWidth,
    XGScrollMenuTypeWithOutUnderLine
};

@interface XGScrollMenuFlowLayout : NSObject

#pragma mark - 公用属性
/* 标题数据源 */
@property(nonatomic, strong)NSArray *titleArray;
/* 展示类型 */
@property(nonatomic, assign, readonly)XGScrollMenuType menuType;
/* 左侧菜单按钮 */
@property(nonatomic, strong)UIView *leftMenuView;
/* 右侧菜单按钮 */
@property(nonatomic, strong)UIView *rightMenuView;
/* 下划线距底部的距离 */
@property(nonatomic, assign)CGFloat lineBottomEdge;
/* 下划线高度 */
@property(nonatomic, assign)CGFloat lineHeight;
/* 下划线宽度 */
@property(nonatomic, assign)CGFloat lineWidth;
/* 下划线颜色 */
@property(nonatomic, strong)UIColor *lineColor;
/* 下划线圆角大小 */
@property(nonatomic, assign)CGFloat lineCornerRadius;
/* 下划线超文字的距离，只针对固定宽度有效 */
@property(nonatomic, assign)CGFloat lineScaleOutWidth;
/* 超出一定距离改变标题状态 */
@property(nonatomic, assign)CGFloat changeTitleStateWhenScaleOutWidth;
/* 文字间隔 */
@property(nonatomic, assign)CGFloat titleInterval;
/* 最左边文字的边距 */
@property(nonatomic, assign)CGFloat leftTitleInterval;
/* 最右边文字的边距 */
@property(nonatomic, assign)CGFloat rightTitleInterval;
/* 标题font */
@property(nonatomic, assign)CGFloat titleFontSize;
/* 标题font */
@property(nonatomic, strong)NSString *titleFontName;
/* 标题选中文字大小 */
@property(nonatomic, assign)CGFloat selectedFontSize;
/* 标题文字颜色 */
@property(nonatomic, strong)UIColor *titleColor;
/* 选中状态文字颜色 */
@property(nonatomic, strong)UIColor *selectedTitleColor;
/* 联动滚动页的宽度，默认屏幕宽度 */
@property(nonatomic, assign)CGFloat scrollPageWidth;
/* 背景颜色 */
@property(nonatomic, strong)UIColor *backgroundColor;
/* 标题切换动画时间 */
@property(nonatomic, assign)CGFloat titleChangeAnimationTime;
/* 禁止滚动，标题平分 */
@property(nonatomic, assign)BOOL scrollDisabled;

#pragma mark - 配置只读属性
/* 左侧菜单size */
@property(nonatomic, assign, readonly)CGSize leftMenuSize;
/* 右侧菜单size */
@property(nonatomic, assign, readonly)CGSize rightMenuSize;
/* 字体缩放比例 */
@property(nonatomic, assign, readonly)CGFloat fontScale;

/**
 默认构造样式

 @return instancetype
 */
+ (instancetype)defaultFlowLayout;

/**
 构造方法
 
 @param menuType 样式类型
 @return instancetype
 */
- (instancetype)initWithMenuType:(XGScrollMenuType)menuType;

/**
 获取改变颜色
 
 @param scale 比例
 @return UIColor
 */
- (UIColor *)fetchChangedColor:(CGFloat)scale;

@end
