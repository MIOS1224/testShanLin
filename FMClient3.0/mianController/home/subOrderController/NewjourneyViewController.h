//
//  NewjourneyViewController.h
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MYBaseController.h"

@class NewjourneyViewController;

@protocol OrderViewDelegate<NSObject>
@required
-(void)OrderViewCtrl:( NewjourneyViewController *)orderView andIndexTag:(NSInteger)indexTag;

@end
@interface NewjourneyViewController : UIViewController

@property(nonatomic,weak)id<OrderViewDelegate> delegate;

@end
