//
//  ViewController.m
//  网上书城
//
//  Created by happy on 16/9/22.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ViewController.h"
#import "BookListTableViewCell.h"

@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *LeftPage;
@property (weak, nonatomic) IBOutlet UIView *RightPage;



@property(nonatomic,strong)NSMutableArray* allBooksDataArr;

//用于记录点击btn的按钮的次数  以便于用于判断是否要显示View
@property int LeftCount;
@property int RightCount;

-(NSDictionary *)getAllBooksData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

//***********************************以下是TableView的界面************************************

//通过URL 获取网络上的数据
-(NSDictionary *)getAllBooksData{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"http://192.168.0.137:8080/NetBookShop/Bookproduct"];
    NSURL *urlForBooks = [[NSURL alloc] initWithString:strUrlForBooks];
    NSURLRequest *requestForBooks = [NSURLRequest requestWithURL:urlForBooks];
    NSData *jsonDataForBooks = [NSURLConnection sendSynchronousRequest:requestForBooks returningResponse:nil error:nil];
    
    if (jsonDataForBooks == nil) {
        NSLog(@"is nil! ");
    }else{
        AllBooksDict = [NSJSONSerialization JSONObjectWithData:jsonDataForBooks options:NSJSONReadingMutableLeaves error:&error];
        return AllBooksDict;
    }
    return nil;
}


////当选中这一行需要做的事情
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //取消被选中的这行
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return [self.allBooksDataArr count];
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//        static NSString *cellIdentifier = @"BooksCellID";
//        BookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if(cell == nil){
//            cell = [[BookListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        }
//    
//        NSUInteger row = [indexPath row];
//        
//        NSDictionary *EachBooksData=[self.allBooksDataArr objectAtIndex:row];
//        
//        NSString *imgUrlStr =[EachBooksData objectForKey:@"bookImageId"];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
//        [cell.BookImageUrl setImage:image];
//
//        cell.BookName.text = [EachBooksData objectForKey:@"bookName"];
//        NSLog(@"this  isi sdsadasd  %@", [EachBooksData objectForKey:@"bookName"]);
//        cell.BookPrice.text = [EachBooksData objectForKey:@"bookPrice"];
//        cell.BookWriter.text = [EachBooksData objectForKey:@"bookWriter"];
//        cell.BookDescride.text = [EachBooksData objectForKey:@"bookDescride"];
//
//    
//    
//        [cell layoutSubviews];
//        
//        return cell;
//}
//
//

//*************************************************************************************


//***********************************以下是左右滑动的页面************************************
- (IBAction)RightBtn:(UIBarButtonItem *)sender {
    NSLog(@"you click Right !");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    
    //显示pickerview 控件 将pickerview控件放在屏幕下面
    
    //    CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    self.RightCount ++;
    if (self.RightCount % 2 == 1) {
        //显示view 控件 将pickerview控件放在屏幕下面
        self.RightPage.frame = CGRectMake(95, 64, 280, 603);
        //    CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    else{
        self.RightPage.frame = CGRectMake(377, 64, 280, 603);
    }
    
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:nil];
    [UIView commitAnimations];
    
}
- (IBAction)LeftBtn:(UIBarButtonItem *)sender {
    NSLog(@"you click left !");

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数

    //显示pickerview 控件 将pickerview控件放在屏幕下面

    //    CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    self.LeftCount ++;
    if (self.LeftCount % 2 == 1) {
        //显示view 控件 将pickerview控件放在屏幕下面
        self.LeftPage.frame = CGRectMake(0, 64, 280, 603);
        //    CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    else{
        self.LeftPage.frame = CGRectMake(-280, 64, 280, 603);
    }
 
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:nil];
    [UIView commitAnimations];
}
//*************************************************************************************

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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
