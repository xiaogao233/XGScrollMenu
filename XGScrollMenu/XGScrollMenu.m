//
//  XGScrollMenu.m
//  XGScrollMenu-master
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "XGScrollMenu.h"
#import "XGScrollMenuFlowLayout.h"

@interface XGScrollMenu ()<UIScrollViewDelegate>

/* 布局设置 */
@property(nonatomic, strong)XGScrollMenuFlowLayout *layout;
/* scrollView */
@property(nonatomic, strong)UIScrollView *scrollView;
/* 下划线 */
@property(nonatomic, strong)UIView *line;
/* 保存标题宽度数组 */
@property(nonatomic, strong)NSMutableArray *titleWidthArray;

@end

@implementation XGScrollMenu

- (instancetype)initWithFrame:(CGRect)frame scrollMenuLayout:(XGScrollMenuFlowLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _layout = layout;
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    self.layer.masksToBounds = YES;
    if (_layout.leftMenuView)
    {
        _layout.leftMenuView.center = CGPointMake(_layout.leftMenuSize.width/2, CGRectGetHeight(self.frame)/2);
        [self addSubview:_layout.leftMenuView];
    }
    if (_layout.rightMenuView)
    {
        _layout.rightMenuView.center = CGPointMake(CGRectGetWidth(self.frame)-_layout.rightMenuSize.width/2, CGRectGetHeight(self.frame)/2);
        [self addSubview:_layout.rightMenuView];
    }
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.line];
    /* 初始化item布局 */
    [self initMenuItemLayout];
    /* 默认第一页为起始页 */
    self.curPageNumb = 0;
}

- (void)initMenuItemLayout
{
    CGFloat offset_x = _layout.leftTitleInterval;
    for (int i = 0; i<_layout.titleArray.count; i++)
    {
        NSString *title = _layout.titleArray[i];
        /* 计算lael宽度 */
        CGFloat labelWidth = [self widthForString:title]+_layout.titleInterval;
        if (_layout.scrollDisabled) labelWidth = CGRectGetWidth(self.frame)/_layout.titleArray.count;
        
        [self.titleWidthArray addObject:[NSNumber numberWithFloat:labelWidth]];
        /* 创建标题视图 */
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(offset_x, 0, labelWidth, CGRectGetHeight(self.scrollView.frame))];
        titleLab.text = title;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = _layout.titleColor;
        titleLab.font = [UIFont fontWithName:_layout.titleFontName size:_layout.titleFontSize];
        titleLab.tag = i+1;
        titleLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapAction:)];
        [titleLab addGestureRecognizer:tap];
        [self.scrollView addSubview:titleLab];
        
        offset_x+=labelWidth;
    }
    offset_x+=_layout.rightTitleInterval;
    self.scrollView.contentSize = CGSizeMake(offset_x, 0);
}

#pragma mark - private
- (CGFloat)widthForString:(NSString *)string
{
    CGRect rect =[string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont fontWithName:_layout.titleFontName size:_layout.titleFontSize]} context:nil];
    return rect.size.width;
}

/**
 滚动到当前页

 @param isManual 是否手动
 */
- (void)scrollMenuToCurPage:(BOOL)isManual
{
    /* 计算scrollMenu的滚动值 */
    CGFloat _menuOffset_x = _layout.leftTitleInterval;
    for (int i = 0; i<_curPageNumb; i++) {
        CGFloat width = [self.titleWidthArray[i] floatValue];
        _menuOffset_x += width;
    }
    /* 滚动居中处理 */
    _menuOffset_x -= (CGRectGetWidth(self.frame)/2-_layout.leftMenuSize.width-[self.titleWidthArray[_curPageNumb] floatValue]/2);
    /* 位置在正中左边，不移动 */
    _menuOffset_x = _menuOffset_x<0?0:_menuOffset_x;
    /* 位置在滚动最大范围中的右边，只滚动到最大值 */
    _menuOffset_x = _menuOffset_x>(self.scrollView.contentSize.width-CGRectGetWidth(self.scrollView.frame))?(self.scrollView.contentSize.width-CGRectGetWidth(self.scrollView.frame)):_menuOffset_x;
    /* 滚动scrollView */
    [_scrollView setContentOffset:CGPointMake(_menuOffset_x, 0) animated:YES];
    /* 移动下划线 */
    [self moveUnderLineWithOffset_x:_curPageNumb*_layout.scrollPageWidth];
    if (_layout.menuType == XGScrollMenuTypeWithOutUnderLine)
    {
        /* 没有下划线的模式，设置选中menu样式 */
        NSInteger curTag = _curPageNumb+1;
        UILabel *curMenu = [self.scrollView viewWithTag:curTag];
        /* 还原所有页面状态 */
        for (UILabel *label in self.scrollView.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.textColor = _layout.titleColor;
                label.transform = CGAffineTransformIdentity;
            }
        }
        if ([curMenu isKindOfClass:[UILabel class]])
        {
            /* 设置当前页状态 */
            CGFloat animationTime = _layout.titleChangeAnimationTime;
            if (!isManual) animationTime = 0;
            [UIView animateWithDuration:animationTime animations:^{
                curMenu.textColor = _layout.selectedTitleColor;
                curMenu.transform = CGAffineTransformMakeScale(1+_layout.fontScale, 1+_layout.fontScale);
            }];
        }
    }
}

