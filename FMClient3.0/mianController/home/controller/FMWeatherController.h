//
//  FMWeatherController.h
//  FMClient3.0
//
//  Created by YT on 2016/12/1.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMWeatherController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray * dataArr;

@end
