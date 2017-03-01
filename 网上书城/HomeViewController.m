//
//  HomeViewController.m
//  网上书城
//
//  Created by happy on 2016/10/26.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "HomeViewController.h"
#import "UserViewController.h"
#import "BooksLIstTableViewController.h"
#import "PersonalDetailsViewController.h"
#import "newLoginViewController.h"

#import "Contents.h"
#import "MBProgressHUD.h"

@interface HomeViewController ()

//**************************     UI控件声明   ***************************
@property (strong, nonatomic)  UIScrollView *homeScrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *location;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchName;
@property (strong ,nonatomic) UIImageView *fristImageView;
@property (strong ,nonatomic) UIImageView *secondImageView;
@property (strong ,nonatomic) UIImageView *thirdImageView;
@property (strong ,nonatomic) UIImageView *fourthImageView;
@property (strong ,nonatomic) UIView *homeUserInfoView;
@property (strong ,nonatomic) UIView *homeUserNameView;
@property (strong ,nonatomic) UILabel *homeUserNameLabel;
@property (strong ,nonatomic) UIButton *backHomeButton;
@property (weak ,nonatomic) IBOutlet UIButton *classificationButton;
@property (weak ,nonatomic) IBOutlet UIButton *allBooksButton;
@property (strong ,nonatomic) UIImageView *dividerImageView;
@property (weak ,nonatomic) IBOutlet UIButton *userInfoButton;
@property (weak ,nonatomic) IBOutlet UIButton *userOrderButton;
@property (weak ,nonatomic) IBOutlet UIButton *userCollectionButton;
@property (weak ,nonatomic) IBOutlet UIButton *userAddressButton;
@property (strong ,nonatomic) UIImageView *dividerImageView2;
@property (weak ,nonatomic) IBOutlet UIButton *setupButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;

@property (strong,nonatomic) MBProgressHUD *HUD;//提示窗口的声明

//**************************     自定义方法属性声明   ***************************
@property (nonatomic, strong) NSTimer *timer;
@property  int TimeCount;
@property int btnCount;

-(void)showAlertMessageWith:(NSString *)showMessageStr;
@end

@implementation HomeViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏的那些事
    
    self.navigationController.navigationBar.barTintColor = RGB(40, 43, 53);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:RGB(40, 43, 53)}];
    
    //    NSLog(@"the HomeScrollView width is  %f ,heght is  %f", self.homeScrollView.frame.size.width,self.homeScrollView.frame.size.height);
    
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.btnCount = 0;
    self.TimeCount = 0;
    
    [self.view addSubview:self.homeScrollView];
    [self.view addSubview:self.pageControl];
    [self.homeScrollView addSubview:self.fristImageView];
    [self.homeScrollView addSubview:self.secondImageView];
    [self.homeScrollView addSubview:self.thirdImageView];
    [self.homeScrollView addSubview:self.fourthImageView];
    
    [self.view addSubview:self.homeUserInfoView];
    [self.view bringSubviewToFront:self.homeUserInfoView];
    [self.homeUserInfoView addSubview:self.homeUserNameView];
    [self.homeUserNameView addSubview:self.homeUserNameLabel];
    [self.homeUserInfoView addSubview:self.backHomeButton];
    
    _classificationButton.frame = CGRectMake(40 , 180, 100, 20);
    [_classificationButton setTintColor:RGB(40, 43, 53)];
    [_classificationButton setTitle:@"选择商品分类" forState:UIControlStateNormal];
    [self.homeUserInfoView addSubview:self.classificationButton];
    
    _allBooksButton.frame = CGRectMake(40 , 220, 70, 20);
    [_allBooksButton setTintColor:RGB(40, 43, 53)];
    [_allBooksButton setTitle:@"全部商品" forState:UIControlStateNormal];
    [self.homeUserInfoView addSubview:self.allBooksButton];
    [self.homeUserInfoView addSubview:self.dividerImageView];
    
    _userInfoButton.frame = CGRectMake(40 , 280, 70, 20);
    [_userInfoButton setTintColor:RGB(40, 43, 53)];
    [_userInfoButton setTitle:@"我的信息" forState:UIControlStateNormal];
    [self.homeUserInfoView addSubview:self.userInfoButton];
    
    _userOrderButton.frame = CGRectMake(40 , 320, 70, 20);
    [_userOrderButton setTintColor:RGB(40, 43, 53)];
    [_userOrderButton setTitle:@"我的订单" forState:UIControlStateNormal];
    [self.homeUserInfoView addSubview:self.userOrderButton];
    
    _userCollectionButton.frame = CGRectMake(40 , 360, 70, 20);
    [_userCollectionButton setTintColor:RGB(40, 43, 53)];
    [_userCollectionButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [self.homeUserInfoView addSubview:self.userCollectionButton];
    
    _userAddressButton.frame = CGRectMake(40 , 400, 70, 20);
    [_userAddressButton setTintColor:RGB(40, 43, 53)];
    [_userAddressButton setTitle:@"我的地址" forState:UIControlStateNormal];
    [self.homeUserInfoView addSubview:self.userAddressButton];
    [self.homeUserInfoView addSubview:self.dividerImageView2];
    
    _setupButton.frame = CGRectMake(40 , 460, 40, 20);
    [_setupButton setTintColor:RGB(40, 43, 53)];
    [_setupButton setTitle:@"设置" forState:UIControlStateNormal];
    [self.homeUserInfoView addSubview:self.setupButton];
    //    bringSubviewToFront
    
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    
    NSString *strUrl = [[NSString alloc]initWithFormat:@"%@",Contents.getContentsUrl];
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (jsonData == nil) {
        NSLog(@"is nil! ");
        //        [self showAlertMessageWith:@"网络出现异常！"];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    //    //去掉导航栏的黑线
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    self.navigationController.navigationBar.barTintColor = RGB(40, 43, 53);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
-(UIScrollView *)homeScrollView{
    if (!_homeScrollView) {
        _homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, 160)];
        _homeScrollView.backgroundColor = [UIColor whiteColor];
        _homeScrollView.pagingEnabled = YES;
        _homeScrollView.showsHorizontalScrollIndicator = NO;//因为我们使用UIPageControl表示页面进度，所以取消UIScrollView自己的进度条
        _homeScrollView.bounces = NO;//取消UIScrollView的弹性属性
        _homeScrollView.delegate = self;
        [_homeScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 4,_homeScrollView.frame.size.height)];
    }
    return _homeScrollView;
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 ,248,0,0)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 4;
        _pageControl.currentPageIndicatorTintColor = RGB(40, 43, 53);
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.selected = YES;
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _pageControl;
}

