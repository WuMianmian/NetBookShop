//
//  AlterMyAddressViewController.m
//  网上书城
//
//  Created by happy on 2016/11/7.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "AlterMyAddressViewController.h"
#import "ToolController.h"
#import "Contents.h"

@interface AlterMyAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UILabel *txtPickAddress;
@property (weak, nonatomic) IBOutlet UIView *pickView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

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

-(NSDictionary *)getAddressBy:(NSString *)addressId;
@end

@implementation AlterMyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    self.AllProvinceDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.pickView.hidden = YES;
    
    
    
    
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    NSUserDefaults *AddressDefault = [NSUserDefaults standardUserDefaults];
    self.strAddressId = [AddressDefault objectForKey:@"AddressId"];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefault objectForKey:@"UserId"];
    if (![self.strAddressId isEqualToString:@"add"]) {
        //    NSLog(@"addressId is  ------>%@",self.strAddressId);
        NSDictionary *getData = [self getAddressBy:self.strAddressId];
        self.GetArr = [getData objectForKey:@"useraddresslist"];
        NSDictionary *EachBooksData=[self.GetArr objectAtIndex:0];
        self.txtName.text = [EachBooksData objectForKey:@"name"];
        self.txtPhone.text = [EachBooksData objectForKey:@"phone"];
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
        
        self.txtPickAddress.text = fristAddressStr;
        self.txtAddress.text = SecondAddressStr;
        //    self.txtAddress.text = [EachBooksData objectForKey:@"address"];
        //    self.txtPickAddress.text = [EachBooksData objectForKey:@"address"];
        self.txtZipCode.text = [EachBooksData objectForKey:@"zipCode"];
        
    }
    
}
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSave:(id)sender {
    NSString* AllAddress = [[NSString alloc] initWithFormat:@"%@ %@",self.txtPickAddress.text,self.txtAddress.text];
    ToolController *tool;
    tool = [[ToolController alloc]init];
    if ([self.strAddressId isEqualToString:@"add"]) {
        NSString* str = [NSString stringWithFormat:@"/AddUserAddress?userId=%@&Address=%@&Phone=%@&ZipCode=%@&Name=%@",self.userId,AllAddress,self.txtPhone.text,self.txtZipCode.text,self.txtName.text];
        [tool getDataWith:str];
    }else{
        NSString* str = [NSString stringWithFormat:@"/AlterAddress?userId=%@&Address=%@&Phone=%@&ZipCode=%@&Name=%@&AddressId=%@",self.userId,AllAddress,self.txtPhone.text,self.txtZipCode.text,self.txtName.text,self.strAddressId];
        [tool getDataWith:str];
    }
    
    //    self.allDataArr = [dict objectForKey:@"userinfolist"];
    //    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:0];
    //    http://localhost:8080/NetBookShop/AlterUserInfo?userId=userId&UserName=1&Email=1&Phone=1&Address=1
    [self showAlertMessageWith:@"保存成功！"];
    
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
        [self.pickerView reloadComponent:2];
        [self.pickerView reloadComponent:1];
        
    }else if(component == 1){
        self.countyArr = [self.cityDict objectForKey:[[NSString alloc] initWithFormat:@"%@",self.city]];
        [self.pickerView reloadComponent:2];
    }
}

- (IBAction)btnAlterAddress:(id)sender {
    self.pickView.hidden = NO;
    
}
- (IBAction)btnCancel:(id)sender {
    self.pickView.hidden = YES;
}
- (IBAction)btnOK:(id)sender {
    NSInteger row3 = [self.pickerView selectedRowInComponent:2];
    NSString* value = [[NSString alloc] initWithFormat:@"%@ %@ %@",self.province,self.city,self.countyArr[row3]];
    self.txtPickAddress.text = value;
    //    self.txtAddress.text = [[NSString alloc] initWithFormat:@"%@ %@",value,self.txtAddress.text];
    self.pickView.hidden = YES;
}


@end
