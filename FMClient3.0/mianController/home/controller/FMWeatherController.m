//
//  FMWeatherController.m
//  FMClient3.0
//
//  Created by YT on 2016/12/1.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "FMWeatherController.h"
#import "MapWeatherTableViewCell.h"
#import "WeatherInfo.h"
#import "FMLocationManager.h"

@interface FMWeatherController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FMWeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * city = [FMLocationManager sharedManager].currentCity;
    
    self.title = [NSString stringWithFormat:@"%@(%@)",@"洗车指数",city];
    [self configNavBar];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(void)configNavBar
{
    [self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"map.jpg"]]];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",@"车辆停放位置"];
    UIImage * image = [UIImage imageNamed:@"back.png"];
    if (IOS7) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc]initWithImage:image style:(UIBarButtonItemStyleDone) target:self action:@selector(backBtnClick)];
    
    self.navigationItem.leftBarButtonItem  = leftBar;
    
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * dayArray = @[@"今天",@"明天",@"后天"];
    static NSString * strBas = @"cellBasic";
    MapWeatherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strBas];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MapWeatherTableViewCell" owner:self options:nil] firstObject];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    NSDateFormatter * formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"MM月dd日"];
    NSString * dateStr = [formate stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24* 3600 * indexPath.row]];

    cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",dayArray[indexPath.row],dateStr];
    if (self.dataArr) {
        
        NSDictionary * dict = self.dataArr[indexPath.row];
        NSString * dayStr = @"白天";
        NSString * fabValue = [dict objectForKey:@"fa"];
        if ([MYUtils isEmpty:fabValue]) {
            fabValue = [dict objectForKey:@"fb"];
            dayStr = @"夜晚";
        }
        NSString * fcdValue = [dict objectForKey:@"fc"];
        if ([MYUtils isEmpty:fcdValue]) {
            fcdValue =  [dict objectForKey:@"fd"];
        }
        
        cell.weatherLabel.text = [NSString stringWithFormat:@"%@  %@℃%@",dayStr,fcdValue,[WeatherInfo analysisWeatherInfoWith:fabValue]];
        cell.washLabel.text = [WeatherInfo washCarDataWith:[fabValue integerValue]];
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


@end