//创建两个view放在ScrollView中
-(UIImageView *)fristImageView{
    if (!_fristImageView) {
        _fristImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0, 0, _homeScrollView.frame.size.width, _homeScrollView.frame.size.height)];
        _fristImageView.backgroundColor = [UIColor whiteColor];
        [_fristImageView setImage:[UIImage imageNamed:@"Activity01"]];
    }
    return _fristImageView;
}
-(UIImageView *)secondImageView{
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, _homeScrollView.frame.size.width, _homeScrollView.frame.size.height)];
        _secondImageView.backgroundColor = [UIColor blackColor];
        [_secondImageView setImage:[UIImage imageNamed:@"Activity02"]];
    }
    return _secondImageView;
}
-(UIImageView *)thirdImageView{
    if (!_thirdImageView) {
        _thirdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, _homeScrollView.frame.size.width, _homeScrollView.frame.size.height)];
        _thirdImageView.backgroundColor = [UIColor redColor];
        [_thirdImageView setImage:[UIImage imageNamed:@"Activity03"]];
    }
    return _thirdImageView;
}
-(UIImageView *)fourthImageView{
    if (!_fourthImageView) {
        _fourthImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, _homeScrollView.frame.size.width, _homeScrollView.frame.size.height)];
        _fourthImageView.backgroundColor = [UIColor blueColor];
        [_fourthImageView setImage:[UIImage imageNamed:@"Activity04"]];
    }
    return _fourthImageView;
}
-(UIView *)homeUserInfoView{
    if (!_homeUserInfoView) {
        _homeUserInfoView = [[UIView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH * 0.7, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT)];
        //        _homeUserInfoView.backgroundColor = RGB(40, 43, 53);
        _homeUserInfoView.backgroundColor = [UIColor whiteColor];
    }
    return _homeUserInfoView;
}
-(UIView *)homeUserNameView{
    if (!_homeUserNameView) {
        _homeUserNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, _homeUserInfoView.frame.size.width, _homeUserInfoView.frame.size.height/10)];
        _homeUserNameView.backgroundColor = RGB(40, 43, 53);
    }
    return _homeUserNameView;
}
-(UILabel *)homeUserNameLabel{
    if (!_homeUserNameLabel) {
        _homeUserNameLabel = [[UILabel alloc]init];
        _homeUserNameLabel.text = @"您好，欢迎光临！";
        //设置字体颜色
        _homeUserNameLabel.textColor = [UIColor whiteColor];
        //初始化段落，设置段落风格
        NSMutableParagraphStyle *paragraphstyle=[[NSMutableParagraphStyle alloc]init];
        paragraphstyle.lineBreakMode=NSLineBreakByCharWrapping;
        //设置label的字体和段落风格
        NSDictionary *dic=@{NSFontAttributeName:_homeUserNameLabel.font,NSParagraphStyleAttributeName:paragraphstyle.copy};
        //NSDictionary *dic=@{NSFontAttributeName:self.label.font};
        //计算label的真正大小,其中宽度和高度是由段落字数的多少来确定的，返回实际label的大小
        CGRect rect=[_homeUserNameLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        _homeUserNameLabel.frame = CGRectMake(22, 25, rect.size.width, rect.size.height);
    }
    return _homeUserNameLabel;
}
-(UIButton *)backHomeButton{
    if (!_backHomeButton) {
        _backHomeButton = [[UIButton alloc]init];
        _backHomeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _backHomeButton.frame = CGRectMake(40 , 140, 40, 20);
        [_backHomeButton setTintColor:RGB(40, 43, 53)];
        [_backHomeButton setTitle:@"首页" forState:UIControlStateNormal];
        [_backHomeButton addTarget:self action:@selector(backHomeTouchDown) forControlEvents:UIControlEventTouchDown];
        
    }
    return _backHomeButton;
}
-(UIButton *)classificationButton{
    if (!_classificationButton) {
        //        _classificationButton = [[UIButton alloc]init];
        _classificationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _classificationButton.frame = CGRectMake(40 , 180, 100, 20);
        [_classificationButton setTintColor:RGB(40, 43, 53)];
        [_classificationButton setTitle:@"选择商品分类" forState:UIControlStateNormal];
        [_classificationButton addTarget:self action:@selector(classificationTouchDown) forControlEvents:UIControlEventTouchDown];
        
    }
    return _classificationButton;
}
-(UIButton *)allBooksButton{
    if (!_allBooksButton) {
        _allBooksButton = [[UIButton alloc]init];
        _allBooksButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _allBooksButton.frame = CGRectMake(40 , 220, 70, 20);
        [_allBooksButton setTintColor:RGB(40, 43, 53)];
        [_allBooksButton setTitle:@"全部商品" forState:UIControlStateNormal];
        [_allBooksButton addTarget:self action:@selector(allBooksTouchDown) forControlEvents:UIControlEventTouchDown];
        
    }
    return _allBooksButton;
}
-(UIImageView *)dividerImageView{
    if (!_dividerImageView) {
        _dividerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 260, self.homeUserInfoView.frame.size.width, 0.7)];
        _dividerImageView.backgroundColor = [UIColor grayColor];
    }
    return _dividerImageView;
}
-(UIButton *)userInfoButton{
    if (!_userInfoButton) {
        _userInfoButton = [[UIButton alloc]init];
        _userInfoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _userInfoButton.frame = CGRectMake(40 , 280, 70, 20);
        [_userInfoButton setTintColor:RGB(40, 43, 53)];
        [_userInfoButton setTitle:@"我的信息" forState:UIControlStateNormal];
        [_userInfoButton addTarget:self action:@selector(userInfoTouchDown:) forControlEvents:UIControlEventTouchDown];
        
    }
    return _userInfoButton;
}
-(UIButton *)userOrderButton{
    if (!_userOrderButton) {
        _userOrderButton = [[UIButton alloc]init];
        _userOrderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _userOrderButton.frame = CGRectMake(40 , 320, 70, 20);
        [_userOrderButton setTintColor:RGB(40, 43, 53)];
        [_userOrderButton setTitle:@"我的订单" forState:UIControlStateNormal];
        [_userOrderButton addTarget:self action:@selector(userOrderTouchDown) forControlEvents:UIControlEventTouchDown];
        
    }
    return _userOrderButton;
}
-(UIButton *)userCollectionButton{
    if (!_userCollectionButton) {
        _userCollectionButton = [[UIButton alloc]init];
        _userCollectionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _userCollectionButton.frame = CGRectMake(40 , 360, 70, 20);
        [_userCollectionButton setTintColor:RGB(40, 43, 53)];
        [_userCollectionButton setTitle:@"我的收藏" forState:UIControlStateNormal];
        [_userCollectionButton addTarget:self action:@selector(userCollectionTouchDown) forControlEvents:UIControlEventTouchDown];
        
    }
    return _userCollectionButton;
}
-(UIButton *)userAddressButton{
    if (!_userAddressButton) {
        _userAddressButton = [[UIButton alloc]init];
        _userAddressButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _userAddressButton.frame = CGRectMake(40 , 400, 70, 20);
        [_userAddressButton setTintColor:RGB(40, 43, 53)];
        [_userAddressButton setTitle:@"我的地址" forState:UIControlStateNormal];
        [_userAddressButton addTarget:self action:@selector(userAddressTouchDown) forControlEvents:UIControlEventTouchDown];
        
    }
    return _userAddressButton;
}
-(UIImageView *)dividerImageView2{
    if (!_dividerImageView2) {
        _dividerImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 440, self.homeUserInfoView.frame.size.width, 0.7)];
        _dividerImageView2.backgroundColor = [UIColor grayColor];
    }
    return _dividerImageView2;
}

