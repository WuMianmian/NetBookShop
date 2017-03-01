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
#import "Contents.h"
#import "MBProgressHUD.h"

@interface ShoppingCarTableViewController ()
//**************************     UI控件声明   ***************************
@property (weak, nonatomic) IBOutlet UIButton *settlementButton;
@property (strong, nonatomic) IBOutlet UITextField *txtField;
@property (strong, nonatomic) UIView *ShoppingCarNullView;
@property (strong, nonatomic) UILabel *ShoppingCarNullLabel;
@property (strong, nonatomic) UIImageView *ShoppingCarNullImageView;
@property (strong, nonatomic) UIButton *ShoppingCarNullButton;

//**************************     自定义方法属性声明   ***************************
//获取设备的界面宽高
@property CGFloat DriveWidth;
@property CGFloat DriveHeight;
@property(nonatomic,strong)NSMutableArray* allDataArr;
@property(nonatomic,strong)NSString* userId;

@property(strong, nonatomic)NSString* priceString;

-(NSDictionary *)getDataWith:(NSString *)userId;
-(NSDictionary *)removeDataWith:(NSString *)userId and:(NSString *)bookISBN;
-(void)refreshtableView;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
-(void)reFreshSettlementButton;
@end

@implementation ShoppingCarTableViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:RGB(40, 43, 53)}];
    self.navigationController.navigationBar.tintColor  = RGB(40, 43, 53);
    
    //获取设备的界面宽高
    CGRect DriveRect = [[UIScreen mainScreen] bounds];
    CGSize DriveSize = DriveRect.size;
    self.DriveWidth = DriveSize.width;
    self.DriveHeight = DriveSize.height;
    
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
    
    
    
    [self reFreshSettlementButton];
    [self.ShoppingCarNullView addSubview:self.ShoppingCarNullLabel];
    [self.ShoppingCarNullView addSubview:self.ShoppingCarNullImageView];
    [self.ShoppingCarNullView addSubview:self.ShoppingCarNullButton];
    [self.view addSubview:self.ShoppingCarNullView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI控件的设置
//当购物车为空的时候 显示这个view来占位
-(UIView *)ShoppingCarNullView{
    if(!_ShoppingCarNullView){
        _ShoppingCarNullView = [[UIView alloc]init];
        _ShoppingCarNullView.backgroundColor = [UIColor whiteColor];
        _ShoppingCarNullView.frame = CGRectMake(0 , 0, self.DriveWidth, self.DriveHeight);
        
    }
    return _ShoppingCarNullView;
}
-(UILabel *)ShoppingCarNullLabel{
    if(!_ShoppingCarNullLabel){
        _ShoppingCarNullLabel = [[UILabel alloc]init];
        _ShoppingCarNullLabel.text = @"购物车空空的，快去逛逛...";
        _ShoppingCarNullLabel.frame =CGRectMake(self.DriveWidth/4,self.DriveHeight/2,300,20);
    }
    return _ShoppingCarNullLabel;
}
-(UIImageView *)ShoppingCarNullImageView{
    if(!_ShoppingCarNullImageView){
        _ShoppingCarNullImageView = [[UIImageView alloc]init];
        //        _ShoppingCarNullImageView.backgroundColor = [UIColor wColor];
        _ShoppingCarNullImageView.image=[UIImage imageNamed:@"ShoppingCar_null"];
        _ShoppingCarNullImageView.frame =CGRectMake(self.DriveWidth/2-75,self.DriveHeight/2-150-20,150,150);
    }
    return _ShoppingCarNullImageView;
}
-(UIButton *)ShoppingCarNullButton{
    if(!_ShoppingCarNullButton){
        _ShoppingCarNullButton = [[UIButton alloc]init];
        _ShoppingCarNullButton.backgroundColor = [UIColor grayColor];
        _ShoppingCarNullButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _ShoppingCarNullButton.frame =CGRectMake(self.DriveWidth/2 - 50,self.DriveHeight/2 +20+50,100,50);
        _ShoppingCarNullButton.backgroundColor = [UIColor clearColor];
        [_ShoppingCarNullButton setTitle:@"去逛逛" forState:UIControlStateNormal];
        [_ShoppingCarNullButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _ShoppingCarNullButton.showsTouchWhenHighlighted = YES;
        
    }
    return _ShoppingCarNullButton;
}

#pragma mark - 按钮的点击事件
//结算按钮的实时更新
-(void)reFreshSettlementButton{
    
    
    
    // 如果购物车没有商品就隐藏这个按钮 如果有商品就显示这个按钮
    if(self.allDataArr.count == 0){
        self.settlementButton.hidden = YES;
        self.ShoppingCarNullView.hidden = NO;
        
    }else if(self.allDataArr.count > 1 ||self.allDataArr.count == 1){
        self.settlementButton.hidden = NO;
        self.ShoppingCarNullView.hidden = YES;
    }
    //计算出购物车商品总价
    int i;
    NSString* allPriceStr;
    double allPrice = 0;
    NSDictionary *EachBooksData;
    for (i = 0; i < [self.allDataArr count]; i++) {
        EachBooksData=[self.allDataArr objectAtIndex:i];
        allPriceStr = [NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"bookPrice"]];
        allPrice = allPrice + [allPriceStr doubleValue];
    }
    allPriceStr =[NSString localizedStringWithFormat:@"结算（小计：%.2f）",allPrice];
    self.priceString = [NSString localizedStringWithFormat:@"%.2f",allPrice];
    //设置button标题
    [self.settlementButton setTitle:allPriceStr forState:UIControlStateNormal];
}
- (IBAction)btnOrder:(id)sender {
    //    NSString* strAddressId = @"100001";
    //    NSString* strNumber = @"1000";
    //
    //    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //    NSString *userId = [userDefault objectForKey:@"UserId"];
    //    NSUserDefaults *bookISBNDefault = [NSUserDefaults standardUserDefaults];
    //    NSString *bookISBN = [bookISBNDefault objectForKey:@"bookISBN"];
    //
    //    NSDictionary *AllBooksDict =[NSDictionary alloc];
    //    NSError *error;
    //    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@/Order?userId=%@&AddressId=%@&bookISBN=%@&number=%@",Contents.getContentsUrl,userId,strAddressId,bookISBN,strNumber];
    //    NSURL *urlForBooks = [[NSURL alloc] initWithString:strUrlForBooks];
    //    NSURLRequest *requestForBooks = [NSURLRequest requestWithURL:urlForBooks];
    //    NSData *jsonDataForBooks = [NSURLConnection sendSynchronousRequest:requestForBooks returningResponse:nil error:nil];
    //    if (jsonDataForBooks == nil) {
    //        NSLog(@"is nil! ");
    //    }else{
    //        AllBooksDict = [NSJSONSerialization JSONObjectWithData:jsonDataForBooks options:NSJSONReadingMutableLeaves error:&error];
    //        NSArray* DataArr = [AllBooksDict objectForKey:@"OrderState"];
    //        NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
    //        NSString* BackCode = [EachBooksData objectForKey:@"stateCode"];
    //        //        NSLog(@"Back code is ----->%@",BackCode);
    //        [self showAlertMessageWith:@"下单成功！"];
    //        MBProgressHUD *hud = [[MBProgressHUD alloc]init];
    //        hud.mode = MBProgressHUDModeIndeterminate;
    //    }
    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
    NSString* bookNameString = [EachBooksData objectForKey:@"bookName"];
    NSString* bookISBNString = [EachBooksData objectForKey:@"bookISBN"];
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSDictionary *dict = [tool getDataWith:[NSString stringWithFormat:@"/GetBookDescribe?bookISBN=%@",[EachBooksData objectForKey:@"bookISBN"]]];
    NSMutableArray* allDataArrForBook =[dict objectForKey:@"productlist"];
    NSDictionary *EachData=[allDataArrForBook objectAtIndex:0];
    NSString *imgUrlStr =[NSString stringWithFormat:@"%@/images/%@",Contents.getContentsUrl,[EachData objectForKey:@"bookImageId"]];
    NSString *bookWriterString = [EachData objectForKey:@"bookWriter"];
    //存储到本地 传递给下一个界面
    NSUserDefaults *bookDataDefaults = [NSUserDefaults standardUserDefaults];
    [bookDataDefaults setObject:bookNameString forKey:@"BookName"];
    [bookDataDefaults setObject:bookWriterString forKey:@"BookWriter"];
    [bookDataDefaults setObject:bookISBNString forKey:@"BookIBSN"];
    [bookDataDefaults setObject:imgUrlStr forKey:@"BookImageUrl"];
    [bookDataDefaults setObject:self.priceString forKey:@"BookPrice"];
    [bookDataDefaults setObject:@"2" forKey:@"mark"];
    [bookDataDefaults synchronize];
}

#pragma mark - 自定义工具方法
-(void)showAlertMessageWith:(NSString *)showMessageStr{
    UIAlertController *myAlertController = 	[UIAlertController alertControllerWithTitle:showMessageStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"you click ok!");
        //点击按钮的响应事件；
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
}

#pragma mark - URL获取服务器数据
//通过URL 获取网络上的数据
-(NSDictionary *)getDataWith:(NSString *)userId{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@/GetShoppingCar?userId=%@",Contents.getContentsUrl,userId];
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
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@/RemoveShoppingCar?userId=%@&bookISBN=%@",Contents.getContentsUrl,userId,bookISBN];
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

#pragma mark - TableView 代理方法
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
    NSString *imgUrlStr =[NSString stringWithFormat:@"%@/images/%@",Contents.getContentsUrl,[EachData objectForKey:@"bookImageId"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
    [cell.bookImage setImage:image];
    
    
    [cell layoutSubviews];
    
    return cell;
}
//以下 方法是用于实现 数据的删除和插入 操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath];
    
    //删除操作
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
    [self reFreshSettlementButton];
}

#pragma mark - 下拉刷新的设置
-(void)refreshtableView{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
        //sleep(1);
        
        //        //添加新的模拟数据
        ////        NSDate *newDate = [[NSDate alloc]init];
        ////        [self.logs addObject:newDate];
        
        
        NSDictionary *dict = [self getDataWith:self.userId];
        self.allDataArr = [dict objectForKey:@"GetShoppingCarList"];
        //        NSLog(@"%@",self.allDataArr.count);
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
        [self.tableView reloadData];
        [self reFreshSettlementButton];
        
    }
}


@end
