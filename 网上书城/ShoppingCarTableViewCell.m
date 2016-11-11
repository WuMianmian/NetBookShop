//
//  ShoppingCarTableViewCell.m
//  网上书城
//
//  Created by happy on 2016/11/6.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import "ShoppingCarTableViewCell.h"

@implementation ShoppingCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)btnADD:(id)sender {
    NSLog(@"+");
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberFromStr = [numberFormatter numberFromString:self.txtbookNumber.text];
    int intNumber = [numberFromStr intValue];
    self.txtbookNumber.text = [NSString stringWithFormat:@"%d",intNumber++];
}
- (IBAction)btnSubtract:(id)sender {
    NSLog(@"-");
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberFromStr = [numberFormatter numberFromString:self.txtbookNumber.text];
    int intNumber = [numberFromStr intValue];
    if(intNumber > 0){
    self.txtbookNumber.text = [NSString stringWithFormat:@"%d",intNumber--];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
