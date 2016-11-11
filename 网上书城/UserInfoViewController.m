//
//  UserInfoViewController.m
//  网上书城
//
//  Created by happy on 2016/10/25.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserOrderViewController.h"

@interface UserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *txtUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property(nonatomic,strong)NSString* UserId;
@property(nonatomic,strong)NSDictionary* UserInfo;

-(NSDictionary *)getUserInfoFor:(NSString *)userId;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化UIrefreshControl 控件
    UIRefreshControl *rc = [[UIRefreshControl alloc]init];
    //    @property (nullable, nonatomic, strong) NSAttributedString *attributedTitle UI_APPEARANCE_SELECTOR;
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
    [rc addTarget:self action:@selector(refreshtableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;


    //用于接收 在登陆界面 回调回来的数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(GetbackloginCompletion:)
                                                name:@"loginCompletionNotification"
                                              object:nil];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:@"UserId"];
    
    if(!(userId == nil)){
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
    }else{
        self.txtUserName.text = @"未登录！请先登录 ------->";
//        NSLog(@"执行了！");
        [self.btnLogin setHidden:NO];
    }
    
}
-(NSDictionary *)getUserInfoFor:(NSString *)userId{
    NSDictionary *Data =[NSDictionary alloc];
    NSError *error;
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/GetUserInfo?userId=%@",userId];
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
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(handleColorChange:)
               name:@"reDo"
             object:nil];
}
-(void)handleColorChange:(id)sender{
    self.txtUserName.text = @"未登录！请先登录 ------->";
    NSLog(@"执行了！");
    [self.btnLogin setHidden:NO];
}
- (IBAction)btnEixtLogin:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //移除UserDefaults中存储的用户信息
    [userDefaults removeObjectForKey:@"UserId"];
    [userDefaults synchronize];
    self.txtUserName.text = @"未登录！请先登录 ------->";
//    NSLog(@"执行了！");
    [self.btnLogin setHidden:NO];
}
-(void)refreshtableView{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
        //sleep(1);
        
        //        //添加新的模拟数据
        NSDictionary *getData = [self getUserInfoFor:self.UserId];
        NSMutableArray *GetArr = [getData objectForKey:@"userinfolist"];
        self.UserInfo = [GetArr objectAtIndex:0];
        if([[self.UserInfo objectForKey:@"userName"] length] ==1){
            self.txtUserName.text =@"(还未取名字，赶紧取个名字吧⬇️)";
        }else{
            self.txtUserName.text = [self.UserInfo objectForKey:@"userName"];
        }
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新 "];
//        [self.tableView reloadData];
        
    }
}

@end
