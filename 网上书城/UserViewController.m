//
//  UserViewController.m
//  网上书城
//
//  Created by happy on 2016/11/28.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "UserViewController.h"
#import "MyHeaderView.h"
#import "Masonry.h"

@interface UserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MyHeaderView *headerView;     // 上面蓝色的 view，可以自定义
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGFloat headerViewHeight;     // headerView 高度
@property (strong, nonatomic) UIButton *btnBack;
@end

@implementation UserViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.sectionHeaderHeight = 20;
        //        _tableView.showsVerticalScrollIndicator = false;
        
        // 占位用的 view，高度 180
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.headerViewHeight)];
        view.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = view;
        
    }
    return _tableView;
}
-(UIButton *)btnBack{
    if (_btnBack == nil) {
        _btnBack = [[UIButton alloc] init];
        [_btnBack setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    }
    return _btnBack;
}

// 蓝色的 headerView
- (MyHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[MyHeaderView alloc] init];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerViewHeight = 220;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@(0));
    }];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@(0));
        make.height.equalTo(@(self.headerViewHeight));
    }];
    [self.view addSubview:self.btnBack];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(@(100));
    }];
}

// 监听 tableView.contentOffset，也可以用 kvo 监听
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGRect frame = self.headerView.frame;
    if (offsetY < 0) {
        frame.size.height = self.headerViewHeight - offsetY;
        frame.origin.y = 0;             // 及时归零
    } else {
        frame.size.height = self.headerViewHeight;
        frame.origin.y = -offsetY;
    }
    self.headerView.frame = frame;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// --------------------------- 以下代码不是实验重点 ---------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
        cell.textLabel.text = @"hello world";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterViewID"];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterViewID"];
        view.contentView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];;
    }
    return view;
}



@end
