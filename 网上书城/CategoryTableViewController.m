//
//  CategoryTableViewController.m
//  网上书城
//
//  Created by happy on 2016/11/6.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "ToolController.h"

@interface CategoryTableViewController ()
@property(nonatomic,strong)NSMutableArray* allDataArr;
@end

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏的那些事
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:RGB(40, 43, 53)}];
    self.navigationController.navigationBar.tintColor  = RGB(40, 43, 53);
    
    //http://192.168.0.137:8080/NetBookShop/GetCategory
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSString* str = @"/GetCategory";
    NSDictionary *dict = [tool getDataWith:str];
    self.allDataArr = [dict objectForKey:@"CategoryList"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allDataArr count];
}
//当选中这一行需要做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    //    NSLog(@" you click this %lu row",(unsigned long)row);
    
    //获取Default单例
    NSUserDefaults *CategoryDefault = [NSUserDefaults standardUserDefaults];
    //点击cell之后将id存在CategoryDefault中 用于传递
    [CategoryDefault setObject:[NSString stringWithFormat:@"%lu",row+1] forKey:@"CategoryId"];
    //        [userDefaults setObject:self.textPassWord.text forKey:@"password"];
    [CategoryDefault synchronize];
    
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CategoryCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:row];
    
    cell.textLabel.text = [EachBooksData objectForKey:@"categoryName"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



@end
