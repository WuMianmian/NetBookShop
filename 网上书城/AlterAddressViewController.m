//
//  AlterAddressViewController.m
//  网上书城
//
//  Created by happy on 2016/12/27.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "AlterAddressViewController.h"
#import "ToolController.h"
#import "Contents.h"
#import "MBProgressHUD.h"

@interface AlterAddressViewController ()

//**************************     UI控件声明   ***************************
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *pickerAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;
@property (weak, nonatomic) IBOutlet UIButton *alterAddressButton;

//弹出框的UI控件声明
@property (weak, nonatomic) IBOutlet UIButton *alterNameButton;
@property (weak, nonatomic) IBOutlet UIButton *alterPhoneButton;
@property (weak, nonatomic) IBOutlet UIButton *alterZipCodeButton;
@property (strong, nonatomic) UIView *alterView;
@property (strong, nonatomic) UILabel *alterTitleLabel;
@property (strong, nonatomic) UITextField *alterTextField;
@property (strong, nonatomic) UIButton *okButton;
@property(nonatomic, strong)NSString* temp;//记录当前弹出框的需要修改的类型

@property (weak, nonatomic) IBOutlet UIButton *EditButton;

@property (strong,nonatomic) MBProgressHUD *HUD;//提示窗口的声明

//**************************     自定义方法属性声明   ***************************
@property(nonatomic,strong)NSDictionary* AllProvinceDict;
@property(nonatomic,strong)NSDictionary* provinceDict;
@property(nonatomic,strong)NSArray* provinceArr;
@property(nonatomic,strong)NSString* province;
@property(nonatomic,strong)NSDictionary* AllCityDict;
@property(nonatomic,strong)NSDictionary* cityDict;
@property(nonatomic,strong)NSArray* cityArr;
@property(nonatomic,strong)NSString* city;
@property(nonatomic,strong)NSDictionary* AllCountyDict;
@property(nonatomic,strong)NSDictionary* countyDict;
@property(nonatomic,strong)NSArray* countyArr;
@property(nonatomic,strong)NSString* county;

@property(nonatomic,strong)NSMutableArray* GetArr;
@property(nonatomic,strong)NSString* strAddressId;
@property(nonatomic,strong)NSString* userId;

@property BOOL isCanEdit;//判断当前界面是否可以修改
@end

