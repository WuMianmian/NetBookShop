//
//  ContactUsViewController.m
//  网上书城
//
//  Created by happy on 2016/12/18.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ContactUsViewController.h"
#import "WhiteWaterWaveView.h"

@interface ContactUsViewController ()

//**************************     UI控件声明   ***************************
@property (weak, nonatomic) IBOutlet UIView *tailView;
@end

@implementation ContactUsViewController

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
    
    [self ShowWaterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI控件的设置
- (void)ShowWaterView
{
    WhiteWaterWaveView *waterWaveView = [[WhiteWaterWaveView alloc]initWithFrame:CGRectMake(0, 0, self.tailView.frame.size.width, self.tailView.frame.size.height)];
    [self.tailView addSubview:waterWaveView];
    [self.tailView sendSubviewToBack:waterWaveView];
    
}

#pragma mark - 按钮的点击事件
- (IBAction)closeTouchDown:(id)sender {
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:^{
        //        NSLog(@"you click the cancel , close the ModalView !");
    }];
}


@end
