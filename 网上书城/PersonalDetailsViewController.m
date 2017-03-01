//
//  PersonalDetailsViewController.m
//  网上书城
//
//  Created by happy on 2016/12/19.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "PersonalDetailsViewController.h"
#import "ToolController.h"
#import "UserInfoViewController.h"
#import "MBProgressHUD.h"
#import "WhiteWaterWaveView.h"

@interface PersonalDetailsViewController ()

//**************************     UI控件声明   ***************************
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *EmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *PhoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *EditButton;
@property (weak, nonatomic) IBOutlet UIView *manView;
@property (weak, nonatomic) IBOutlet UIView *womanView;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
//弹出框的UI控件声明
@property (weak, nonatomic) IBOutlet UIButton *alterUserNameButton;
@property (weak, nonatomic) IBOutlet UIButton *alterPhoneButton;
@property (weak, nonatomic) IBOutlet UIButton *alterEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *alterAddressButton;
@property (strong, nonatomic) UIView *alterView;
@property (strong, nonatomic) UILabel *alterTitleLabel;
@property (strong, nonatomic) UITextField *alterTextField;
@property (strong, nonatomic) UIButton *okButton;
@property(nonatomic, strong)NSString* temp;//记录当前弹出框的需要修改的类型

@property (strong, nonatomic)UIView *tailView;

@property (strong,nonatomic) MBProgressHUD *HUD;//提示窗口的声明

//**************************     自定义方法属性声明   ***************************
@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSMutableArray* allDataArr;
@property BOOL isCanEdit;//判断当前界面是否可以修改
@property BOOL isMan;//判断当前用户是否为男的
@property(nonatomic, strong)ToolController *Tool;

@end

@implementation PersonalDetailsViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏的那些事
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor  = RGB(40, 43, 53);
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tailView];
    [self.view sendSubviewToBack:self.tailView];
    [self ShowWaterView];
    
    //初始化EditButton的状态
    self.isCanEdit = YES;
    //初始化输入框状态
    [self InitUINotEdit];
    //调用方法初始化 选择性别控件
    [self InitSexController];
    //调用方法初始化弹出窗口
    [self initAlterController];
    //调用自定义方法初始化触发按钮
    [self hiddenAllButton];
    //判断用户是否登录了
    if([self isLogin] == YES){
        //调用方法初始化 用户信息
//        [self ShowLoadingWith:@"加载中..."];
        [self InitUserInfo];
    }else{
        NSLog(@"未登录！");
    }
    
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
-(UIView *)tailView{
    if (!_tailView) {
        _tailView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _tailView;
}
-(void)ShowWaterView
{
    WhiteWaterWaveView *waterWaveView = [[WhiteWaterWaveView alloc]initWithFrame:CGRectMake(0, 0, self.tailView.frame.size.width, self.tailView.frame.size.height)];
    [self.tailView addSubview:waterWaveView];
    [self.tailView sendSubviewToBack:waterWaveView];
    
}
-(UIView *)alterView{
    if (!_alterView) {
        _alterView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-125, self.view.frame.size.height/5, 250, 150)];
        _alterView.backgroundColor = [UIColor blackColor];
        _alterView.layer.cornerRadius = 20;
    }
    return _alterView;
}
-(UILabel *)alterTitleLabel{
    if (!_alterTitleLabel) {
        _alterTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.alterView.frame.size.width/2 - 30, 10, 100, 30)];
        _alterTitleLabel.text = @"标题";
//        _alterTitleLabel.backgroundColor = [UIColor whiteColor];
        _alterTitleLabel.textColor = [UIColor whiteColor];
    }
    return _alterTitleLabel;
}
-(UITextField *)alterTextField{
    if (!_alterTextField) {
        _alterTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 60, self.alterView.frame.size.width - 20, 30)];
        _alterTextField.backgroundColor = [UIColor whiteColor];
        _alterTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _alterTextField;
}
-(UIButton *)okButton{
    if (!_okButton) {
        _okButton = [[UIButton alloc] initWithFrame:CGRectMake(self.alterView.frame.size.width/2 - 40, self.alterView.frame.size.height - 50, 80, 30)];
//        _okButton.backgroundColor = [UIColor whiteColor];
        [_okButton setTitle:@"ok" forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(okTouchDown:) forControlEvents:UIControlEventTouchDown];

//        [_okButton buttonWithType:UIButtonTypeRoundedRect];
    }
    return _okButton;
}

