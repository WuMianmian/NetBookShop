//
//  OrderTableViewController.m
//  网上书城
//
//  Created by happy on 2016/11/7.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "OrderTableViewController.h"
#import "OrderTableViewCell.h"

@interface OrderTableViewController ()
@property(nonatomic,strong)NSMutableArray* allDataArrForOrder;
@property(nonatomic,strong)NSMutableArray* allDataArrForBook;
@property(nonatomic,strong)NSString* UserId;

@property (strong, nonatomic) IBOutlet UITextField *txtField;

-(NSDictionary *)getOrderDataWith:(NSString *)str;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
@end

@implementation OrderTableViewController

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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:@"UserId"];
    
    //    NSLog(@"----------------------------->%lu",(unsigned long)[userId length]);
    if(!(userId == nil)){
        self.UserId = userId;
        NSDictionary *dict = [self getOrderDataWith:[NSString stringWithFormat:@"GetOrder?userId=%@",self.UserId]];
        self.allDataArrForOrder = [dict objectForKey:@"GetOrderList"];
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
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
}
//通过URL 获取网络上的数据
-(NSDictionary *)getOrderDataWith:(NSString *)str{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/%@",str];
    NSURL *urlForBooks = [[NSURL alloc] initWithString:strUrlForBooks];
    NSURLRequest *requestForBooks = [NSURLRequest requestWithURL:urlForBooks];
    NSData *jsonDataForBooks = [NSURLConnection sendSynchronousRequest:requestForBooks returningResponse:nil error:nil];
    
    if (jsonDataForBooks == nil) {
        NSLog(@"is nil! ");
    }else{
        AllBooksDict = [NSJSONSerialization JSONObjectWithData:jsonDataForBooks options:NSJSONReadingMutableLeaves error:&error];
        return AllBooksDict;
    }
    return nil;
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.allDataArrForOrder count];
}
//当选中这一行需要做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSUInteger row = [indexPath row];
//    NSLog(@" you click this %lu row",(unsigned long)row);
//    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:row];
//    //获取Default单例
//    NSUserDefaults *bookISBNDefault = [NSUserDefaults standardUserDefaults];
//    //点击cell之后将id存在CategoryDefault中 用于传递
//    [bookISBNDefault setObject:[EachBooksData objectForKey:@"bookISBN"] forKey:@"bookISBN"];
//    [bookISBNDefault synchronize];
    
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"OrderCellID";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *EachBooksData=[self.allDataArrForOrder objectAtIndex:row];
    cell.txtBookPrice.text =[NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"orderTotal"]];
    
    NSString* strBookISBN = [EachBooksData objectForKey:@"orderContent"];
    cell.txtBookISBN.text = strBookISBN;
    
     NSDictionary *dict = [self getOrderDataWith:[NSString stringWithFormat:@"GetBookDescribe?bookISBN=%@",strBookISBN]];
    self.allDataArrForBook =[dict objectForKey:@"productlist"];
    NSDictionary *EachData=[self.allDataArrForBook objectAtIndex:0];
    
    NSString *imgUrlStr =[NSString stringWithFormat:@"http://192.168.0.137:8080/NetBookShop/images/%@",[EachData objectForKey:@"bookImageId"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
    [cell.bookimage setImage:image];
    
    cell.txtBookName.text = [EachData objectForKey:@"bookChineseName"];

    
    [cell layoutSubviews];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
