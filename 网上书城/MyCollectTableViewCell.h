//
//  MyCollectTableViewCell.h
//  网上书城
//
//  Created by happy on 2017/1/8.
//  Copyright © 2017年 wumiaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collectBookImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectBookName;
@property (weak, nonatomic) IBOutlet UILabel *collectBookISBN;
@property (weak, nonatomic) IBOutlet UILabel *collectBookPrice;

@end
