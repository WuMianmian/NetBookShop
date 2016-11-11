//
//  CategoryWithBooksTableViewController.m
//  网上书城
//
//  Created by happy on 2016/11/6.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "CategoryWithBooksTableViewController.h"
#import "BookListTableViewCell.h"
#import "ToolController.h"

@interface CategoryWithBooksTableViewController ()
@property(nonatomic,strong)NSMutableArray* allBooksDataArr;


@end

@implementation CategoryWithBooksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *CategoryDefault = [NSUserDefaults standardUserDefaults];
    NSString *categoryId = [CategoryDefault objectForKey:@"CategoryId"];
//    NSLog(@"get id is -------->%@",categoryId);
    
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSString* str = [NSString stringWithFormat:@"/GetCategoryBooks?Id=%@",categoryId];
    NSDictionary *dict = [tool getDataWith:str];
    self.allBooksDataArr = [dict objectForKey:@"productlist"];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    
    static NSString *cellIdentifier = @"CategoryBooksCellID";
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


@end
