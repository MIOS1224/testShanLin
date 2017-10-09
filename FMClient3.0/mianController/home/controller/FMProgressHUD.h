//
//  FMProgressHUD.h
//  FMClient3.0
//
//  Created by YT on 2017/2/22.
//  Copyright © 2017年 YT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface FMProgressHUD : UIView

@property(nonatomic,strong)MBProgressHUD * hud;


+(instancetype)sharedManager;
-(void)showProgress:(UIView *)baseView WithTextValue:(NSString *)textValue;
-(void)dismiss;

@end
