//
//  ShoppingCarTableViewController.m
//  网上书城
//
//  Created by happy on 2016/11/6.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ShoppingCarTableViewController.h"
#import "ShoppingCarTableViewCell.h"
#import "ToolController.h"

@interface ShoppingCarTableViewController ()
@property(nonatomic,strong)NSMutableArray* allDataArr;
@property(nonatomic,strong)NSString* userId;


@property (strong, nonatomic) IBOutlet UITextField *txtField;
-(NSDictionary *)getDataWith:(NSString *)userId;
-(NSDictionary *)removeDataWith:(NSString *)userId and:(NSString *)bookISBN;
-(void)refreshtableView;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
@end

@implementation ShoppingCarTableViewController

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
    self.userId = [userDefault objectForKey:@"UserId"];
    
    NSDictionary *dict = [self getDataWith:self.userId];
    self.allDataArr = [dict objectForKey:@"GetShoppingCarList"];
}

//通过URL 获取网络上的数据
-(NSDictionary *)getDataWith:(NSString *)userId{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/GetShoppingCar?userId=%@",userId];
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
-(NSDictionary *)removeDataWith:(NSString *)userId and:(NSString *)bookISBN{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/RemoveShoppingCar?userId=%@&bookISBN=%@",userId,bookISBN];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allDataArr count];
}
//当选中这一行需要做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ShoppingCarCellID";
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[ShoppingCarTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:row];

    
    cell.txtBookName.text = [EachBooksData objectForKey:@"bookName"];
    cell.txtBookPrice.text =[NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"bookPrice"]];
    cell.txtISBN.text = [EachBooksData objectForKey:@"bookISBN"];
    cell.txtbookNumber.text = @"1";
    
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSDictionary *dict = [tool getDataWith:[NSString stringWithFormat:@"/GetBookDescribe?bookISBN=%@",[EachBooksData objectForKey:@"bookISBN"]]];
    NSMutableArray* allDataArrForBook =[dict objectForKey:@"productlist"];
    NSDictionary *EachData=[allDataArrForBook objectAtIndex:0];
    NSString *imgUrlStr =[NSString stringWithFormat:@"http://192.168.0.137:8080/NetBookShop/images/%@",[EachData objectForKey:@"bookImageId"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
    [cell.bookImage setImage:image];
    
    
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
        NSUInteger row = [indexPath row];
        
        NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:row];
        NSString *strbookISBN= [EachBooksData objectForKey:@"bookISBN"];
        [self removeDataWith:self.userId and:strbookISBN];
        NSDictionary *dict = [self getDataWith:self.userId];
        self.allDataArr = [dict objectForKey:@"GetShoppingCarList"];
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
        
        
        NSDictionary *dict = [self getDataWith:self.userId];
        self.allDataArr = [dict objectForKey:@"GetShoppingCarList"];
        NSLog(@"%@",self.allDataArr.count);
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
        [self.tableView reloadData];
        
    }
}
- (IBAction)btnOrder:(id)sender {
    NSString* strAddressId = @"100001";
    NSString* strNumber = @"1000";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:@"UserId"];
    NSUserDefaults *bookISBNDefault = [NSUserDefaults standardUserDefaults];
    NSString *bookISBN = [bookISBNDefault objectForKey:@"bookISBN"];
    
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/Order?userId=%@&AddressId=%@&bookISBN=%@&number=%@",userId,strAddressId,bookISBN,strNumber];
    NSURL *urlForBooks = [[NSURL alloc] initWithString:strUrlForBooks];
    NSURLRequest *requestForBooks = [NSURLRequest requestWithURL:urlForBooks];
    NSData *jsonDataForBooks = [NSURLConnection sendSynchronousRequest:requestForBooks returningResponse:nil error:nil];
    if (jsonDataForBooks == nil) {
        NSLog(@"is nil! ");
    }else{
        AllBooksDict = [NSJSONSerialization JSONObjectWithData:jsonDataForBooks options:NSJSONReadingMutableLeaves error:&error];
        NSArray* DataArr = [AllBooksDict objectForKey:@"OrderState"];
        NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
        NSString* BackCode = [EachBooksData objectForKey:@"stateCode"];
        //        NSLog(@"Back code is ----->%@",BackCode);
        [self showAlertMessageWith:@"下单成功！"];
    }
}
-(void)showAlertMessageWith:(NSString *)showMessageStr{
    UIAlertController *myAlertController = 	[UIAlertController alertControllerWithTitle:showMessageStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"you click ok!");
        //点击按钮的响应事件；
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
}
@end
