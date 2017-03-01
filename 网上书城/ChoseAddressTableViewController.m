//
//  ChoseAddressTableViewController.m
//  网上书城
//
//  Created by happy on 2016/11/12.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ChoseAddressTableViewController.h"
#import "AddressListTableViewCell.h"
#import "ToolController.h"
#import "Contents.h"

@interface ChoseAddressTableViewController ()
@property(nonatomic,strong)NSString* UserId;
@property(nonatomic,strong)NSMutableArray* GetArr;
@property(nonatomic,strong)NSString* strAddressId;

-(NSDictionary *)getUserInfoBy:(NSString *)userId;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
@end

@implementation ChoseAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    // 导航栏的那些事
    //    [self.navigationController.navigationBar setTitleTextAttributes:
    //     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    //       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ChoseAddressCellID";
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
    NSDictionary *EachBooksData=[self.GetArr objectAtIndex:row];
    
    NSString *nameString = [EachBooksData objectForKey:@"name"];
    NSString *addressString = [EachBooksData objectForKey:@"address"];
    NSString *phoneString = [EachBooksData objectForKey:@"phone"];
    NSString *addressIdString  =[EachBooksData objectForKey:@"addressId"];
    
    //    NSLog(@"-------> %@ %@ %@",nameString,addressIdString,phoneString);
    
    
    //登陆成功之后将数据 回传给主界面
    NSDictionary *BackDataDict = [NSDictionary dictionaryWithObjectsAndKeys:nameString,@"name",addressString,@"address",phoneString ,@"phone",addressIdString,@"addressId" ,nil];
    NSLog(@"传的数据为 --->%@",BackDataDict);
    //采用通知机制将参数传递给登录视图控制器
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ChoseAddressCompletionNotification"
     object:nil
     userInfo:BackDataDict];
    
    //关闭模态视图
    [self dismissViewControllerAnimated:NO completion:nil];
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.GetArr count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
