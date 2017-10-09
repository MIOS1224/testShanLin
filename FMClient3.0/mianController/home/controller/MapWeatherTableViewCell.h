//
//  MapWeatherTableViewCell.h
//  FMClient3.0
//
//  Created by YT on 2016/12/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapWeatherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *washLabel;

@end