/**
 移动下划线

 @param offset_x offset_x
 */
- (void)moveUnderLineWithOffset_x:(CGFloat)offset_x
{
    /* offset异常处理 */
    if (offset_x<=-_layout.scrollPageWidth/2) return;
    /* 计算当前页码 */
    _curPageNumb = [self fetchPageNumb:offset_x];
    /* 计算当前页码的offset定位值 */
    CGFloat curPageOffset_x = _curPageNumb*_layout.scrollPageWidth;
    /* 判断左右滑动 */
    BOOL isMoveRight = YES;
    if (curPageOffset_x>offset_x) isMoveRight = NO;
    /* 当前定位点 */
    CGFloat hasMovedDistance = [self hasMovedDistance:_curPageNumb];
    /* 当前移动距离 */
    CGFloat curMoveDistance = fabs(offset_x-curPageOffset_x);
    /* 计算下一页 */
    NSInteger nextPageNumb = _curPageNumb+1;
    /* 向左移动则下一页为当前页的前一页 */
    if (!isMoveRight) nextPageNumb = _curPageNumb-1;
    if (nextPageNumb>(_layout.titleArray.count-1)) nextPageNumb = (_layout.titleArray.count-1);
    if (nextPageNumb<0) nextPageNumb = 0;
    /* 下一页宽度 */
    CGFloat nextPageWidth = [self.titleWidthArray[nextPageNumb] floatValue];
    /* 当前页的宽度 */
    CGFloat curPageWidth = [self.titleWidthArray[_curPageNumb] floatValue];
    /* 待移动距离 */
    CGFloat moveDistance = (curPageWidth+nextPageWidth)/2;
    /* 实际移动距离 */
    CGFloat distance = curMoveDistance*moveDistance/_layout.scrollPageWidth*2;
    
    /* 寻找offset之间的页码 */
    NSInteger prePage = offset_x/_layout.scrollPageWidth;
    NSInteger nextPage = prePage+1;
    /* 跟前一页比较，计算偏移量 */
    CGFloat offset = offset_x-prePage*_layout.scrollPageWidth;
    /* 计算前一页移动的比例 */
    CGFloat nextScale = offset/_layout.scrollPageWidth;
    if (nextScale<0) nextScale = 0;
    /* 计算后一页移动的比例 */
    CGFloat preScale = 1-nextScale;
    /* 设置滚动字体变化 */
    UILabel *preMenu = [self.scrollView viewWithTag:prePage+1];
    UILabel *nextMenu = [self.scrollView viewWithTag:nextPage+1];
    
    switch (_layout.menuType) {
        case XGScrollMenuTypeUnderLineAutoWidth:
        {
            /* 根据左右滑动分别处理 */
            if (isMoveRight)
            {
                /* 右滑，固定左边，minX值不动 */
                CGFloat curOffser_x = hasMovedDistance+curPageWidth/2-_layout.lineWidth/2;
                self.line.frame = CGRectMake(curOffser_x, CGRectGetMinY(self.line.frame), _layout.lineWidth+distance, CGRectGetHeight(self.line.frame));
            }
            else
            {
                CGFloat max_x = hasMovedDistance+curPageWidth/2-_layout.lineWidth/2;
                /* 左滑，固定右边，maxX值不动 */
                CGFloat curOffser_x = max_x-distance;
                self.line.frame = CGRectMake(curOffser_x, CGRectGetMinY(self.line.frame), _layout.lineWidth+distance, CGRectGetHeight(self.line.frame));
            }
        }
            break;
        case XGScrollMenuTypeUnderLineFixedWidth:
        {
            /* 还原所有页面状态 */
            for (UILabel *label in self.scrollView.subviews) {
                if ([label isKindOfClass:[UILabel class]]) {
                    label.textColor = _layout.titleColor;
                }
            }
            if ([preMenu isKindOfClass:[UILabel class]])
            {
                preMenu.textColor = _layout.titleColor;
                /* 前一页移过的距离 */
                CGFloat preDistance = nextScale*CGRectGetWidth(preMenu.frame);
                /* 改变标题状态 */
                if (preDistance<_layout.changeTitleStateWhenScaleOutWidth)
                {
                    preMenu.textColor = _layout.selectedTitleColor;
                }
            }
            if ([nextMenu isKindOfClass:[UILabel class]])
            {
                /* 后一页移过的距离 */
                CGFloat netxDistance = preScale*CGRectGetWidth(nextMenu.frame);
                /* 改变标题状态 */
                nextMenu.textColor = _layout.titleColor;
                if (netxDistance<_layout.changeTitleStateWhenScaleOutWidth)
                {
                    nextMenu.textColor = _layout.selectedTitleColor;
                }
            }
            CGFloat preLineWidth = CGRectGetWidth(preMenu.frame);
            CGFloat nextLineWidth = CGRectGetWidth(nextMenu.frame);
            /* 下划线改变的宽度 */
            CGFloat changeWidth = nextLineWidth-preLineWidth;
            /* 当前线的宽度 */
            CGFloat lineWidth = preLineWidth+changeWidth*nextScale;
            /* 取小的那一页的位置+大的那一页宽度 */
            NSInteger minPage = prePage<nextPage?prePage:nextPage;
            if (minPage<0) minPage = 0;
            NSInteger maxPage = prePage<nextPage?nextPage:prePage;
            if (maxPage>=_layout.titleArray.count) maxPage = _layout.titleArray.count-1;
            CGFloat minPageOffset_x = [self hasMovedDistance:minPage];
            CGFloat minPageWidth = [self.titleWidthArray[minPage] floatValue];
            CGFloat maxPageWidth = [self.titleWidthArray[maxPage] floatValue];
            /* 待移动距离 */
            CGFloat waitMoveDistance = (minPageWidth+maxPageWidth)/2;
            /* 实际移动距离 */
            CGFloat actualMoveDistance = fabs(offset_x-_layout.scrollPageWidth*minPage)*waitMoveDistance/_layout.scrollPageWidth;
            /* 计算x坐标 */
            CGFloat line_x = minPageOffset_x+actualMoveDistance-changeWidth*nextScale/2;
            self.line.frame = CGRectMake(line_x-_layout.lineScaleOutWidth, CGRectGetMinY(self.line.frame), lineWidth+2*_layout.lineScaleOutWidth, CGRectGetHeight(self.line.frame));
        }
            break;
        default:
        {
            if ([preMenu isKindOfClass:[UILabel class]])
            {
                /* 前一页 */
                preMenu.transform = CGAffineTransformIdentity;
                preMenu.transform = CGAffineTransformMakeScale(1+_layout.fontScale*preScale, 1+_layout.fontScale*preScale);
                preMenu.textColor = [_layout fetchChangedColor:preScale];
            }
            if ([nextMenu isKindOfClass:[UILabel class]])
            {
                /* 后一页 */
                nextMenu.transform = CGAffineTransformIdentity;
                nextMenu.transform = CGAffineTransformMakeScale(1+_layout.fontScale*nextScale, 1+_layout.fontScale*nextScale);
                nextMenu.textColor = [_layout fetchChangedColor:nextScale];
            }
        }
            break;
    }
}

