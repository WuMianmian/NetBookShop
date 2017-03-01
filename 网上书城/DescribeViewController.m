//
//  DescribeViewController.m
//  网上书城
//
//  Created by happy on 2016/12/18.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "DescribeViewController.h"

@interface DescribeViewController ()
//**************************     UI控件声明   ***************************
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;

//**************************     自定义方法属性声明   ***************************
@property(nonatomic,strong)NSString* Sex;//性别
@end

@implementation DescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 按钮的点击事件
- (IBAction)closeTouchDown:(id)sender {
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:^{
        //        NSLog(@"you click the cancel , close the ModalView !");
    }];
}
- (IBAction)manTouchDown:(id)sender {
    [self.manButton setImage:[UIImage imageNamed:@"点-2"] forState:UIControlStateNormal];
    [self.womanButton setImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
    self.Sex = @"男";
    NSLog(@"%@",self.Sex);
}
- (IBAction)womanTouchDown:(id)sender {
    [self.manButton setImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
    [self.womanButton setImage:[UIImage imageNamed:@"点-2"] forState:UIControlStateNormal];
    self.Sex = @"女";
    NSLog(@"%@",self.Sex);
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
