//
//  UserOrderViewController.m
//  网上书城
//
//  Created by happy on 2016/10/25.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "UserOrderViewController.h"

@interface UserOrderViewController ()

//@property(nonatomic,strong)NSString* UserId;

@end

@implementation UserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //用于接收 在UserInfo界面 传来的数据
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(GetUserInfoCompletion:)
//                                                name:@"OrderCompletionNotification"
//                                              object:nil];
}
/*
//接收从UserInfoViewController界面中回传回来的数据
-(void)GetUserInfoCompletion:(NSNotification *)notification{
    
    NSDictionary *GetData=[notification userInfo];
    self.UserId = [GetData objectForKey:@"userId"];
    NSLog(@"--back-Id---onOrderView--------> %@",self.UserId);
//    NSDictionary *getData = [self getUserInfoFor:self.UserId];
//    NSMutableArray *GetArr = [getData objectForKey:@"userinfolist"];
//    self.UserInfo = [GetArr objectAtIndex:0];
//    self.txtuserId.text = [NSString stringWithFormat:@"ID:%@", self.UserId ];
//    self.txtUserName.text = [self.UserInfo objectForKey:@"userName"];
}
 */
- (IBAction)btnBack:(id)sender {
    //关闭模态视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
