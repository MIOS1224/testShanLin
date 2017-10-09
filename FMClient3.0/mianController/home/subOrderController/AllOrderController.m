//
//  AllOrderController.m
//  FMClient3.0
//
//  Created by YT on 16/8/18.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "AllOrderController.h"

@interface AllOrderController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation AllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"all",@"all",@"all",@"all",@"all",@"all",@"all",@"all",@"all",@"all",@"all"];
    [self addSubTableView];
    
}
-(void)addSubTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 43-49-64) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.allowsSelection = NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strBas = @"cellBasic";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strBas];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:strBas];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 1, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);

    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
    
//    switch (indexPath.row) {
//        case 0:
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
//            break;
//        case 1:
//            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
//            break;
//        case 2:
//            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
//            break;
//        case 3:
//            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
//            break;
//        default:
//            break;
//    }
    
    [UIView commitAnimations];
}
#pragma mark- cell 将要显示的时候调用这个方法，就在这个方法内进行圆角绘制
/**
 本质：就是修改cell的背景view，这个view的layer层自己分局cell的类型（顶，底和中间）来绘制
*/
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)])
    {
        CGFloat cornerRadius = 5.f;//圆角大小
        cell.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
        BOOL addLine = NO;
        
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            
        }
        else if (indexPath.row == 0)
        {   //最顶端的Cell（两个向下圆弧和一条线）
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        }
        else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        {   //最底端的Cell（两个向上的圆弧和一条线）
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        }
        else
        {   //中间的Cell
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor = [UIColor whiteColor].CGColor; //cell的填充颜色
        layer.strokeColor = [UIColor lightGrayColor].CGColor; //cell 的边框颜色
        
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
            lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;        //绘制中间间隔线
            [layer addSublayer:lineLayer];
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:bounds];
        [bgView.layer insertSublayer:layer atIndex:0];
        bgView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = bgView;
    }
}
@end
