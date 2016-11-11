//
//  MyOrderListViewController.m
//  网上书城
//
//  Created by happy on 2016/10/26.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "MyOrderListTableViewCell.h"
#import "LoginViewController.h"

@interface MyOrderListViewController ()

@property(nonatomic,strong)NSString* UserId;
@property(nonatomic,strong)NSMutableArray* GetArr;

@property (strong, nonatomic) IBOutlet UITextField *txtField;

-(NSDictionary *)getOrderBy:(NSString *)userId;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
-(void)refreshtableView;
@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //设置单元格文本框
    self.txtField.hidden = YES;
    self.txtField.delegate = self;
    
    //初始化UIrefreshControl 控件
    UIRefreshControl *rc = [[UIRefreshControl alloc]init];
    //    @property (nullable, nonatomic, strong) NSAttributedString *attributedTitle UI_APPEARANCE_SELECTOR;
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
    [rc addTarget:self action:@selector(refreshtableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:@"UserId"];
//    NSLog(@"----------------------------->%lu",(unsigned long)[userId length]);
    if(!(userId == nil)){
        self.UserId = userId;
        NSDictionary *getData = [self getOrderBy:self.UserId];
        self.GetArr = [getData objectForKey:@"GetOrderList"];
    }else{
        [self showAlertMessageWith:@"请先登录"];
    }

    
}

-(void)showAlertMessageWith:(NSString *)showMessageStr{
    UIAlertController *myAlertController = 	[UIAlertController alertControllerWithTitle:showMessageStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"you click ok!");
        //点击按钮的响应事件；
          [self dismissViewControllerAnimated:YES completion:nil];
        [[LoginViewController alloc]init];
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
}
- (IBAction)btnBack:(id)sender {
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSDictionary *)getOrderBy:(NSString *)userId{
    NSDictionary *Data =[NSDictionary alloc];
    NSError *error;
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/GetOrder?Id=%@",userId];
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (jsonData == nil) {
        NSLog(@"is nil! ");
    }else{
        Data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        return Data;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.GetArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"OrderListCellID";
    MyOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[MyOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *EachBooksData=[self.GetArr objectAtIndex:row];
    
//    NSString *imgUrlStr =[NSString stringWithFormat:@"http://192.168.0.137:8080/NetBookShop/images/%@",[EachBooksData objectForKey:@"bookImageId"]];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
//    [cell.BookImageUrl setImage:image];
    
    cell.orderUserName.text = [EachBooksData objectForKey:@"orderUserName"];
    cell.orderUserAddress.text = [EachBooksData objectForKey:@"orderUserAddress"];
    cell.orderBookName.text = [EachBooksData objectForKey:@"orderBookName"];
    cell.orderTotal.text =[NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"orderTotal"]];

    
    
    
    [cell layoutSubviews];
    
    return cell;
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
//以下 方法是用于实现 数据的删除和插入 操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete !");
        //        NSUInteger row = [indexPath row];
        //
        //        NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:row];
        //        NSString *strbookISBN= [EachBooksData objectForKey:@"bookISBN"];
        //        [self removeDataWith:self.userId and:strbookISBN];
        //        NSDictionary *dict = [self getDataWith:self.userId];
        //        self.allDataArr = [dict objectForKey:@"GetShoppingCarList"];
    }
    [tableView reloadData];
}
-(void)refreshtableView{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
        //sleep(1);
        
        //        //添加新的模拟数据
        ////        NSDate *newDate = [[NSDate alloc]init];
        ////        [self.logs addObject:newDate];
        //
        //
        //        NSDictionary *dict = [self getDataWith:self.userId];
        //        self.allDataArr = [dict objectForKey:@"GetShoppingCarList"];
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
        [self.tableView reloadData];
        
    }
}

@end
