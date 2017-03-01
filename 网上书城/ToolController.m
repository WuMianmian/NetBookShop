//
//  ToolController.m
//  网上书城
//
//  Created by happy on 2016/11/8.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ToolController.h"
#import "Contents.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

@interface ToolController ()

//**************************     UI控件声明   ***************************
@property (strong,nonatomic) MBProgressHUD *HUD;//提示窗口的声明

//**************************     自定义方法属性声明   ***************************
@property(weak ,nonatomic) NSDictionary *Dic;
-(NSDictionary *)getDataWith:(NSString *)str;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
-(void)ShowMessageWith:(NSString *)Message;
-(void)ShowLoadingWith:(NSString *)Message;
@end

@implementation ToolController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - URL获取服务器数据
-(NSDictionary *)getDataWith:(NSString *)str{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@%@",Contents.getContentsUrl,str];
    
    strUrlForBooks = [strUrlForBooks stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlForBooks = [[NSURL alloc] initWithString:strUrlForBooks];
    NSURLRequest *requestForBooks = [NSURLRequest requestWithURL:urlForBooks];
    NSData *jsonDataForBooks = [NSURLConnection sendSynchronousRequest:requestForBooks returningResponse:nil error:nil];
    
    if (jsonDataForBooks == nil) {
        NSLog(@"is nil! ");
        [self showAlertMessageWith:@"网络出现异常！"];
    }else{
        AllBooksDict = [NSJSONSerialization JSONObjectWithData:jsonDataForBooks options:NSJSONReadingMutableLeaves error:&error];
        //        NSLog(@"---获取到的json格式的字典2-- %@",AllBooksDict);
        return AllBooksDict;
    }
    return nil;
}

//通过AFNetworking URL 获取网络上的数据

//利用AFNetworking  GET方式请求网站数据

//-(NSDictionary *)getDataWith:(NSString *)str
//{
//    // 启动系统风火轮
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    NSDictionary *temp;
//    //前面写服务器给的域名,后面拼接上需要提交的参数，假如参数是key＝1
//    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@%@",Contents.getContentsUrl,str];
//    strUrlForBooks = [strUrlForBooks stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    //以GET的形式提交，只需要将上面的请求地址给GET做参数就可以
//    [manager GET:strUrlForBooks parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // 隐藏系统风火轮
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//
//        //json解析
//        NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"---获取到的json格式的字典--%@",resultDic);
//        self.Dic = resultDic;
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//
//        NSLog(@"Not GET the Data !");
//
//    }];
//    NSLog(@"this dict  is  ---------->%@",self.Dic);
//    return self.Dic;
//
//}

#pragma mark - 自定义工具方法
-(void)showAlertMessageWith:(NSString *)showMessageStr{
    UIAlertController *myAlertController = 	[UIAlertController alertControllerWithTitle:showMessageStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"you click ok!");
        //点击按钮的响应事件；
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
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
//显示一个圆形 loading的菊花加载指示
-(void)ShowLoadingWith:(NSString *)Message{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    //    self.HUD.color = [UIColor blueColor];//颜色设置
    self.HUD.dimBackground = YES;//是否有遮罩
    self.HUD.margin = 15.f;//四周黑框的大小
    self.HUD.yOffset = 80.f;//距离top的位置
    self.HUD.labelText = Message;
    [self.HUD hide:YES afterDelay:2];
    
}


@end
