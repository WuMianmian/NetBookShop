//
//  OrderTableViewCell.h
//  网上书城
//
//  Created by happy on 2016/11/7.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *txtBookName;
@property (weak, nonatomic) IBOutlet UILabel *txtBookISBN;
@property (weak, nonatomic) IBOutlet UILabel *txtBookPrice;
@property (weak, nonatomic) IBOutlet UIImageView *bookimage;

@end
