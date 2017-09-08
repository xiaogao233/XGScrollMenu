//
//  ViewController.m
//  XGScrollMenu-master
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate, XGScrollMenuDelegate>

@property(nonatomic, strong)UIScrollView *mainScrollView;
@property(nonatomic, strong)XGScrollMenu *scrollMenu;
@property(nonatomic, strong)NSArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)initLayout
{
    self.view.backgroundColor = [UIColor redColor];
    
    _titleArray = @[@"第一页",@"二页",@"三",@"第四页",@"第五页",@"六页",@"七",@"这是第八页",@"九",@"十页"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-1)/2, 0, 1, 64)];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.scrollMenu];
    
    NSArray *colorArray = @[[UIColor yellowColor],[UIColor redColor],[UIColor orangeColor],[UIColor greenColor]];
    
    for (int i = 0; i<_titleArray.count; i++) {
        UIColor *color = colorArray[i%4];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.view.frame), 0, CGRectGetHeight(self.view.frame), CGRectGetHeight(self.view.frame))];
        view.backgroundColor = color;
        [self.mainScrollView addSubview:view];
    }
}

#pragma mark - scrollview - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollMenu scrollMenuDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.scrollMenu scrollMenuDidEndDecelerating:scrollView];
}

- (BOOL)scrollMenuDidSelectedMenu:(NSInteger)index
{
    [self.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*index, 0) animated:YES];
    return YES;
}

#pragma marl - lazy
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45+64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-45)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.delegate = self;
        _mainScrollView.contentSize = CGSizeMake(_titleArray.count*CGRectGetWidth(self.view.frame), 0);
    }
    return _mainScrollView;
}

- (XGScrollMenu *)scrollMenu
{
    if (!_scrollMenu) {
        XGScrollMenuFlowLayout *layout = [[XGScrollMenuFlowLayout alloc] initWithMenuType:self.menuType];
        layout.titleArray = _titleArray;
        layout.scrollDisabled = self.scrollDisabled;
        
        _scrollMenu = [[XGScrollMenu alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 45) scrollMenuLayout:layout];
        _scrollMenu.delegate = self;
    }
    return _scrollMenu;
}

@end