-(UIButton *)setupButton{
    if (!_setupButton) {
        _setupButton = [[UIButton alloc]init];
        _setupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _setupButton.frame = CGRectMake(40 , 460, 40, 20);
        [_setupButton setTintColor:RGB(40, 43, 53)];
        [_setupButton setTitle:@"设置" forState:UIControlStateNormal];
        [_setupButton addTarget:self action:@selector(setupTouchDown) forControlEvents:UIControlEventTouchDown];
        
    }
    return _setupButton;
}
#pragma mark - 按钮的点击事件
-(void)backHomeTouchDown{
    [self ShowMessageWith:@"首页"];
    //    NSLog(@"you touch me !");
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    self.btnCount ++;
    [_leftBarButton setImage:[UIImage imageNamed:@"更多"]];
    _homeUserInfoView.frame = CGRectMake(-SCREEN_WIDTH * 0.7, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT);
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:nil];
    [UIView commitAnimations];
}
-(void)classificationTouchDown{
    [self ShowMessageWith:@"选择商品分类"];
    //    [HomeViewController  pushViewController:BooksLIstTableViewController  animated:YES];
    //    [self presentModalViewController:BooksLIstTableViewController animated:YES];
    BooksLIstTableViewController *books = [[BooksLIstTableViewController alloc] init];
    [self.navigationController pushViewController:books animated:YES];
}
-(void)allBooksTouchDown{
    [self ShowMessageWith:@"全部商品"];
}
-(IBAction )userInfoTouchDown:(id)sender{
    [self ShowMessageWith:@"我的信息"];
    PersonalDetailsViewController *books = [PersonalDetailsViewController new];
    [self.navigationController pushViewController:books animated:YES];
}
-(void)userOrderTouchDown{
    [self ShowMessageWith:@"我的订单"];
}
-(void)userCollectionTouchDown{
    [self ShowMessageWith:@"我的收藏"];
}
-(void)userAddressTouchDown{
    [self ShowMessageWith:@"我的地址"];
}
-(void)setupTouchDown{
    [self ShowMessageWith:@"设置"];
}
- (IBAction)MoreTouchDown:(UIBarButtonItem *)sender {
    //    NSLog(@"you touch me !");
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    self.btnCount ++;
    if (self.btnCount % 2) {
        [_leftBarButton setImage:[UIImage imageNamed:@"返回Home"]];
        _homeUserInfoView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT);
    }else{
        [_leftBarButton setImage:[UIImage imageNamed:@"更多"]];
        _homeUserInfoView.frame = CGRectMake(-SCREEN_WIDTH * 0.7, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT);
        
    }
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:nil];
    [UIView commitAnimations];
}
- (IBAction)btnClickAllBooks:(id)sender {
    NSUserDefaults *SearchDefault = [NSUserDefaults standardUserDefaults];
    //移除UserDefaults中存储的用户信息
    [SearchDefault removeObjectForKey:@"SearchName"];
    [SearchDefault synchronize];
}
- (IBAction)btnSearch:(id)sender {
    NSLog(@"search name is ------>%@",self.txtSearchName.text);
    
    //获取Default单例
    NSUserDefaults *SearchDefault = [NSUserDefaults standardUserDefaults];
    [SearchDefault setObject:self.txtSearchName.text forKey:@"SearchName"];
    [SearchDefault synchronize];
}

