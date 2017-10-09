//
//  FMAlertView.h
//  FMClient3.0
//
//  Created by YT on 2016/12/27.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>

@interface FMAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewHeight;

-(void)configAlertViewData:(NSString *)alertStr;

@end