@implementation AlterAddressViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航栏的那些事
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor  = RGB(40, 43, 53);
    
    //读取plist文件
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    self.AllProvinceDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSUserDefaults *AddressDefault = [NSUserDefaults standardUserDefaults];
    self.strAddressId = [AddressDefault objectForKey:@"AddressId"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefault objectForKey:@"UserId"];
    
    //初始化EditButton的状态
    self.isCanEdit = YES;
    //初始化输入框状态
    [self InitUINotEdit];
    //初始化界面
    [self ininView];
    //调用自定义方法初始化触发按钮
    [self hiddenAllButton];
    //调用方法初始化弹出窗口
    [self initAlterController];
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
//初始化界面
-(void)ininView{
    self.pickerView.hidden = YES;
    
    self.cityPickerView.dataSource = self;
    self.cityPickerView.delegate = self;
    
    //    NSLog(@"addressId is  ------>%@",self.strAddressId);
    NSDictionary *getData = [self getAddressBy:self.strAddressId];
    self.GetArr = [getData objectForKey:@"useraddresslist"];
    NSDictionary *EachBooksData=[self.GetArr objectAtIndex:0];
    self.userNameTextField.text = [EachBooksData objectForKey:@"name"];
    self.phoneTextField.text = [EachBooksData objectForKey:@"phone"];
    NSString* allAddressStr = [EachBooksData objectForKey:@"address"];
    
    NSArray *allAddressArray = [allAddressStr componentsSeparatedByString:@" "];
    
    NSString* fristAddressStr = @"";
    for (NSInteger i = 0; i < 3; i++) {
        fristAddressStr  = [fristAddressStr stringByAppendingFormat:@"%@ ",allAddressArray[i]];
    }
    NSString* SecondAddressStr = @"";
    for (NSInteger i = 3; i < allAddressArray.count; i++) {
        SecondAddressStr  = [SecondAddressStr stringByAppendingFormat:@"%@ ",allAddressArray[i]];
    }
    
    self.pickerAddressLabel.text = fristAddressStr;
    self.addressTextView.text = SecondAddressStr;
    //    self.txtAddress.text = [EachBooksData objectForKey:@"address"];
    //    self.txtPickAddress.text = [EachBooksData objectForKey:@"address"];
    self.zipCodeTextField.text = [EachBooksData objectForKey:@"zipCode"];
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
- (IBAction)alterNameTouchDown:(id)sender {
    self.alterView.hidden = NO;
    self.temp = @"修改姓名";
    self.alterTitleLabel.text = @"修改姓名";
    self.alterTextField.text = self.userNameTextField.text;
}
- (IBAction)alterPhoneTouchDown:(id)sender {
    self.alterView.hidden = NO;
    self.temp = @"修改手机号";
    self.alterTitleLabel.text = @"修改手机号";
    self.alterTextField.text = self.phoneTextField.text;
}
- (IBAction)alterZipCodeTouchDown:(id)sender {
    self.alterView.hidden = NO;
    self.temp = @"修改ZIP";
    self.alterTitleLabel.text = @"修改ZIP";
    self.alterTextField.text = self.zipCodeTextField.text;
}
-(void)okTouchDown:(id)sender{
    NSLog(@"you touch Ok !");
    //保存用户修改的数据并隐藏弹出框
    self.alterView.hidden = YES;
    if ([self.temp isEqualToString:@"修改姓名"]) {
        self.userNameTextField.text = self.alterTextField.text;
    }else if ([self.temp isEqualToString:@"修改手机号"]) {
        self.phoneTextField.text = self.alterTextField.text;
    }else if ([self.temp isEqualToString:@"修改ZIP"]) {
        self.zipCodeTextField.text = self.alterTextField.text;
    }
    [self.alterTextField resignFirstResponder];//放弃第一响应 从而关闭键盘显示
}
- (IBAction)SaveTouchDown:(id)sender {
    //编辑状态
    if (self.isCanEdit == YES) {
        [self.EditButton setImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
        self.EditButton.frame = CGRectMake(self.EditButton.frame.origin.x+2, self.EditButton.frame.origin.y+2, 50, 50);
        self.isCanEdit = NO;
        [self InitUICanEdit];
        self.alterNameButton.hidden = NO;
        self.alterPhoneButton.hidden = NO;
        self.alterZipCodeButton.hidden = NO;
        
        //不可变状态
    }else if(self.isCanEdit == NO){
        [self.EditButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        self.EditButton.frame = CGRectMake(self.EditButton.frame.origin.x, self.EditButton.frame.origin.y, 30, 30);
        self.isCanEdit = YES;
        [self InitUINotEdit];
        [self alterUserAddress];
        [self ShowMessageWith:@"保存成功！"];
        self.alterNameButton.hidden = YES;
        self.alterZipCodeButton.hidden = YES;
        self.alterPhoneButton.hidden = YES;
    }
}

- (IBAction)alterAddressTouchDown:(id)sender {
    self.pickerView.hidden = NO;
    
}
- (IBAction)CancelTouchDown:(id)sender {
    self.pickerView.hidden = YES;
}
- (IBAction)OKTouchDown:(id)sender {
    NSInteger row3 = [self.cityPickerView selectedRowInComponent:2];
    NSString* value = [[NSString alloc] initWithFormat:@"%@ %@ %@",self.province,self.city,self.countyArr[row3]];
    self.pickerAddressLabel.text = value;
    self.pickerView.hidden = YES;
}


#pragma mark 实现UIPickerViewDataSource方法
//选择器有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    //    return 3;
    return 3;
}

///每列对应多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return [self.AllProvinceDict count];
    }else if(component == 1){
        return [self.AllCityDict count];
    }else if(component == 2){
        return [self.countyArr count];
    }else{
        return 0;
    }
    
}
#pragma mark 实现UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* strRow = [[NSString alloc] initWithFormat:@"%lu",row];
    if (component == 0) {
        self.provinceDict = [self.AllProvinceDict objectForKey:strRow];
        self.provinceArr = [self.provinceDict allKeys];
        self.province = [self.provinceArr objectAtIndex:0];
        return self.province;
    }else if(component == 1){
        
        NSString* strRow = [[NSString alloc] initWithFormat:@"%lu",row];
        self.cityDict = [self.AllCityDict objectForKey:strRow];
        self.cityArr = [self.cityDict allKeys];
        self.city = [self.cityArr objectAtIndex:0];
        return self.city;
    }else if(component == 2){
        self.countyArr = [self.cityDict objectForKey:[[NSString alloc] initWithFormat:@"%@",self.city]];
        return self.countyArr[row];
    }else{
        return 0;
    }
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString* strRow = [[NSString alloc] initWithFormat:@"%lu",row];
    NSLog(@"%@",strRow);
    
    if (component == 0) {
        self.provinceDict = [self.AllProvinceDict objectForKey:strRow];
        self.provinceArr = [self.provinceDict allKeys];
        self.province = [self.provinceArr objectAtIndex:0];
        NSLog(@"%@",self.province);
        self.AllCityDict = [self.provinceDict objectForKey:[self.provinceArr objectAtIndex:0]];
        self.cityDict = [self.AllCityDict objectForKey:@"0"];
        [self.cityPickerView reloadComponent:2];
        [self.cityPickerView reloadComponent:1];
        
    }else if(component == 1){
        self.countyArr = [self.cityDict objectForKey:[[NSString alloc] initWithFormat:@"%@",self.city]];
        [self.cityPickerView reloadComponent:2];
    }
}

