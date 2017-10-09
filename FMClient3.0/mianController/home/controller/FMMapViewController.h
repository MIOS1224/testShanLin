//
//  FMMapViewController.h
//  FMClient3.0
//
//  Created by YT on 2016/11/25.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *detaileLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *abolishLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *chooseServerView;

@property (nonatomic,strong)NSDictionary * dictData;

- (IBAction)nextBtnClick:(id)sender;

@end
