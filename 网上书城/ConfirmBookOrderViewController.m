//
//  ConfirmBookOrderViewController.m
//  网上书城
//
//  Created by happy on 2016/11/11.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ConfirmBookOrderViewController.h"

@interface ConfirmBookOrderViewController ()

@end

@implementation ConfirmBookOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (IBAction)btnUpOrder:(id)sender {
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
 
        [self showAlertMessageWith:@"下单成功！"];
    
}


@end
