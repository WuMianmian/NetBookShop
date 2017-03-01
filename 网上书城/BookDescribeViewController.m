//
//  BookDescribeViewController.m
//  网上书城
//
//  Created by happy on 2016/11/6.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "BookDescribeViewController.h"
#import "ToolController.h"
#import "Contents.h"
#import "MBProgressHUD.h"

@interface BookDescribeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *txtBookChineseName;
@property (weak, nonatomic) IBOutlet UILabel *txtBookPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtBookDescribe;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;

@property (strong,nonatomic) MBProgressHUD *HUD;//提示窗口的声明

@property (weak, nonatomic) IBOutlet UILabel *txtBookEnglishName;
@property (weak, nonatomic) IBOutlet UILabel *txtBookLanguage;
@property (weak, nonatomic) IBOutlet UILabel *txtRepertory;
@property (weak, nonatomic) IBOutlet UILabel *txtBookWriter;
@property (weak, nonatomic) IBOutlet UILabel *txtBookISBN;
@property (weak, nonatomic) IBOutlet UILabel *txtBookPublishingHouse;
@property (strong, nonnull) NSString* BooKImageString;

@property (strong ,nonatomic) UIImageView *bookImageCopyImageView;
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
    
    //    // 导航栏的那些事
    //    [self.navigationController.navigationBar setTitleTextAttributes:
    //     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    //       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    NSUserDefaults *bookISBNDefault = [NSUserDefaults standardUserDefaults];
    NSString *bookISBN = [bookISBNDefault objectForKey:@"bookISBN"];
    //    NSLog(@"get bookISBN is -------->%@",bookISBN);
    
    NSDictionary *dict = [self getDataWith:bookISBN];
    self.allDataArr = [dict objectForKey:@"productlist"];
    
    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
    
    NSString *imgUrlStr =[NSString stringWithFormat:@"%@/images/%@",Contents.getContentsUrl,[EachBooksData objectForKey:@"bookImageId"]];
    self.BooKImageString = imgUrlStr;
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
    //将UI控件加入到当前界面中
    [self.view addSubview:self.bookImageCopyImageView];
}
//通过URL 获取网络上的数据
-(NSDictionary *)getDataWith:(NSString *)bookISBN{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@/GetBookDescribe?bookISBN=%@",Contents.getContentsUrl,bookISBN];
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
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@/AddShoppingCar?userId=%@&bookISBN=%@",Contents.getContentsUrl,userId,bookISBN];
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
        //        [self showAlertMessageWith:@"添加购物车成功！"];
        
        //加入购物车 实现一个动画效果
        //动画控件
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.5];//动画时间长度，单位秒，浮点数
        
        self.bookImageCopyImageView.frame = CGRectMake(375/2, 667, 40, 40);
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        [UIView setAnimationDidStopSelector:nil];
        [UIView commitAnimations];
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
- (IBAction)buyNowTouchDown:(id)sender {
    NSLog(@"touch down buy now!");
    //存储到本地 传递给下一个界面
    NSUserDefaults *bookDataDefaults = [NSUserDefaults standardUserDefaults];
    [bookDataDefaults setObject:self.txtBookChineseName.text forKey:@"BookName"];
    [bookDataDefaults setObject:self.txtBookWriter.text forKey:@"BookWriter"];
    [bookDataDefaults setObject:self.txtBookISBN.text forKey:@"BookIBSN"];
    [bookDataDefaults setObject:self.BooKImageString forKey:@"BookImageUrl"];
    [bookDataDefaults setObject:self.txtBookPrice.text forKey:@"BookPrice"];
    [bookDataDefaults setObject:@"1" forKey:@"mark"];
    [bookDataDefaults synchronize];
    
}

- (IBAction)CollectTouchDown:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:@"UserId"];
    //调用外部的工具方法
    ToolController *tool;
    tool = [[ToolController alloc]init];
    //判断是否登录了用户
    if(!(userId == nil)){
        NSString *str = [[NSString alloc] initWithFormat:@"/AddUserCollect?userId=%@&bookISBN=%@",userId,self.txtBookISBN.text];
        [tool getDataWith:str];
        [self ShowMessageWith:@"收藏成功"];
        
    }else{
        [self ShowMessageWith:@"请先登录"];
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
//**************************************     UI控件的绘制     **************************************

-(UIImageView *)bookImageCopyImageView{
    if (!_bookImageCopyImageView) {
        _bookImageCopyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(21,72,115,168)];
        //        [_bookImageCopyImageView setImage:[UIImage imageNamed:@"BackgroundImage.png"]];
        [_bookImageCopyImageView setImage:self.bookImage.image];
        _bookImageCopyImageView.backgroundColor = [UIColor greenColor];
    }
    return _bookImageCopyImageView;
}


@end
