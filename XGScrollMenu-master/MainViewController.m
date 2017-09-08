//
//  MainViewController.m
//  XGScrollMenu-master
//
//  Created by 高昇 on 2017/8/27.
//  Copyright © 2017年 高昇. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"样式%ld",indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *vc = [[ViewController alloc] init];
    switch (indexPath.row) {
        case 0:
            vc.menuType = XGScrollMenuTypeWithOutUnderLine;
            break;
        case 1:
            vc.menuType = XGScrollMenuTypeUnderLineAutoWidth;
            break;
        case 3:
            vc.menuType = XGScrollMenuTypeUnderLineAutoWidth;
            vc.scrollDisabled = YES;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
