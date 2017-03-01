//
//  UserInfoViewController.m
//  网上书城
//
//  Created by happy on 2016/10/25.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserOrderViewController.h"
#import "Contents.h"
#import "NYWaterWaveView.h"
#import "WhiteWaterWaveView.h"

@interface UserInfoViewController ()

//**************************     UI控件声明   ***************************
@property (weak, nonatomic) IBOutlet UILabel *txtUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *userBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UIImageView *userSexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userUnLoginImageView;

//**************************     自定义方法属性声明   ***************************
@property(nonatomic,strong)NSString* UserId;
@property(nonatomic,strong)NSDictionary* UserInfo;
-(NSDictionary *)getUserInfoFor:(NSString *)userId;
@end

@implementation UserInfoViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //去除导航栏下方的横线
    self.navigationController.navigationBar.translucent = NO;//    Bar的模糊效果，默认为YES  不然会出现导航栏 色差问题
    //    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //     rgba(40, 43, 53,1);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置用户的头像为圆形的
    self.userImageView.layer.cornerRadius = 35;
    self.userUnLoginImageView.layer.cornerRadius = 35;
    
    //初始化UIrefreshControl 控件
    UIRefreshControl *rc = [[UIRefreshControl alloc]init];
    //    @property (nullable, nonatomic, strong) NSAttributedString *attributedTitle UI_APPEARANCE_SELECTOR;
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
    [rc addTarget:self action:@selector(refreshtableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
    [self setUp2];
    
    //用于接收 在登陆界面 回调回来的数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(GetbackloginCompletion:)
                                                name:@"loginCompletionNotification"
                                              object:nil];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:@"UserId"];
    [self setUp];
    if(!(userId == nil)){
        self.loginView.hidden = YES;
        self.logOutButton.hidden = NO;
        [self.btnLogin setHidden:YES];
        
        self.UserId = userId;
        NSDictionary *getData = [self getUserInfoFor:self.UserId];
        NSMutableArray *GetArr = [getData objectForKey:@"userinfolist"];
        self.UserInfo = [GetArr objectAtIndex:0];
        if([[self.UserInfo objectForKey:@"userName"] length] ==1){
            self.txtUserName.text =@"(还未取名字，赶紧取个名字吧⬇️)";
        }else{
            self.txtUserName.text = [self.UserInfo objectForKey:@"userName"];
        }
        if ([[self.UserInfo objectForKey:@"sex"] isEqualToString:@"男" ]) {
            self.userSexImageView.frame = CGRectMake(197, 78, 30, 30);
            [self.userSexImageView setImage:[UIImage imageNamed:@"男"]];
        }else{
            self.userSexImageView.frame = CGRectMake(205, 80, 17, 17);
            [self.userSexImageView setImage:[UIImage imageNamed:@"女"]];
        }
    }else{
        self.txtUserName.text = @"未登录！请先登录 ------->";
        self.loginView.hidden = NO;
        self.logOutButton.hidden = YES;
        //        NSLog(@"执行了！");
        [self.btnLogin setHidden:NO];
    }
    
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    //去掉导航栏的黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(handleColorChange:)
               name:@"reDo"
             object:nil];
    
}

#pragma mark - 按钮的点击事件
- (IBAction)btnEixtLogin:(id)sender {
    //退出登录 移除本地存储的所有数据
    NSUserDefaults *UserDataDefaults = [NSUserDefaults standardUserDefaults];
    [UserDataDefaults removeObjectForKey:@"name"];
    [UserDataDefaults removeObjectForKey:@"address"];
    [UserDataDefaults removeObjectForKey:@"phone"];
    [UserDataDefaults synchronize];
    //移除UserDefaults中存储的用户信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"UserId"];
    [userDefaults synchronize];
    self.txtUserName.text = @"未登录！请先登录 ------->";
    //    NSLog(@"执行了！");
    [self.btnLogin setHidden:NO];
    [self.loginView setHidden:NO];
    self.logOutButton.hidden = YES;
}

#pragma mark - URL获取服务器数据
-(NSDictionary *)getUserInfoFor:(NSString *)userId{
    NSDictionary *Data =[NSDictionary alloc];
    NSError *error;
    NSString *strUrl = [[NSString alloc]initWithFormat:@"%@/GetUserInfo?userId=%@",Contents.getContentsUrl,userId];
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

#pragma mark - tableView 控件方法
//当选中这一行需要做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - refresh 控件方法
-(void)refreshtableView{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
        //sleep(1);
        
        //        //添加新的模拟数据
        NSDictionary *getData = [self getUserInfoFor:self.UserId];
        NSMutableArray *GetArr = [getData objectForKey:@"userinfolist"];
        self.UserInfo = [GetArr objectAtIndex:0];
        if([[self.UserInfo objectForKey:@"userName"] length] == 1){
            [self.txtUserName setHidden:YES];
            self.txtUserName.text =@"(还未取名字，赶紧取个名字吧⬇️)";
        }else{
            self.txtUserName.text = [self.UserInfo objectForKey:@"userName"];
        }
        if ([[self.UserInfo objectForKey:@"sex"] isEqualToString:@"男" ]) {
            self.userSexImageView.frame = CGRectMake(197, 78, 30, 30);
            [self.userSexImageView setImage:[UIImage imageNamed:@"男"]];
        }else{
            self.userSexImageView.frame = CGRectMake(200, 78, 17, 17);
            [self.userSexImageView setImage:[UIImage imageNamed:@"女"]];
        }
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@" "];
        //        [self.tableView reloadData];
        
    }
}
#pragma mark - 自定义工具方法
-(void)handleColorChange:(id)sender{
    self.txtUserName.text = @"未登录！请先登录 ------->";
    NSLog(@"执行了！");
    [self.btnLogin setHidden:NO];
}
- (void)setUp
{
    WhiteWaterWaveView *waterWaveView = [[WhiteWaterWaveView alloc]initWithFrame:CGRectMake(0, 0, self.loginView.frame.size.width, self.loginView.frame.size.height)];
    [self.loginView addSubview:waterWaveView];
    [self.loginView sendSubviewToBack:waterWaveView];
    //    [self.userBackgroundView addSubview:waterWaveView];
    
}
- (void)setUp2
{
    WhiteWaterWaveView *waterWaveView = [[WhiteWaterWaveView alloc]initWithFrame:CGRectMake(0, 0, self.loginView.frame.size.width, self.loginView.frame.size.height)];
    
    [self.userBackgroundView addSubview:waterWaveView];
    
}
//接收从LoginController界面中回传回来的数据
-(void)GetbackloginCompletion:(NSNotification *)notification{
    
    NSDictionary *GetLoginbackData=[notification userInfo];
    self.UserId = [GetLoginbackData objectForKey:@"userId"];
    NSLog(@"--back-Id-----------> %@",self.UserId);
    
    NSDictionary *getData = [self getUserInfoFor:self.UserId];
    NSMutableArray *GetArr = [getData objectForKey:@"userinfolist"];
    self.UserInfo = [GetArr objectAtIndex:0];
    self.txtUserName.text = [self.UserInfo objectForKey:@"userName"];
    [self.btnLogin setHidden:YES];
    [self.loginView setHidden:YES];
    self.logOutButton.hidden = NO;
}
@end
