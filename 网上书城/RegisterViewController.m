//
//  RegisterViewController.m
//  网上书城
//
//  Created by happy on 2016/10/26.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "RegisterViewController.h"
#import "Contents.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRePassword;

@property(nonatomic,strong)NSString* StateCode;

-(void)showAlertMessageWith:(NSString *)showMessageStr;
-(NSDictionary *)getRegisterStateFor:(NSString *)UserId And:(NSString *)PassWord;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)btnRegister:(id)sender {
    if([self.txtUserId.text length] == 0){
        //        NSLog(@"账号不能为空 ！");
        [self showAlertMessageWith:@"账号不能为空!"];
    }else if ([self.txtPassword.text length] == 0){
        //        NSLog(@"密码不能为空 ！");
        [self showAlertMessageWith:@"密码不能为空!"];
    }else if([self.txtRePassword.text length] == 0){
        [self showAlertMessageWith:@"确认密码不能为空!"];
    }else if(!([self.txtPassword.text isEqual:self.txtRePassword.text])){
        [self showAlertMessageWith:@"两次密码不一致!"];
    }else{
        NSDictionary *LoginStateDict = [self getRegisterStateFor:self.txtUserId.text And:self.txtPassword.text];
        //    NSLog(@"%@",LoginStateDict);
        NSMutableArray *RegisterStateArr = [LoginStateDict objectForKey:@"RegisterState"];
        NSDictionary *StateCodeDict = [RegisterStateArr objectAtIndex:0];
        self.StateCode = [NSString stringWithFormat:@"%@",[StateCodeDict objectForKey:@"stateCode"]];
        NSLog(@"StateCode--------->%@",self.StateCode);
    }
    
    if([self.StateCode isEqual:@"400"]){
        [self showAlertMessageWith:@"用户Id为空!"];
    }else if([self.StateCode isEqual:@"500"]){
        [self showAlertMessageWith:@"密码为空!"];
    }else if([self.StateCode isEqual:@"600"]){
        [self showAlertMessageWith:@"用户Id已存在!"];
    }else if([self.StateCode isEqual:@"800"]){
        [self showAlertMessageWith:@"用户id必须为纯数字!"];
    }else if([self.StateCode isEqual:@"700"]){
        //        [self showAlertMessageWith:@"注册成功!"];
        //关闭模态视图
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)btnBack:(id)sender {
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:nil];
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
-(NSDictionary *)getRegisterStateFor:(NSString *)UserId And:(NSString *)PassWord{
    NSDictionary *RegisterStateData =[NSDictionary alloc];
    NSError *error;
    NSString *strUrl = [[NSString alloc]initWithFormat:@"%@/Register?userId=%@&Password=%@",Contents.getContentsUrl,UserId,PassWord];
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (jsonData == nil) {
        NSLog(@"is nil! ");
    }else{
        RegisterStateData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        return RegisterStateData;
    }
    return nil;
}
//通过委托来放弃“第一响应者”的身份
#pragma mrak - UITextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mrak - UITextView Delegate Method
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册键盘隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

-(void) keyboardDidShow: (NSNotification *)notif{
    NSLog(@"键盘开启！");
}
-(void) keyboardDidHide: (NSNotification *)notif{
    NSLog(@"键盘关闭！");
}

@end
