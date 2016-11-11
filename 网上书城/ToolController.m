//
//  ToolController.m
//  网上书城
//
//  Created by happy on 2016/11/8.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ToolController.h"

@interface ToolController ()
-(NSDictionary *)getDataWith:(NSString *)str;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
@end

@implementation ToolController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}
//通过URL 获取网络上的数据
-(NSDictionary *)getDataWith:(NSString *)str{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop%@",str];
    strUrlForBooks = [strUrlForBooks stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlForBooks = [[NSURL alloc] initWithString:strUrlForBooks];
    NSURLRequest *requestForBooks = [NSURLRequest requestWithURL:urlForBooks];
    NSData *jsonDataForBooks = [NSURLConnection sendSynchronousRequest:requestForBooks returningResponse:nil error:nil];
    
    if (jsonDataForBooks == nil) {
        NSLog(@"is nil! ");
        [self showAlertMessageWith:@"网络出现异常！"];
    }else{
        AllBooksDict = [NSJSONSerialization JSONObjectWithData:jsonDataForBooks options:NSJSONReadingMutableLeaves error:&error];
        return AllBooksDict;
    }
    return nil;
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


@end
