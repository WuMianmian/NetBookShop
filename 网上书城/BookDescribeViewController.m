//
//  BookDescribeViewController.m
//  网上书城
//
//  Created by happy on 2016/11/6.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "BookDescribeViewController.h"

@interface BookDescribeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *txtBookChineseName;
@property (weak, nonatomic) IBOutlet UILabel *txtBookPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtBookDescribe;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *txtBookEnglishName;
@property (weak, nonatomic) IBOutlet UILabel *txtBookLanguage;
@property (weak, nonatomic) IBOutlet UILabel *txtRepertory;
@property (weak, nonatomic) IBOutlet UILabel *txtBookWriter;
@property (weak, nonatomic) IBOutlet UILabel *txtBookISBN;
@property (weak, nonatomic) IBOutlet UILabel *txtBookPublishingHouse;

//
//@property(nonatomic,strong)NSString* strUserId;
//@property(nonatomic,strong)NSString* strBookISBN;

@property(nonatomic,strong)NSMutableArray* allDataArr;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
-(NSDictionary *)getDataWith:(NSString *)bookISBN;
@end

@implementation BookDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *bookISBNDefault = [NSUserDefaults standardUserDefaults];
    NSString *bookISBN = [bookISBNDefault objectForKey:@"bookISBN"];
//    NSLog(@"get bookISBN is -------->%@",bookISBN);
    
    NSDictionary *dict = [self getDataWith:bookISBN];
    self.allDataArr = [dict objectForKey:@"productlist"];
    
    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
    
    NSString *imgUrlStr =[NSString stringWithFormat:@"http://192.168.0.137:8080/NetBookShop/images/%@",[EachBooksData objectForKey:@"bookImageId"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
    [self.bookImage setImage:image];
    self.txtBookISBN.text = [EachBooksData objectForKey:@"bookISBN"];
    self.txtBookChineseName.text = [EachBooksData objectForKey:@"bookChineseName"];
    if([[EachBooksData objectForKey:@"bookEnglishName"] isEqualToString:@"No"]){
        self.txtBookEnglishName.text = @"  ";
    }else{
        self.txtBookEnglishName.text = [EachBooksData objectForKey:@"bookEnglishName"];
    }
    self.txtBookWriter.text = [EachBooksData objectForKey:@"bookWriter"];
    self.txtBookPrice.text =[NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"bookPrice"]];
    self.txtBookPublishingHouse.text = [EachBooksData objectForKey:@"bookPublishingHouse"];
    self.txtRepertory.text = [NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"bookRepertory"]];
    self.txtBookLanguage.text = [EachBooksData objectForKey:@"bookLanguage"];
    self.txtBookDescribe.text = [EachBooksData objectForKey:@"bookDescribe"];
}
//通过URL 获取网络上的数据
-(NSDictionary *)getDataWith:(NSString *)bookISBN{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/GetBookDescribe?bookISBN=%@",bookISBN];
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
- (IBAction)btnAddShoppingCar:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:@"UserId"];
    NSUserDefaults *bookISBNDefault = [NSUserDefaults standardUserDefaults];
    NSString *bookISBN = [bookISBNDefault objectForKey:@"bookISBN"];
    
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/AddShoppingCar?userId=%@&bookISBN=%@",userId,bookISBN];
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
        [self showAlertMessageWith:@"添加购物车成功！"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



@end
