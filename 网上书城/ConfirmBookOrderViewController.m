//
//  ConfirmBookOrderViewController.m
//  网上书城
//
//  Created by happy on 2016/11/11.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ConfirmBookOrderViewController.h"
#import "Contents.h"

@interface ConfirmBookOrderViewController ()
//收货人的收货信息
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//订单的书本信息
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookIBSNLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookWriterLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
//支付方式信息
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;

@property(strong, nonatomic)NSString *addressIdString;
@property(strong, nonatomic)NSString *bookISBNString;
@end

@implementation ConfirmBookOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    // 导航栏的那些事
    //    [self.navigationController.navigationBar setTitleTextAttributes:
    //     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    //       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    NSUserDefaults *UserDataDefaults = [NSUserDefaults standardUserDefaults];
    if (!(UserDataDefaults  == nil)) {
        NSString *nameString = [UserDataDefaults objectForKey:@"name"];
        NSString *addressString = [UserDataDefaults objectForKey:@"address"];
        NSString *phoneString = [UserDataDefaults objectForKey:@"phone"];
        self.nameLabel.text = nameString;
        self.phoneLabel.text = phoneString;
        self.addressLabel.text = addressString;
    }
    [self GetData];
    [self GetDataAndinitView];
}
//接收在打开的界面回传回来的数据
-(void)GetData{
    //用于接收 在登陆界面 回调回来的数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(GetbackCompletion:)
                                                name:@"ChoseAddressCompletionNotification"
                                              object:nil];
}
-(void)GetDataAndinitView{
    //接收从上一个界面存储在本地的数据
    [self initViewBookInfo];
}
-(void)initViewBookInfo{
    NSUserDefaults *bookDataDefaults = [NSUserDefaults standardUserDefaults];
    NSString *bookNameString = [bookDataDefaults objectForKey:@"BookName"];
    NSString *bookWriterString = [bookDataDefaults objectForKey:@"BookWriter"];
    self.bookISBNString = [bookDataDefaults objectForKey:@"BookIBSN"];
    NSString *bookImageUrlString = [bookDataDefaults objectForKey:@"BookImageUrl"];
    NSString *bookPriceString = [bookDataDefaults objectForKey:@"BookPrice"];
    NSString *markString = [bookDataDefaults objectForKey:@"mark"];
    if ([markString isEqualToString:@"1"]) {
        self.markLabel.hidden = YES;
    }else if([markString isEqualToString:@"2"]){
        self.markLabel.hidden = NO;
    }
    
    self.bookNameLabel.text = bookNameString;
    self.bookWriterLabel.text = bookWriterString;
    self.bookIBSNLabel.text = self.bookISBNString;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:bookImageUrlString]]];
    [self.bookImageView setImage:image];
    self.bookPriceLabel.text = bookPriceString;
}
//接收从LoginController界面中回传回来的数据
-(void)GetbackCompletion:(NSNotification *)notification{
    NSDictionary *GetLoginbackData = [notification userInfo];
    NSString *nameString = [GetLoginbackData objectForKey:@"name"];
    NSString *addressString = [GetLoginbackData objectForKey:@"address"];
    NSString *phoneString = [GetLoginbackData objectForKey:@"phone"];
    self.addressIdString  = [GetLoginbackData objectForKey:@"addressId"];
    self.nameLabel.text = nameString;
    self.phoneLabel.text = phoneString;
    self.addressLabel.text = addressString;
    //存储到本地 传递给下一个界面
    
    NSUserDefaults *UserDataDefaults = [NSUserDefaults standardUserDefaults];
    [UserDataDefaults setObject:nameString forKey:@"name"];
    [UserDataDefaults setObject:addressString forKey:@"address"];
    [UserDataDefaults setObject:phoneString forKey:@"phone"];
    [UserDataDefaults setObject:self.addressIdString forKey:@"addressId"];
    [UserDataDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertMessageWith:(NSString *)showMessageStr{
    UIAlertController *myAlertController = 	[UIAlertController alertControllerWithTitle:showMessageStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"you click ok!");
        //点击按钮的响应事件；
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
}
//选择地址箭头按钮点击事件
- (IBAction)btnChoseAddress:(id)sender {
    
}

- (IBAction)btnUpOrder:(id)sender {
    NSUserDefaults *UserDataDefaults = [NSUserDefaults standardUserDefaults];
    if(UserDataDefaults == nil){
        [self showAlertMessageWith:@"地址不能为空！"];
    }else{
        //单个下单
        NSUserDefaults *UserDataDefaults = [NSUserDefaults standardUserDefaults];
        NSString* strAddressId = [UserDataDefaults objectForKey:@"addressId"];
        
        NSString* strNumber = @"1000";//订单数量
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefault objectForKey:@"UserId"];
        NSString *bookISBN = self.bookISBNString;
        
        NSDictionary *AllBooksDict =[NSDictionary alloc];
        NSError *error;
        //        NSLog(@"the bookISBN -> %@,addressId -> %@,userId -> %@",bookISBN,strAddressId,userId);
        NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@/Order?userId=%@&AddressId=%@&bookISBN=%@&number=%@",Contents.getContentsUrl,userId,strAddressId,bookISBN,strNumber];
        NSURL *urlForBooks = [[NSURL alloc] initWithString:strUrlForBooks];
        NSURLRequest *requestForBooks = [NSURLRequest requestWithURL:urlForBooks];
        NSData *jsonDataForBooks = [NSURLConnection sendSynchronousRequest:requestForBooks returningResponse:nil error:nil];
        if (jsonDataForBooks == nil) {
            NSLog(@"is nil! ");
        }else{
            AllBooksDict = [NSJSONSerialization JSONObjectWithData:jsonDataForBooks options:NSJSONReadingMutableLeaves error:&error];
            //                [self showAlertMessageWith:@"下单成功！"];
        }
        //购物车 多个下单
    }
    
}
//付款方式 点击方法
//微信支付
//支付宝支付
//银行卡支付
//apple支付
- (IBAction)weixinTouchDown:(id)sender {
    self.payWayLabel.text = @"微信支付";
}
- (IBAction)zhifubaoTouchDown:(id)sender {
    self.payWayLabel.text = @"支付宝支付";
}
- (IBAction)bankTouchDown:(id)sender {
    self.payWayLabel.text = @"银行卡支付";
}
- (IBAction)applePayTouchDown:(id)sender {
    self.payWayLabel.text = @"Apple Pay";
}



@end
