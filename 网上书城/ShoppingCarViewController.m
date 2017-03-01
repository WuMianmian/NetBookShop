//
//  ShoppingCarViewController.m
//  网上书城
//
//  Created by happy on 2016/12/14.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarTableViewCell.h"
#import "Contents.h"
#import "ToolController.h"

@interface ShoppingCarViewController ()
@property(nonatomic,strong)NSMutableArray* allDataArr;
@property(nonatomic,strong)NSString* userId;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;



-(NSDictionary *)getDataWith:(NSString *)userId;
@end

@implementation ShoppingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userId = [userDefault objectForKey:@"UserId"];
    
    NSDictionary *dict = [self getDataWith:self.userId];
    self.allDataArr = [dict objectForKey:@"GetShoppingCarList"];
    
    //计算出购物车商品总价
    int i;
    NSString* allPriceStr;
    double allPrice = 0;
    NSDictionary *EachBooksData;
    for (i = 0; i < [self.allDataArr count]; i++) {
        EachBooksData=[self.allDataArr objectAtIndex:i];
        allPriceStr = [NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"bookPrice"]];
        allPrice = allPrice + [allPriceStr doubleValue];
    }
    self.allPriceLabel.text =[NSString localizedStringWithFormat:@"%.2f",allPrice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//通过URL 获取网络上的数据
-(NSDictionary *)getDataWith:(NSString *)userId{
    NSDictionary *AllBooksDict =[NSDictionary alloc];
    NSError *error;
    NSString *strUrlForBooks = [[NSString alloc]initWithFormat:@"%@/GetShoppingCar?userId=%@",Contents.getContentsUrl,userId];
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
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)[self.allDataArr count]);
    return [self.allDataArr count];
    
}
//当选中这一行需要做的事情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消被选中的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ShoppingCarCellID";
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[ShoppingCarTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    NSDictionary *EachBooksData=[self.allDataArr objectAtIndex:row];
    
    
    cell.txtBookName.text = [EachBooksData objectForKey:@"bookName"];
    cell.txtBookPrice.text =[NSString localizedStringWithFormat:@"%@",[EachBooksData objectForKey:@"bookPrice"]];
    cell.txtISBN.text = [EachBooksData objectForKey:@"bookISBN"];
    cell.txtbookNumber.text = @"1";
    
    ToolController *tool;
    tool = [[ToolController alloc]init];
    NSDictionary *dict = [tool getDataWith:[NSString stringWithFormat:@"/GetBookDescribe?bookISBN=%@",[EachBooksData objectForKey:@"bookISBN"]]];
    NSMutableArray* allDataArrForBook =[dict objectForKey:@"productlist"];
    NSDictionary *EachData=[allDataArrForBook objectAtIndex:0];
    NSString *imgUrlStr =[NSString stringWithFormat:@"%@/images/%@",Contents.getContentsUrl,[EachData objectForKey:@"bookImageId"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]]];
    [cell.bookImage setImage:image];
    
    
    [cell layoutSubviews];
    
    return cell;
}



@end
