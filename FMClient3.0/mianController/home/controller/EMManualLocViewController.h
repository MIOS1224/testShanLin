//
//  EMManualLocViewController.h
//  emclient
//
//  Created by mqs on 14/10/23.
//  Copyright (c) 2014年 easymin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBaseController.h"

@class BMKPoiInfo;
@class EMManualLocViewController;

@protocol ManualLocDelegate <NSObject>

@required

- (void)manualLocViewController:(EMManualLocViewController*)ctrl didSelectedPoi:(BMKPoiInfo*)poi;

@end

@interface EMManualLocViewController : MYBaseController

- (IBAction)back:(id)sender;

@property(nonatomic,assign) id<ManualLocDelegate> delegate;

@end
