//
//  OrderDetailController.h
//  FMClient3.0
//
//  Created by will on 17/1/13.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end


