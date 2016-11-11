//
//  HomeViewController.m
//  网上书城
//
//  Created by happy on 2016/10/26.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchName;

-(void)showAlertMessageWith:(NSString *)showMessageStr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop"];
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (jsonData == nil) {
        NSLog(@"is nil! ");
        [self showAlertMessageWith:@"网络出现异常！"];
    }

    //    图片的宽
    CGFloat imageW = self.myScrollView.frame.size.width;
    //    图片高
    CGFloat imageH = self.myScrollView.frame.size.height;
    
    NSLog(@"width is %f,height is %f",imageW,imageH);
    //    图片的Y
    CGFloat imageY = -64;
    //    图片中数
    NSInteger totalCount = 4;
    //   1.添加5张图片
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        //        图片X
        CGFloat imageX = i * imageW;
        //        设置frame
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //        设置图片
        NSString *name = [NSString stringWithFormat:@"Activity0%d.png", i + 1];
        imageView.image = [UIImage imageNamed:name];
        //        隐藏指示条
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        
        [self.myScrollView addSubview:imageView];
    }
    
    //    2.设置scrollview的滚动范围
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    self.myScrollView.contentSize = CGSizeMake(contentW, 0);
    
    //    3.设置分页
    self.myScrollView.pagingEnabled = YES;
    
    //    4.监听scrollview的滚动
    self.myScrollView.delegate = self;
    
    [self addTimer];
        
}
- (IBAction)btnClickAllBooks:(id)sender {
        NSUserDefaults *SearchDefault = [NSUserDefaults standardUserDefaults];
        //移除UserDefaults中存储的用户信息
        [SearchDefault removeObjectForKey:@"SearchName"];
        [SearchDefault synchronize];
}

-(void)showAlertMessageWith:(NSString *)showMessageStr{
    UIAlertController *myAlertController = 	[UIAlertController alertControllerWithTitle:showMessageStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"you click ok!");
        //点击按钮的响应事件；
        NSString *strUrl = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop"];
        NSURL *url = [[NSURL alloc] initWithString:strUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (jsonData == nil) {
            NSLog(@"is nil! ");
            [self showAlertMessageWith:@"网络出现异常！"];
        }
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
}
- (void)nextImage
{
    int page = (int)self.pageControl.currentPage;
    //NSLog(@"%d",page);
    if (page == 3) {
        page = 0;
    }else
    {
        page++;
    }
    
    //  滚动scrollview
    CGFloat x = page * self.myScrollView.frame.size.width;
    self.myScrollView.contentOffset = CGPointMake(x, -64);
}
// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"滚动中");
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    //    [self.timer invalidate];
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    [self addTimer];
}

/**
 *  开启定时器
 */
- (void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
/**
 *  关闭定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
}
- (IBAction)btnSearch:(id)sender {
    NSLog(@"search name is ------>%@",self.txtSearchName.text);
    
    //获取Default单例
    NSUserDefaults *SearchDefault = [NSUserDefaults standardUserDefaults];
    [SearchDefault setObject:self.txtSearchName.text forKey:@"SearchName"];
    [SearchDefault synchronize];
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


