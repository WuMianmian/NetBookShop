//
//  BookListTableViewCell.h
//  网上书城
//
//  Created by happy on 2016/10/22.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *BookImageUrl;
@property (weak, nonatomic) IBOutlet UILabel *BookName;
@property (weak, nonatomic) IBOutlet UILabel *BookPrice;
@property (weak, nonatomic) IBOutlet UILabel *BookWriter;
@property (weak, nonatomic) IBOutlet UILabel *BookDescride;

@end
