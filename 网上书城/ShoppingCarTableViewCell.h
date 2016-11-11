//
//  ShoppingCarTableViewCell.h
//  网上书城
//
//  Created by happy on 2016/11/6.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtBookName;
@property (weak, nonatomic) IBOutlet UILabel *txtBookPrice;
@property (weak, nonatomic) IBOutlet UILabel *txtISBN;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;

@property (weak, nonatomic) IBOutlet UILabel *txtbookNumber;
@end