#pragma mark - scrollview逻辑方法
//定时滚动
-(void)scrollTimer{
    self.TimeCount ++;
    if (self.TimeCount == 4) {
        self.TimeCount = 0;
    }
    [self.homeScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * self.TimeCount, 0, _homeScrollView.frame.size.width, _homeScrollView.frame.size.height) animated:YES];
    [self.pageControl setCurrentPage:self.TimeCount];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.pageControl setCurrentPage:offset.x / bounds.size.width];
}
#pragma mark - pageControll逻辑方法
-(void)pageTurn:(UIPageControl*)sender{
    CGSize viewSize = self.homeScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [self.homeScrollView scrollRectToVisible:rect animated:YES];
}

#pragma mark - 自定义工具方法
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
-(void)showAlertMessageWith:(NSString *)showMessageStr{
    UIAlertController *myAlertController = 	[UIAlertController alertControllerWithTitle:showMessageStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"you click ok!");
        //点击按钮的响应事件；
        NSString *strUrl = [[NSString alloc]initWithFormat:@"%@",Contents.getContentsUrl];
        NSURL *url = [[NSURL alloc] initWithString:strUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (jsonData == nil) {
            NSLog(@"is nil! ");
            [self ShowMessageWith:@"网络出现异常！"];
        }
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
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
    NSLog(@"键盘开启！");
}
-(void) keyboardDidHide: (NSNotification *)notif{
    NSLog(@"键盘关闭！");
}




@end