/**
 根据当前contentOffset获取所在页码

 @param offset_x contentOffset
 @return 所在页码
 */
- (NSInteger)fetchPageNumb:(CGFloat)offset_x
{
    NSInteger pageNumb = round(offset_x/_layout.scrollPageWidth);
    /* 越界处理 */
    pageNumb = pageNumb>(_layout.titleArray.count-1)?(_layout.titleArray.count-1):pageNumb;
    pageNumb = pageNumb<0?0:pageNumb;
    return pageNumb;
}

/**
 根据页码，获取已经移动的距离

 @param pageNumb 页码
 @return CGFloat
 */
- (CGFloat)hasMovedDistance:(NSInteger)pageNumb
{
    CGFloat offset_x = _layout.leftTitleInterval;
    for (int i = 0; i<pageNumb; i++) {
        CGFloat width = [self.titleWidthArray[i] floatValue];
        offset_x += width;
    }
    return offset_x;
}

- (void)scrollMenuDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_x = scrollView.contentOffset.x;
    /* 移动下滑线 */
    [self moveUnderLineWithOffset_x:offset_x];
}

- (void)scrollMenuDidEndDecelerating:(UIScrollView *)scrollView
{
    /* 滚动到当前页 */
    [self scrollMenuToCurPage:NO];
}

#pragma mark - action
- (void)menuTapAction:(UITapGestureRecognizer *)tap
{
    NSInteger pageNumb = tap.view.tag-1;
    if (pageNumb == _curPageNumb) return;
    BOOL isExitAnimation = NO;
    if ([self.delegate respondsToSelector:@selector(scrollMenuDidSelectedMenu:)]) {
        isExitAnimation = [self.delegate scrollMenuDidSelectedMenu:pageNumb];
    }
    if (!isExitAnimation) self.curPageNumb = pageNumb;
}

#pragma mark - setting方法
- (void)setCurPageNumb:(NSInteger)curPageNumb
{
    _curPageNumb = curPageNumb;
    [self scrollMenuToCurPage:YES];
}

#pragma mark - lazy
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_layout.leftMenuSize.width, 0, CGRectGetWidth(self.frame)-_layout.leftMenuSize.width-_layout.rightMenuSize.width, CGRectGetHeight(self.frame))];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = _layout.backgroundColor;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-_layout.lineBottomEdge-_layout.lineHeight, _layout.lineWidth, _layout.lineHeight)];
        _line.backgroundColor = _layout.lineColor;
        _line.layer.cornerRadius = _layout.lineCornerRadius;
        if (_layout.menuType == XGScrollMenuTypeWithOutUnderLine) _line.hidden = YES;
    }
    return _line;
}

- (NSMutableArray *)titleWidthArray
{
    if (!_titleWidthArray) {
        _titleWidthArray = [NSMutableArray array];
    }
    return _titleWidthArray;
}

@end
