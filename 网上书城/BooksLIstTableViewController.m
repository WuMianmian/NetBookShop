//
//  BooksLIstTableViewController.m
//  网上书城
//
//  Created by happy on 2016/10/25.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "BooksLIstTableViewController.h"
#import "BookListTableViewCell.h"
#import "ToolController.h"

@interface BooksLIstTableViewController ()

@property(nonatomic,strong)NSMutableArray* allBooksDataArr;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
//-(NSDictionary *)getAllBooksData;
@end

@implementation BooksLIstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *SearchDefault = [NSUserDefaults standardUserDefaults];
    NSString *SearchName = [SearchDefault objectForKey:@"SearchName"];
//    NSLog(@"get this SearchName is %@",SearchName);
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSString *str;
    if(SearchName == nil){
        //http://192.168.0.137:8080/NetBookShop/GetBooks
        str = @"/GetBooks";
    }else{
        //http://192.168.0.137:8080/NetBookShop/SearchBook?SearchName=自
        str = [[NSString alloc] initWithFormat:@"/SearchBook?SearchName=%@",SearchName];
//        NSLog(@"执行了！！！！！"); 
//        str = @"/SearchBook?SearchName=:";
    }
    NSDictionary *dict = [tool getDataWith:str];
    self.allBooksDataArr = [dict objectForKey:@"productlist"];
//    NSLog(@"allbookdataarr is  %@",self.allBooksDataArr);
    if([self.allBooksDataArr count] == 0){
        [self showAlertMessageWith:@"没有查询到你需要的书本！"];
    }
}

//- (IBAction)btnBack:(id)sender {
//    NSUserDefaults *SearchDefault = [NSUserDefaults standardUserDefaults];
//    //移除UserDefaults中存储的用户信息
//    [SearchDefault removeObjectForKey:@"SearchName"];
//    [SearchDefault synchronize];
//    //关闭模态视图
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
     NSLog(@"the view is chose and here is be running !");
}
-(void)showAlertMessageWith:(NSString *)showMessageStr{
    UIAlertController *myAlertController = 	[UIAlertController alertControllerWithTitle:showMessageStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSLog(@"you click ok!");
        //点击按钮的响应事件；
        NSUserDefaults *SearchDefault = [NSUserDefaults standardUserDefaults];
        //移除UserDefaults中存储的用户信息
        [SearchDefault removeObjectForKey:@"SearchName"];
        [SearchDefault synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:myAlertController animated:true completion:nil];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.allBooksDataArr count];
}
//当选中这一行需要做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
//    NSLog(@" you click this %lu row",(unsigned long)row);
    NSDictionary *EachBooksData=[self.allBooksDataArr objectAtIndex:row];
    //获取Default单例
    NSUserDefaults *bookISBNDefault = [NSUserDefaults standardUserDefaults];
    //点击cell之后将id存在CategoryDefault中 用于传递
    [bookISBNDefault setObject:[EachBooksData objectForKey:@"bookISBN"] forKey:@"bookISBN"];
    [bookISBNDefault synchronize];
    
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"BooksCellID";
    BookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[BookListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *EachBooksData=[self.allBooksDataArr objectAtIndex:row];
    
    NSString *imgUrlStr =[NSString stringWithFormat:@"http://192.168.0.137:8080/NetBookShop/images/%@",[EachBooksData objectForKey:@"bookImageId"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
    [cell.BookImageUrl setImage:image];
    
    cell.BookName.text = [EachBooksData objectForKey:@"bookChineseName"];
//    NSLog(@"%@",[EachBooksData objectForKey:@"bookName"]);
    cell.BookPrice.text =[NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"bookPrice"]];
    cell.BookWriter.text = [EachBooksData objectForKey:@"bookWriter"];
    cell.BookDescride.text = [EachBooksData objectForKey:@"bookDescribe"];
    
    
    
    [cell layoutSubviews];
    
    return cell;
}

- (void)viewWillAppear {
    [super viewWillAppear:nil];
    // Dispose of any resources that can be recreated.
    
}


@end
