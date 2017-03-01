//
//  newRegisterViewController.m
//  网上书城
//
//  Created by happy on 2016/12/18.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "newRegisterViewController.h"

@interface newRegisterViewController ()

@end

@implementation newRegisterViewController

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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