#pragma mark - 通过URL从服务器得到数据
-(NSDictionary *)getAddressBy:(NSString *)addressId{
    NSDictionary *Data =[NSDictionary alloc];
    NSError *error;
    NSString *strUrl = [[NSString alloc]initWithFormat:@"%@/GetUserAddressForId?AddressId=%@",Contents.getContentsUrl,addressId];
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
#pragma mark - 自定义工具方法
//初始化弹出窗口
-(void)initAlterController{
    [self.alterView addSubview:self.alterTitleLabel];
    [self.alterView addSubview:self.alterTextField];
    [self.alterView addSubview:self.okButton];
    [self.view addSubview:self.alterView];
    self.alterView.hidden = YES;
}
//初始化隐藏所有的触发提出框按钮
-(void)hiddenAllButton{
    self.alterPhoneButton.hidden = YES;
    self.alterNameButton.hidden = YES;
    self.alterZipCodeButton.hidden = YES;
}
- (void)alterUserAddress{
    NSString* AllAddress = [[NSString alloc] initWithFormat:@"%@ %@",self.pickerAddressLabel.text,self.addressTextView.text];
    ToolController *tool;
    tool = [[ToolController alloc]init];
    if ([self.strAddressId isEqualToString:@"add"]) {
        NSString* str = [NSString stringWithFormat:@"/AddUserAddress?userId=%@&Address=%@&Phone=%@&ZipCode=%@&Name=%@",self.userId,AllAddress,self.phoneTextField.text,self.zipCodeTextField.text,self.userNameTextField.text];
        [tool getDataWith:str];
    }else{
        NSString* str = [NSString stringWithFormat:@"/AlterAddress?userId=%@&Address=%@&Phone=%@&ZipCode=%@&Name=%@&AddressId=%@",self.userId,AllAddress,self.phoneTextField.text,self.zipCodeTextField.text,self.userNameTextField.text,self.strAddressId];
        [tool getDataWith:str];
    }
    [self ShowMessageWith:@"保存成功！"];
    
}
-(void)InitUINotEdit{
    self.userNameTextField.userInteractionEnabled = NO;
    self.phoneTextField.userInteractionEnabled = NO;
    self.zipCodeTextField.userInteractionEnabled = NO;
    self.addressTextView.userInteractionEnabled = NO;
    self.alterAddressButton.hidden = YES;
}
-(void)InitUICanEdit{
    self.userNameTextField.userInteractionEnabled = YES;
    self.phoneTextField.userInteractionEnabled = YES;
    self.zipCodeTextField.userInteractionEnabled = YES;
    self.addressTextView.userInteractionEnabled = YES;
    self.alterAddressButton.hidden = NO;
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
@end
