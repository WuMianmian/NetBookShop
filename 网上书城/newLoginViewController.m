//
//  newLoginViewController.m
//  网上书城
//
//  Created by happy on 2016/12/18.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "newLoginViewController.h"
#import "MBProgressHUD.h"
#import "Contents.h"
#import "WhiteWaterWaveView.h"
#import "WXApi.h"

@interface newLoginViewController ()

//**************************     UI控件声明   ***************************
@property (weak, nonatomic) IBOutlet UIView *hiddenLoginButtonView;
@property (weak, nonatomic) IBOutlet UIButton *WeixinButton;
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *tailView;//尾部显示一个动画效果
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (strong,nonatomic) MBProgressHUD *HUD;//提示窗口的声明

//**************************     自定义方法属性声明   ***************************
@property(nonatomic,strong)NSString* StateCode;//登录状态码
@end

@implementation newLoginViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.promptLabel.hidden = YES;
    [self ShowWaterView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UI控件的设置
-(UIButton *)WeixinButton{
    if (!_WeixinButton) {
        //        [_WeixinButton setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        //        [_WeixinButton setImage:[UIImage imageNamed:@"微信-2"] forState:UIControlStateSelected];
    }
    return _WeixinButton;
}
-(UIView *)tailView{
    if (!_tailView) {
    }
    return _tailView;
}
- (void)ShowWaterView
{
    WhiteWaterWaveView *waterWaveView = [[WhiteWaterWaveView alloc]initWithFrame:CGRectMake(0, 0, self.tailView.frame.size.width, self.tailView.frame.size.height)];
    [self.tailView addSubview:waterWaveView];
    [self.tailView sendSubviewToBack:waterWaveView];
    
}

#pragma mark - 按钮的点击事件
- (IBAction)closeTouchDown:(id)sender {
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:^{
        //        NSLog(@"you click the cancel , close the ModalView !");
    }];
}
- (IBAction)LoginTouchDown:(id)sender {
    //    [self getUserInfoDataWith:self.textUserId.text];
    
    if([self.userIdTextField.text length] == 0){
        //        NSLog(@"账号不能为空 ！");
        [self ShowMessageWith:@"账号不能为空!"];
    }
    else if ([self.passwordTextField.text length] == 0){
        //        NSLog(@"密码不能为空 ！");
        [self ShowMessageWith:@"密码不能为空!"];
    }
    else{
        NSDictionary *LoginStateDict = [self getLoginStateFor:self.userIdTextField.text And:self.passwordTextField.text];
        //    NSLog(@"%@",LoginStateDict);
        NSMutableArray *LoginStateArr = [LoginStateDict objectForKey:@"loginState"];
        NSDictionary *StateCodeDict = [LoginStateArr objectAtIndex:0];
        self.StateCode = [NSString stringWithFormat:@"%@",[StateCodeDict objectForKey:@"stateCode"]];
        NSLog(@"StateCode--------->%@",self.StateCode);
    }
    
    if([self.StateCode isEqual:@"300"]){
        [self ShowMessageWith:@"用户不存在!"];
        self.promptLabel.hidden = NO;
    }else if([self.StateCode isEqual:@"200"]){
        [self ShowMessageWith:@"密码错误!"];
        self.promptLabel.hidden = NO;
    }else if([self.StateCode isEqual:@"100"]){
        
        //登陆成功之后将数据 回传给主界面
        NSDictionary *longinBackDataDict = [NSDictionary dictionaryWithObject:self.userIdTextField.text forKey:@"userId"];
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
        
        
        //将账号存储到本地上去 获取userDefault单例
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //登陆成功后把用户名和密码存储到UserDefault
        [userDefaults setObject:self.userIdTextField.text forKey:@"UserId"];
        [userDefaults synchronize];
        
        //关闭模态视图
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

/*
 目前移动应用上德微信登录只提供原生的登录方式，需要用户安装微信客户端才能配合使用。
 对于iOS应用,考虑到iOS应用商店审核指南中的相关规定，建议开发者接入微信登录时，先检测用户手机是否已经安装
 微信客户端(使用sdk中的isWXAppInstalled函数),对于未安装的用户隐藏微信 登录按钮，只提供其他登录方式。
 */
- (IBAction)WeixinTouchDown:(id)sender {
    NSLog(@"微信登录 ！");
    [self ShowMessageWith:@"微信登录"];
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}
- (IBAction)QQTouchDown:(id)sender {
    NSLog(@"QQ登录 ！");
    [self ShowMessageWith:@"QQ登录"];
}
- (IBAction)WeiboTouchDown:(id)sender {
    NSLog(@"微博登录 ！");
    [self ShowMessageWith:@"微博登录"];
}

#pragma mark - 自定义工具方法
//设置弹出提示语
- (void)setupAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
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

#pragma mark - URL获取服务器数据
-(NSDictionary *)getLoginStateFor:(NSString *)UserId And:(NSString *)PassWord{
    NSDictionary *LoginStateData =[NSDictionary alloc];
    NSError *error;
    NSString *strUrl = [[NSString alloc]initWithFormat:@"%@/Login?userId=%@&Password=%@",Contents.getContentsUrl,UserId,PassWord];
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


#pragma mrak - 输入框的代理
//通过委托来放弃“第一响应者”的身份
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 键盘出现和关闭时调用的方法
-(void) keyboardDidShow: (NSNotification *)notif{
    //    NSLog(@"键盘开启！");
    //当输入框 为空的时候 隐藏登录按钮 当输入框 输入东西之后 登录按钮在显现出来
    if ( (!([self.userIdTextField.text length] == 0))  && (!([self.passwordTextField.text length] == 0))  ) {
        self.hiddenLoginButtonView.hidden = YES;
    }
    if (([self.userIdTextField.text length] == 0) || ([self.passwordTextField.text length] == 0)) {
        self.hiddenLoginButtonView.hidden = NO;
    }
    self.promptLabel.hidden = YES;
}
-(void) keyboardDidHide: (NSNotification *)notif{
    NSLog(@"键盘关闭！");
    if ( (!([self.userIdTextField.text length] == 0))  && (!([self.passwordTextField.text length] == 0))  ) {
        self.hiddenLoginButtonView.hidden = YES;
    }
    if (([self.userIdTextField.text length] == 0) || ([self.passwordTextField.text length] == 0)) {
        self.hiddenLoginButtonView.hidden = NO;
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - 生命周期
#pragma mark - UI控件的设置
#pragma mark - 按钮的点击事件
#pragma mark - 自定义工具方法
#pragma mark - URL获取服务器数据
@end
