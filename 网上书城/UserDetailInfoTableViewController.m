
//
//  UserDetailInfoTableViewController.m
//  网上书城
//
//  Created by happy on 2016/11/8.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "UserDetailInfoTableViewController.h"
#import "ToolController.h"
#import "UserInfoViewController.h"

@interface UserDetailInfoTableViewController ()
//**************************     UI控件声明   ***************************
@property (weak, nonatomic) IBOutlet UILabel *txtID;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;

//**************************     自定义方法属性声明   ***************************
@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSMutableArray* allDataArr;

@end

@implementation UserDetailInfoTableViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefault objectForKey:@"UserId"];
    
    if(self.userId == nil){
        [self showAlertMessageWith:@"请先登录"];
    }
    
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSString* str = [NSString stringWithFormat:@"/GetUserInfo?userId=%@",self.userId];
    NSDictionary *dict = [tool getDataWith:str];
    NSLog(@"this get  is  ---- -------> %@",dict);
    self.allDataArr = [dict objectForKey:@"userinfolist"];
    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
    //    self.txtID.text = [EachBooksData objectForKey:@"userId"];
    self.txtID.text = self.userId;
    if ([[EachBooksData objectForKey:@"userName"] isEqualToString:@"未填写！"]) {
        self.txtName.placeholder= [EachBooksData objectForKey:@"userName"];
    }else{
        self.txtName.text = [EachBooksData objectForKey:@"userName"];
    }
    if ([[EachBooksData objectForKey:@"email"] isEqualToString:@"未填写！"]) {
        self.txtEmail.placeholder= [EachBooksData objectForKey:@"email"];
    }else{
        self.txtEmail.text = [EachBooksData objectForKey:@"email"];
    }
    if ([[EachBooksData objectForKey:@"phone"] isEqualToString:@"未填写！"]) {
        self.txtPhone.placeholder= [EachBooksData objectForKey:@"phone"];
    }else{
        self.txtPhone.text = [EachBooksData objectForKey:@"phone"];
    }
    if ([[EachBooksData objectForKey:@"address"] isEqualToString:@"未填写！"]) {
        self.txtAddress.placeholder= [EachBooksData objectForKey:@"address"];
    }else{
        self.txtAddress.text = [EachBooksData objectForKey:@"address"];
    }
    
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
}

#pragma mark - 按钮的点击事件
- (IBAction)btnSave:(id)sender {
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSString* str = [NSString stringWithFormat:@"/AlterUserInfo?userId=%@&UserName=%@&Email=%@&Phone=%@&Address=%@",self.userId,self.txtName.text,self.txtEmail.text,self.txtPhone.text,self.txtAddress.text];
    NSDictionary *dict = [tool getDataWith:str];
    [self showAlertMessageWith:@"保存成功！"];
    
}




@end
