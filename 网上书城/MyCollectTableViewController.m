//
//  MyCollectTableViewController.m
//  网上书城
//
//  Created by happy on 2017/1/8.
//  Copyright © 2017年 wumiaomiao. All rights reserved.
//

#import "MyCollectTableViewController.h"
#import "MyCollectTableViewCell.h"
#import "ToolController.h"
#import "Contents.h"
#import "MBProgressHUD.h"

@interface MyCollectTableViewController ()
//**************************     UI控件声明   ***************************
@property (strong, nonatomic) IBOutlet UITextField *txtField;

@property (strong,nonatomic) MBProgressHUD *HUD;//提示窗口的声明
//**************************     自定义方法属性声明   ***************************
@property(nonatomic,strong)NSMutableArray* allDataArrForCollect;
@property(nonatomic,strong)NSString* UserId;

@end

@implementation MyCollectTableViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:RGB(40, 43, 53)}];
    self.navigationController.navigationBar.tintColor  = RGB(40, 43, 53);
    //设置单元格文本框
    self.txtField.hidden = YES;
    self.txtField.delegate = self;
    
    //初始化下拉刷新 UIrefreshControl控件
    UIRefreshControl *rc = [[UIRefreshControl alloc]init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
    [rc addTarget:self action:@selector(refreshtableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    //读取存在本地的文件
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:@"UserId"];
    //调用外部的工具方法
    ToolController *tool;
    tool = [[ToolController alloc]init];
    
    if(!(userId == nil)){
        self.UserId = userId;
        //已经登录了用户的话 开始从服务器拉取数据
        NSString *str = [[NSString alloc] initWithFormat:@"/GetUserCollect?userId=%@",self.UserId];
        self.allDataArrForCollect = [[tool getDataWith:str] objectForKey:@"GetCollectList"];
        //        NSLog(@"%@",self.allDataArrForCollect);
        
    }else{
        [self ShowMessageWith:@"请先登录"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView 代理方法
//TableView 每节有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allDataArrForCollect count];
}
//当选中这一行需要做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//TableView每一行做了什么
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"MyCollectCellID";
    MyCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[MyCollectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *EachcCollectData=[self.allDataArrForCollect objectAtIndex:row];
    
    cell.collectBookPrice.text =[NSString localizedStringWithFormat:@"%@",[EachcCollectData objectForKey:@"bookPrice"]];
    
    cell.collectBookISBN.text = [EachcCollectData objectForKey:@"bookISBN"];
    
    NSString *imgUrlStr =[NSString stringWithFormat:@"%@/images/%@",Contents.getContentsUrl,[EachcCollectData objectForKey:@"bookImageId"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
    [cell.collectBookImageView setImage:image];
    
    cell.collectBookName.text = [EachcCollectData objectForKey:@"bookName"];
    
    [cell layoutSubviews];
    
    return cell;
}

//以下 方法是用于实现 数据的删除和插入 操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath];
    NSUInteger row = [indexPath row];
    NSDictionary *EachBooksData=[self.allDataArrForCollect objectAtIndex:row];
    NSString *bookISBNString = [EachBooksData objectForKey:@"bookISBN"];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete !");
        
        ToolController *tool;
        tool = [[ToolController alloc]init];
        NSString* str = [NSString stringWithFormat:@"/RemoveUserCollect?userId=%@&bookISBN=%@",self.UserId,bookISBNString];
        [tool getDataWith:str];
    }
    [tableView reloadData];
}
#pragma mark --UIViewController 生命周期方法，用于响应视图的编辑状态的变化
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.txtField.hidden = NO;
    }
    else{
        self.txtField.hidden = YES;
    }
    
}

#pragma mark - 自定义工具方法
//下拉刷新的设置
-(void)refreshtableView{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
        [self.tableView reloadData];
        
    }
}
//用于显示提示信息的方法
-(void)ShowMessageWith:(NSString *)Message{
    //只显示文字
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = Message;
    self.HUD.margin = 15.f;//四周黑框的大小
    self.HUD.yOffset = 80.f;//距离top的位置
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.HUD hide:YES afterDelay:1];
}

@end
