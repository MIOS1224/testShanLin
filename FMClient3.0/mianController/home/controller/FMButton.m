//
//  FMButton.m
//  FMClient3.0
//
//  Created by YT on 2016/10/26.
//  Copyright © 2016年 YT.com. All rights reserved.
//
#define MYTabBarButtonImageRatio 0.6

#import "FMButton.h"

@implementation FMButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //        self.titleLabel.font = [UIFont fontWithName:FMSystemFont size:12];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithDtString:MYNAVIGATIONCOLORDATA] forState:UIControlStateSelected];
        
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted {}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * MYTabBarButtonImageRatio;
    return CGRectMake(0,3, imageW, imageH);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * MYTabBarButtonImageRatio + 2;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}
//- (void)setItem:(UITabBarItem *)item
//{
//    _item = item;
//    
//    // KVO 监听属性改变
//    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
//    [item addObserver:self forKeyPath:@"title"      options:0 context:nil];
//    [item addObserver:self forKeyPath:@"image"      options:0 context:nil];
//    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
//    
//    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
//}
//
//- (void)dealloc
//{
//    [self.item removeObserver:self forKeyPath:@"badgeValue"];
//    [self.item removeObserver:self forKeyPath:@"title"];
//    [self.item removeObserver:self forKeyPath:@"image"];
//    [self.item removeObserver:self forKeyPath:@"selectedImage"];
//}
//
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    
//    [self setTitle:self.item.title forState:UIControlStateSelected];
//    [self setTitle:self.item.title forState:UIControlStateNormal];
//    
//    
//    [self setImage:self.item.image forState:UIControlStateNormal];
//    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
//}


@end
