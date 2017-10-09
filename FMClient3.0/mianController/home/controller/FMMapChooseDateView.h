//
//  FMMapChooseDateView.h
//  FMClient3.0
//
//  Created by YT on 2016/11/30.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMMapChooseDateView;

@protocol FMMapDateViewDelegate<NSObject>
@optional
-(void)mapDateView:(FMMapChooseDateView *)dateView andTimeValue:(NSString *)timeValue;

-(void)mapDateView:(FMMapChooseDateView *)dateView andDateBtnClick:(UIButton *)dateBtn;

-(void)mapDateViewBackClick:(FMMapChooseDateView *)dateView;

@end
@interface FMMapChooseDateView : UIView
@property (weak, nonatomic) IBOutlet UIView *chooseDateView;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseTimeView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;



@property(nonatomic,strong)NSString * dateValue;
@property (nonatomic,strong)NSString * spanValue;
@property(nonatomic,strong)NSString * timeValue;


@property (weak,nonatomic)id<FMMapDateViewDelegate>delegate;


- (IBAction)dateBtnClick:(id)sender;
- (IBAction)sureBtnClick:(id)sender;
- (IBAction)hiddenClick:(id)sender;


#pragma mark  ------- datePicker --------


@property (weak, nonatomic) IBOutlet UIView *pickerView;

@property (weak, nonatomic) IBOutlet UIView *pickBgView;

@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

- (IBAction)finishBtnClick:(id)sender;

@property (nonatomic,strong)NSArray * dataArray;


@end
