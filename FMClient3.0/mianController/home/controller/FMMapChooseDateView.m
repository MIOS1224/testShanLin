//
//  FMMapChooseDateView.m
//  FMClient3.0
//
//  Created by YT on 2016/11/30.
//  Copyright © 2016年 YT.com. All rights reserved.
//
#define  DATEHEIGHT 380

#import "FMMapChooseDateView.h"
#import "StateButton.h"
@interface FMMapChooseDateView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSMutableArray * btnArr;
@property(nonatomic,strong)UIButton * seclectBtn;

@property(nonatomic,strong)NSMutableArray * daysArr;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseTimeHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseDateHeight;

@end

@implementation FMMapChooseDateView

-(void)awakeFromNib
{
    [self configDateView];
    [super awakeFromNib];
    [self configDatePickerView];
    
}
-(void)configDateView
{
    self.chooseDateView.layer.cornerRadius = 5;
    self.dateBtn.layer.cornerRadius = 2;
    self.sureBtn.layer.cornerRadius = 4;
    self.topLabel.layer.cornerRadius = 5;
    self.topLabel.clipsToBounds = YES;
    self.topLabel.backgroundColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    self.sureBtn.backgroundColor  = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];

}

-(void)configDatePickerView
{
    
    self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 240);
    self.pickerView.hidden     = YES;
    self.datePicker.delegate   = self;
    self.datePicker.dataSource = self;
    [self addSubview:self.pickerView];
}
#pragma mark -----  时间点击 ------
-(void)chooseBtnClick:(UIButton *)btn
{
    if (self.seclectBtn == btn) {
        return;
    }
    btn.selected = YES;
    self.seclectBtn.selected = NO;
    self.seclectBtn = btn;
    self.timeValue  = btn.currentTitle;
    NSString * ddValue = [[self.timeValue componentsSeparatedByString:@"点"] firstObject];
    NSInteger  num = [ddValue integerValue];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:00-%ld:00",(long)num,num + 1];
    self.spanValue = [NSString stringWithFormat:@"%ld:00-%ld0",(long)num,num + 1];
    
//    NSLog(@"chooseBtnClick:::%@",btn.currentTitle);
    
    
}
#pragma mark ------  日期点击 --------
- (IBAction)dateBtnClick:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(mapDateView:andDateBtnClick:)]) {
        [self.delegate mapDateView:self andDateBtnClick:btn];
        
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGRect fram = self.chooseDateView.frame;
        fram.origin.y = 90;
        self.chooseDateView.frame = fram;
    
        self.pickerView.hidden = NO;
    }];

}

- (IBAction)sureBtnClick:(id)sender {
    
    if ([MYUtils isEmpty:self.dateValue]) {
        self.dateValue = [[self.dataArray firstObject] objectForKey:@"dt"];
    }
    NSString * ddValue = [[self.timeValue componentsSeparatedByString:@"点"] firstObject];
    NSInteger  num = [ddValue integerValue];
    
    NSString * time = [NSString stringWithFormat:@"%ld:00-%ld:00",(long)num,num + 1];
    self.spanValue = time;
    
    NSString * dateValue = [NSString stringWithFormat:@"%@  %@",self.dateValue,time];
    
    
    if ([self.delegate respondsToSelector:@selector(mapDateView:andTimeValue:)]) {
        [self.delegate mapDateView:self andTimeValue:dateValue];
        self.hidden = YES;
        
    }
}

- (IBAction)hiddenClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mapDateViewBackClick:)]) {
        [self.delegate mapDateViewBackClick:self];
    }
    self.hidden = YES;
}
#pragma mark -------  add data ----------

-(void)layoutSubviews
{
    [super layoutSubviews];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary * dict = [self.dataArray firstObject];
            [self addSubViewsDateViewWithArray:dict];
            
        });
    });
}
-(void)addSubViewsDateViewWithArray:(NSDictionary *)dataDict
{

    for (UIButton * obj in self.chooseTimeView.subviews) {
        if ([obj isKindOfClass:[StateButton class]]) {
            
            [obj removeFromSuperview];
            
        }
    }
    
    [self.dateBtn setTitle:[dataDict objectForKey:@"dt"] forState:(UIControlStateNormal)];
    
    
    NSArray * dateArr = [dataDict objectForKey:@"ts"];
          self.btnArr = [[NSMutableArray alloc]init];
    
    for ( NSInteger i = 0 ;i< dateArr.count;i++) {
        
        NSString * timeStr = [NSString stringWithFormat:@"%@%@",dateArr [i],@"点"];
        
        StateButton * btn = [[StateButton alloc]init];
        [btn setTitle:timeStr forState:(UIControlStateNormal)];
        btn.tag = 10000 + i;
        
        [btn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.chooseTimeView addSubview:btn];
        [self.btnArr addObject:btn];
        
        
    }
    
    [self chooseBtnClick:[self.btnArr firstObject]];
    
    
        
        NSInteger colIndex = self.btnArr.count/5;
        NSInteger rowIndex = self.btnArr.count%5;
        
        
        NSInteger colVlaue = 0;
        NSInteger rowValue = 0;
        if (rowIndex == 0) {
            self.chooseTimeHeight.constant = colIndex * 30;
            self.chooseDateHeight.constant = DATEHEIGHT - 134 + colIndex * 30;
            
            
            colVlaue = colIndex + 1;
            rowValue = 6;
            
        }else{
            
            self.chooseTimeHeight.constant = colIndex * 30 + 30;
            self.chooseDateHeight.constant = DATEHEIGHT - 134 + colIndex * 30 + 30;
            
            colVlaue = colIndex + 2;
            rowValue = rowIndex + 1;
        }
        
        
        int width  = (SCREEN_WIDTH - 95)/5;
        int height = 30;
        
        for (int i = 0; i < self.btnArr.count; ++i) {
            
            int row = i/5;
            int col = i%5;
            int appY   = (height + 3) * row;
            int appX   =  col * (width+3);
            
            UIButton *btn = self.btnArr[i];
            
            btn.frame = CGRectMake(appX, appY, width, height);
            
            
        }
}


#pragma mark ------- pickview delegate ------

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.dataArray[row] objectForKey:@"dt"];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.dateValue = [self.dataArray[row] objectForKey:@"dt"];
//    NSLog(@"UIPickerView==%@",self.dateValue);
     dispatch_async(dispatch_get_main_queue(), ^{
         
         [self addSubViewsDateViewWithArray:self.dataArray[row]];
         
     });
    
    
}
#pragma mark ---- sureBtnClick -------
- (IBAction)finishBtnClick:(id)sender {
    
    if ([MYUtils isEmpty:self.dateValue]) {
        self.dateValue = [[self.dataArray firstObject] objectForKey:@"dt"];
    }
    self.pickerView.hidden = YES;
    self.chooseDateView.center = self.center;
    self.dateBtn.titleLabel.text = self.dateValue;
    
    [self.dateBtn setTitle:self.dateValue forState:(UIControlStateNormal)];
    
    
    
}
@end
