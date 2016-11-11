//
//  MyOrderListTableViewCell.h
//  网上书城
//
//  Created by happy on 2016/10/26.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderUserName;
@property (weak, nonatomic) IBOutlet UILabel *orderUserAddress;
@property (weak, nonatomic) IBOutlet UILabel *orderBookName;
@property (weak, nonatomic) IBOutlet UILabel *orderTotal;


@end
