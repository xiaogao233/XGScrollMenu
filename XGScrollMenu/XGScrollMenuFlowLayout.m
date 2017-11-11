//
//  XGScrollMenuFlowLayout.m
//  XGScrollMenu-master
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "XGScrollMenuFlowLayout.h"

@interface XGScrollMenuFlowLayout ()

/* R原始值 */
@property(nonatomic, assign)CGFloat normalR;
/* G原始值 */
@property(nonatomic, assign)CGFloat normalG;
/* B原始值 */
@property(nonatomic, assign)CGFloat normalB;
/* Alpha原始值 */
@property(nonatomic, assign)CGFloat normalAlpha;
/* R改变值 */
@property(nonatomic, assign)CGFloat changedR;
/* G改变值 */
@property(nonatomic, assign)CGFloat changedG;
/* B改变值 */
@property(nonatomic, assign)CGFloat changedB;
/* Alpha改变值 */
@property(nonatomic, assign)CGFloat changedAlpha;

@end

@implementation XGScrollMenuFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _titleArray = [NSArray array];
        _leftMenuSize = CGSizeZero;
        _rightMenuSize = CGSizeZero;
        _lineBottomEdge = 0;
        _lineHeight = 2;
        _lineWidth = 10;
        _lineColor = [self colorWithHexString:@"#FF5005"];
        _lineCornerRadius = _lineHeight/2;
        _titleInterval = 24;
        _leftTitleInterval = 0;
        _rightTitleInterval = 0;
        _titleFontSize = 14;
        _selectedFontSize = 19;
        _titleFontName = [UIFont systemFontOfSize:14].fontName;
        _titleColor = [self colorWithHexString:@"#4a4a4a"];
        _selectedTitleColor = [self colorWithHexString:@"#FF5005"];
        _scrollPageWidth = [UIScreen mainScreen].bounds.size.width;
        _backgroundColor = [UIColor whiteColor];
        _lineScaleOutWidth = 0;
        _fontScale = _selectedFontSize/_titleFontSize-1;
        _titleChangeAnimationTime = 0.15;
        _changeTitleStateWhenScaleOutWidth = 8;
        _autoJudgeEnable = YES;
        switch (_menuType) {
            case XGScrollMenuTypeWithOutUnderLine:
            {
                _titleInterval = 27;
            }
                break;
            case XGScrollMenuTypeUnderLineAutoWidth:
            {
                _titleFontSize = 16;
                _lineBottomEdge = 7;
            }
                break;
            default:
                break;
        }
        [self resetChangedRGB];
    }
    return self;
}

/**
 构造方法
 
 @param menuType 样式类型
 @return instancetype
 */
- (instancetype)initWithMenuType:(XGScrollMenuType)menuType
{
    _menuType = menuType;
    return [self init];
}

#pragma mark - setting方法
- (void)setLeftMenuView:(UIView *)leftMenuView
{
    _leftMenuView = leftMenuView;
    _leftMenuSize = _leftMenuView.frame.size;
}

- (void)setRightMenuView:(UIView *)rightMenuView
{
    _rightMenuView = rightMenuView;
    _rightMenuSize = _rightMenuView.frame.size;
}

- (void)setTitleFontSize:(CGFloat)titleFontSize
{
    _titleFontSize = titleFontSize;
    _fontScale = _selectedFontSize/_titleFontSize-1;
}

- (void)setSelectedFontSize:(CGFloat)selectedFontSize
{
    _selectedFontSize = selectedFontSize;
    _fontScale = _selectedFontSize/_titleFontSize-1;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self resetChangedRGB];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    [self resetChangedRGB];
}

+ (instancetype)defaultFlowLayout
{
    return [[XGScrollMenuFlowLayout alloc] init];
}

/**
 获取改变颜色
 
 @param scale 比例
 @return UIColor
 */
- (UIColor *)fetchChangedColor:(CGFloat)scale
{
    return [UIColor colorWithRed:_normalR+_changedR*scale green:_normalG+_changedG*scale blue:_normalB+_changedB*scale alpha:_normalAlpha+_changedAlpha*scale];
}

#pragma mark - private
/**
 *  16进制转换成color
 *
 *  @param colorStr 字体的颜色值
 *
 *  @return UIColor
 */
- (UIColor *)colorWithHexString:(NSString *)colorStr
{
    colorStr = [colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (colorStr.length == 3)
        colorStr = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                    [colorStr characterAtIndex:0], [colorStr characterAtIndex:0],
                    [colorStr characterAtIndex:1], [colorStr characterAtIndex:1],
                    [colorStr characterAtIndex:2], [colorStr characterAtIndex:2]];
    if (colorStr.length == 6)
    {
        int r, g, b;
        sscanf([colorStr UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
    }
    return nil;
}

- (void)resetChangedRGB
{
    _normalR = 0;
    _normalG = 0;
    _normalB = 0;
    _normalAlpha = 1;
    CGColorRef normalColor = [_titleColor CGColor];
    NSInteger normalNumComponents = CGColorGetNumberOfComponents(normalColor);
    
    if (normalNumComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(normalColor);
        _normalR = components[0];
        _normalG = components[1];
        _normalB = components[2];
        _normalAlpha = components[3];
    }
    
    CGFloat selectedR = 0;
    CGFloat selectedG = 0;
    CGFloat selectedB = 0;
    CGFloat selectedAlpha = 1;
    CGColorRef selectedColor = [_selectedTitleColor CGColor];
    NSInteger selectedNumComponents = CGColorGetNumberOfComponents(selectedColor);
    
    if (selectedNumComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(selectedColor);
        selectedR = components[0];
        selectedG = components[1];
        selectedB = components[2];
        selectedAlpha = components[3];
    }
    
    _changedR = selectedR-_normalR;
    _changedG = selectedG-_normalG;
    _changedB = selectedB-_normalB;
    _changedAlpha = selectedAlpha-_normalAlpha;
}

@end

