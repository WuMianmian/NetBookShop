//
//  ToolController.h
//  网上书城
//
//  Created by happy on 2016/11/8.
//  Copyright © 2016年 wumiaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ToolController : UIViewController<MBProgressHUDDelegate>
-(NSDictionary *)getDataWith:(NSString *)str;
-(void)showAlertMessageWith:(NSString *)showMessageStr;
-(void)ShowMessageWith:(NSString *)Message;
-(void)ShowLoadingWith:(NSString *)Message;
@end
