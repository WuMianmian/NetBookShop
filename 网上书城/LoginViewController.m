//
//  LoginViewController.m
//  网上书城
//
//  Created by happy on 2016/10/25.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textUserId;
@property (weak, nonatomic) IBOutlet UITextField *textPassWord;

@property(nonatomic,strong)NSString* StateCode;

-(void)showAlertMessageWith:(NSString *)showMessageStr;
-(NSDictionary *)getLoginStateFor:(NSString *)UserId And:(NSString *)PassWord;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(NSDictionary *)getLoginStateFor:(NSString *)UserId And:(NSString *)PassWord{
    NSDictionary *LoginStateData =[NSDictionary alloc];
    NSError *error;
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/Login?userId=%@&Password=%@",UserId,PassWord];
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (jsonData == nil) {
        NSLog(@"is nil! ");
    }else{
        LoginStateData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        return LoginStateData;
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

- (IBAction)btnLogin:(id)sender {
//    [self getUserInfoDataWith:self.textUserId.text];
    
    if([self.textUserId.text length] == 0){
        //        NSLog(@"账号不能为空 ！");
        [self showAlertMessageWith:@"账号不能为空!"];
    }
    else if ([self.textPassWord.text length] == 0){
        //        NSLog(@"密码不能为空 ！");
        [self showAlertMessageWith:@"密码不能为空!"];
    }
    else{
        NSDictionary *LoginStateDict = [self getLoginStateFor:self.textUserId.text And:self.textPassWord.text];
        //    NSLog(@"%@",LoginStateDict);
        NSMutableArray *LoginStateArr = [LoginStateDict objectForKey:@"loginState"];
        NSDictionary *StateCodeDict = [LoginStateArr objectAtIndex:0];
        self.StateCode = [NSString stringWithFormat:@"%@",[StateCodeDict objectForKey:@"stateCode"]];
            NSLog(@"StateCode--------->%@",self.StateCode);
    }
    
    if([self.StateCode isEqual:@"300"]){
        [self showAlertMessageWith:@"用户不存在!"];
    }else if([self.StateCode isEqual:@"200"]){
        [self showAlertMessageWith:@"密码错误!"];
    }else if([self.StateCode isEqual:@"100"]){

        //登陆成功之后将数据 回传给主界面
        NSDictionary *longinBackDataDict = [NSDictionary dictionaryWithObject:self.textUserId.text forKey:@"userId"];
        //采用通知机制将参数传递给登录视图控制器
        //    - (void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"loginCompletionNotification"
         object:nil
         userInfo:longinBackDataDict];
        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        //登陆成功后把用户名存储到UserDefault
//        [userDefaults setObject:self.textUserId forKey:@"UserId"];
//        [userDefaults synchronize];
//        //这里建议同步存储到磁盘中，但是不是必须的，虽然有时候不加这一行代码也能保存成功，但是如果程序运行占用比较大的内存的时候不加这行代码，可能会造成无法写入plist文件中
//
        

  
        //获取userDefault单例
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //登陆成功后把用户名和密码存储到UserDefault
        [userDefaults setObject:self.textUserId.text forKey:@"UserId"];
        [userDefaults synchronize];
        
        //关闭模态视图
        [self dismissViewControllerAnimated:NO completion:nil];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
