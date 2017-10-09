//
//  StateButton.m
//  FMClient3.0
//
//  Created by will on 16/12/15.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "StateButton.h"

@implementation StateButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor colorWithDtString:MYNAVIGATIONCOLORDATA] forState:(UIControlStateSelected)];
        [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 2;
        
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted {}

@end