#pragma mark - 按钮的点击事件
-(void)okTouchDown:(id)sender{
    NSLog(@"you touch Ok !");
    //保存用户修改的数据并隐藏弹出框
    self.alterView.hidden = YES;
    if ([self.temp isEqualToString:@"修改姓名"]) {
        self.userNameLabel.text = self.alterTextField.text;
    }else if ([self.temp isEqualToString:@"修改手机号"]) {
        self.PhoneLabel.text = self.alterTextField.text;
    }else if ([self.temp isEqualToString:@"修改邮箱"]) {
        self.EmailLabel.text = self.alterTextField.text;
    }else if ([self.temp isEqualToString:@"修改地址"]) {
        self.addressLabel.text = self.alterTextField.text;
    }
    [self.alterTextField resignFirstResponder];//放弃第一响应 从而关闭键盘显示
}
- (IBAction)alterUserNameTouchDown:(id)sender {
    self.alterView.hidden = NO;
    self.temp = @"修改姓名";
    self.alterTitleLabel.text = @"修改姓名";
    self.alterTextField.text = self.userNameLabel.text;
}
- (IBAction)alterPhoneTouchDown:(id)sender {
    self.alterView.hidden = NO;
    self.temp = @"修改手机号";
    self.alterTitleLabel.text = @"修改手机号";
    self.alterTextField.text = self.PhoneLabel.text;
}
- (IBAction)alterEmailTouchDown:(id)sender {
    self.alterView.hidden = NO;
    self.temp = @"修改邮箱";
    self.alterTitleLabel.text = @"修改邮箱";
    self.alterTextField.text = self.EmailLabel.text;
}
- (IBAction)alterAddressTouchDown:(id)sender {
    self.alterView.hidden = NO;
    self.temp = @"修改地址";
    self.alterTitleLabel.text = @"修改地址";
    self.alterTextField.text = self.addressLabel.text;
}
- (IBAction)SaveTouchDown:(id)sender {
    
    //编辑状态
    if (self.isCanEdit == YES) {
        [self.EditButton setImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
        self.EditButton.frame = CGRectMake(self.EditButton.frame.origin.x+2, self.EditButton.frame.origin.y+2, 50, 50);
        self.isCanEdit = NO;
        
        //处于编辑状态下 选择性别的 两个选项都要复原
        self.manView.hidden = NO;
        self.womanView.hidden = NO;
        self.womanView.frame = CGRectMake(148, 0, 58, 38);
        [self InitUICanEdit];
        [self.alterUserNameButton setHidden:NO];
        self.alterPhoneButton.hidden = NO;
        self.alterEmailButton.hidden = NO;
        self.alterAddressButton.hidden = NO;
    //不可变状态
    }else if(self.isCanEdit == NO){
        [self ShowLoadingWith:@"保存中..."];
        [self.EditButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        self.EditButton.frame = CGRectMake(self.EditButton.frame.origin.x, self.EditButton.frame.origin.y, 30, 30);
        self.isCanEdit = YES;
        [self InitUINotEdit];
        
        if (self.isMan == YES) {
            self.manView.hidden = NO;
            self.womanView.hidden = YES;
        }else if(self.isMan == NO){
            self.manView.hidden = YES;
            self.womanView.hidden = NO;
            self.womanView.frame = CGRectMake(67, 0, 58, 38);
        }
        [self PastToServer];
        [self.alterUserNameButton setHidden:YES];
        self.alterPhoneButton.hidden = YES;
        self.alterEmailButton.hidden = YES;
        self.alterAddressButton.hidden = YES;

//        [self ShowMessageWith:@"保存成功！"];
        
    }
}
//- (IBAction)backTouchDown:(id)sender {
//    //关闭模态视图
//    [self dismissViewControllerAnimated:YES completion:^{
//        //        NSLog(@"you click the cancel , close the ModalView !");
//    }];
//}
- (IBAction)manTouchDown:(id)sender {
    self.isMan = YES;
    [self.manButton setImage:[UIImage imageNamed:@"点-2"] forState:UIControlStateNormal];
    [self.womanButton setImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
}
- (IBAction)womanTouchDown:(id)sender {
    self.isMan = NO;
    [self.manButton setImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
    [self.womanButton setImage:[UIImage imageNamed:@"点-2"] forState:UIControlStateNormal];
}

#pragma mark - 自定义工具方法
//初始化隐藏所有的触发提出框按钮
-(void)hiddenAllButton{
    self.alterUserNameButton.hidden = YES;
    self.alterPhoneButton.hidden = YES;
    self.alterEmailButton.hidden = YES;
    self.alterAddressButton.hidden = YES;
}
//初始化性别的选择的控件
-(void)InitSexController{

    self.isMan = NO;
    if (self.isMan == YES) {
        self.manView.hidden = NO;
        self.womanView.hidden = YES;
        [self.manButton setImage:[UIImage imageNamed:@"点-2"] forState:UIControlStateNormal];
        [self.womanButton setImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
    }else if(self.isMan == NO){
        self.manView.hidden = YES;
        self.womanView.hidden = NO;
        self.womanView.frame = CGRectMake(67, 0, 58, 38);
        [self.manButton setImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
        [self.womanButton setImage:[UIImage imageNamed:@"点-2"] forState:UIControlStateNormal];
    }
}
//初始化弹出窗口
-(void)initAlterController{
    [self.alterView addSubview:self.alterTitleLabel];
    [self.alterView addSubview:self.alterTextField];
    [self.alterView addSubview:self.okButton];
    [self.view addSubview:self.alterView];
    self.alterView.hidden = YES;
}
//初始化用户个人信息的控件
-(void)InitUserInfo{
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSString* str = [NSString stringWithFormat:@"/GetUserInfo?userId=%@",self.userId];
    NSDictionary *dict = [tool getDataWith:str];
    NSLog(@"this get  is  ---- -------> %@",dict);
    self.allDataArr = [dict objectForKey:@"userinfolist"];
    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
    //    self.txtID.text = [EachBooksData objectForKey:@"userId"];
    self.IDLabel.text = self.userId;
    if ([[EachBooksData objectForKey:@"userName"] isEqualToString:@"未填写！"]) {
        self.userNameLabel.placeholder= [EachBooksData objectForKey:@"userName"];
    }else{
        self.userNameLabel.text = [EachBooksData objectForKey:@"userName"];
    }
    if ([[EachBooksData objectForKey:@"email"] isEqualToString:@"未填写！"]) {
        self.EmailLabel.placeholder= [EachBooksData objectForKey:@"email"];
    }else{
        self.EmailLabel.text = [EachBooksData objectForKey:@"email"];
    }
    if ([[EachBooksData objectForKey:@"phone"] isEqualToString:@"未填写！"]) {
        self.PhoneLabel.placeholder= [EachBooksData objectForKey:@"phone"];
    }else{
        self.PhoneLabel.text = [EachBooksData objectForKey:@"phone"];
    }
    if ([[EachBooksData objectForKey:@"address"] isEqualToString:@"未填写！"]) {
        //        self.addressLabel.placeholder= [EachBooksData objectForKey:@"address"];
    }else{
        self.addressLabel.text = [EachBooksData objectForKey:@"address"];
    }
    if ([[EachBooksData objectForKey:@"sex"] isEqualToString:@"男"]) {
        self.isMan = YES;
        self.manView.hidden = NO;
        self.womanView.hidden = YES;
        [self.manButton setImage:[UIImage imageNamed:@"点-2"] forState:UIControlStateNormal];
        [self.womanButton setImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
    }else{
        self.isMan = NO;
        self.manView.hidden = YES;
        self.womanView.hidden = NO;
        self.womanView.frame = CGRectMake(67, 0, 58, 38);
        [self.manButton setImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
        [self.womanButton setImage:[UIImage imageNamed:@"点-2"] forState:UIControlStateNormal];
    }
}
//判断是否登录了用户
-(BOOL)isLogin{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefault objectForKey:@"UserId"];
    if(self.userId == nil){
        [self ShowMessageWith:@"请先登录"];

        return NO;
    }else{
        return YES;
    }
}
-(void)PastToServer{
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSString *sexStr= [NSString alloc];
    if (_isMan == YES) {
        sexStr = @"男";
    }else{
        sexStr = @"女";
    }
    NSString* str = [NSString stringWithFormat:@"/AlterUserInfo?userId=%@&UserName=%@&Email=%@&Phone=%@&Address=%@&Sex=%@",self.userId,self.userNameLabel.text,self.EmailLabel.text,self.PhoneLabel.text,self.addressLabel.text,sexStr];
    NSDictionary *dict = [tool getDataWith:str];
    //    self.allDataArr = [dict objectForKey:@"userinfolist"];
    //    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
    //    http://localhost:8080/NetBookShop/AlterUserInfo?userId=userId&UserName=1&Email=1&Phone=1&Address=1
}
-(void)InitUINotEdit{
    self.userNameLabel.userInteractionEnabled = NO;
    self.EmailLabel.userInteractionEnabled = NO;
    self.PhoneLabel.userInteractionEnabled = NO;
    self.addressLabel.userInteractionEnabled = NO;
}
-(void)InitUICanEdit{
    self.userNameLabel.userInteractionEnabled = YES;
    self.EmailLabel.userInteractionEnabled = YES;
    self.PhoneLabel.userInteractionEnabled = YES;
    self.addressLabel.userInteractionEnabled = YES;
}
//用于显示提示信息的方法
-(void)ShowMessageWith:(NSString *)Message{
    //只显示文字
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = Message;
    self.HUD.margin = 15.f;//四周黑框的大小
    self.HUD.yOffset = 50.f;//距离top的位置
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
    self.HUD.yOffset = 50.f;//距离top的位置
    self.HUD.labelText = Message;
    [self.HUD hide:YES afterDelay:0.5];
    
}
#pragma mark - 键盘出现和关闭时调用的方法
-(void) keyboardDidShow: (NSNotification *)notif{
    NSLog(@"键盘开启！");
}
-(void) keyboardDidHide: (NSNotification *)notif{
    NSLog(@"键盘关闭！");
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
