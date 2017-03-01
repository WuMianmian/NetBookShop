//
//  AddressListViewController.m
//  网上书城
//
//  Created by happy on 2016/10/26.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressListTableViewCell.h"
#import "ToolController.h"
#import "Contents.h"

@interface AddressListViewController ()

@property(nonatomic,strong)NSString* UserId;
@property(nonatomic,strong)NSMutableArray* GetArr;
@property(nonatomic,strong)NSString* strAddressId;
@property (strong, nonatomic) IBOutlet UITextField *txtField;

-(NSDictionary *)getUserInfoBy:(NSString *)userId;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏的设置
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:RGB(40, 43, 53)}];
    self.navigationController.navigationBar.tintColor  = RGB(40, 43, 53);
    
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
        NSDictionary *getData = [self getUserInfoBy:self.UserId];
        self.GetArr = [getData objectForKey:@"useraddresslist"];
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
-(NSDictionary *)getUserInfoBy:(NSString *)userId{
    NSDictionary *Data =[NSDictionary alloc];
    NSError *error;
    NSString *strUrl = [[NSString alloc]initWithFormat:@"%@/GetUserAddress?userId=%@",Contents.getContentsUrl,userId];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"AddressCellID";
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[AddressListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *EachBooksData=[self.GetArr objectAtIndex:row];
    
    
    cell.userName.text = [EachBooksData objectForKey:@"name"];
    cell.address.text = [EachBooksData objectForKey:@"address"];
    cell.phone.text = [EachBooksData objectForKey:@"phone"];
    
    [cell layoutSubviews];
    
    return cell;
}

//当选中这一行需要做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    //    NSLog(@" you click this %lu row",(unsigned long)row);
    NSDictionary *EachBooksData=[self.GetArr objectAtIndex:row];
    self.strAddressId = [EachBooksData objectForKey:@"addressId"];
    //    NSLog(@"get url the straddress id is %@",self.strAddressId);
    
    //获取Default单例
    NSUserDefaults *AddressDefault = [NSUserDefaults standardUserDefaults];
    //点击cell之后将id存在CategoryDefault中 用于传递
    [AddressDefault setObject:self.strAddressId forKey:@"AddressId"];
    //        [userDefaults setObject:self.textPassWord.text forKey:@"password"];
    [AddressDefault synchronize];
    
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.GetArr count];
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
    NSUInteger row = [indexPath row];
    NSDictionary *EachBooksData=[self.GetArr objectAtIndex:row];
    self.strAddressId = [EachBooksData objectForKey:@"addressId"];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //        NSLog(@"delete !");
        ToolController *tool;
        tool = [[ToolController alloc]init];
        NSString* str = [NSString stringWithFormat:@"/RemoveUserAddress?AddressId=%@",self.strAddressId];
        [tool getDataWith:str];
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
        NSDictionary *getData = [self getUserInfoBy:self.UserId];
        self.GetArr = [getData objectForKey:@"useraddresslist"];
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
        [self.tableView reloadData];
        
    }
}
- (IBAction)btnAddAddress:(id)sender {
    //获取Default单例
    NSUserDefaults *AddressDefault = [NSUserDefaults standardUserDefaults];
    //点击cell之后将id存在CategoryDefault中 用于传递
    [AddressDefault setObject:@"add" forKey:@"AddressId"];
    //        [userDefaults setObject:self.textPassWord.text forKey:@"password"];
    [AddressDefault synchronize];
}

@end
