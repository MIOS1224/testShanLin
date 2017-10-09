//
//  MYBaseController.m
//  ShanShuiKe2.0
//
//  Created by YT on 16/6/2.
//  Copyright © 2016年 YT.com. All rights reserved.
//

#import "MYBaseController.h"
#import "Tools.h"
@interface MYBaseController ()<UIGestureRecognizerDelegate>
@end
@implementation MYBaseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([self.navigationController.viewControllers count]>=2) {
//        [self setBaseNavBackStyle];
//    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}
#pragma mark  -------  方法   -------------
- (void)setNavRightItem:(NSString*)str{
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    // Add your action to your button
    
    [customButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [customButton setTitle:str forState:UIControlStateNormal];
    [customButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 0, 0)];
    
    customButton.titleLabel.font          = [UIFont systemFontOfSize:15];
    customButton.titleLabel.textAlignment = NSTextAlignmentRight;
    customButton.backgroundColor          = [UIColor clearColor];
    
    CGSize size = [Tools sizeOfStr:str withFont:SystemFont(15) withMaxWidth:9999 withLineBreakMode:NSLineBreakByWordWrapping];
    
    customButton.frame = CGRectMake(0, 0, size.width+5, 40);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)setNavLeftNoImgItem:(NSString*)str{
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [customButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [customButton setTitle:str forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [customButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    customButton.titleLabel.font = [UIFont systemFontOfSize:15];
    customButton.backgroundColor = [UIColor clearColor];
    
    
    CGSize size = [Tools sizeOfStr:str withFont:customButton.titleLabel.font withMaxWidth:9999 withLineBreakMode:NSLineBreakByWordWrapping];
    
    customButton.frame = CGRectMake(0, 0, size.width, 40);
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    
    
}


- (void)rightBarButtonAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setNavLeftItem:(NSString*)str{
    
    CGFloat strWidth = [Tools sizeOfStr:str withFont:SystemFont(16) withMaxWidth:9999 withLineBreakMode:NSLineBreakByWordWrapping].width;
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, strWidth+18, 40)];
    
    [customButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [customButton setBackgroundImage:ImageNamed(@"backButton") forState:UIControlStateNormal];
    [customButton setTitle:str forState:UIControlStateNormal];

    
    [customButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [customButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    customButton.titleLabel.font = [UIFont systemFontOfSize:16];
    customButton.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *barButton   = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    // Set a value for the badge
    self.navigationItem.leftBarButtonItem = barButton;
    
}

- (void)leftBarButtonAction:(id)sender{
    
    UIViewController *v = [self.navigationController popViewControllerAnimated:YES];
    
    if (v == nil) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

- (void)setNavRightItemImage:(UIImage *)img
{
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    
    [customButton setBackgroundImage:img forState:UIControlStateNormal];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    [customButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
}

- (void)setNavRightItemImage:(UIImage *)img andSize:(CGSize)size
{
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [customButton setBackgroundImage:img forState:UIControlStateNormal];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    [customButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barButton;
    
}
-(void)setBaseNavBackStyle
{
    UIBarButtonItem * leftBtn  = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"tab_home.png")style:UIBarButtonItemStyleDone target:self action:@selector(backBtn)];
    self.navigationItem.leftBarButtonItem  = leftBtn;
    
    //修改导航栏颜色
    UINavigationBar * navBar = self.navigationController.navigationBar;
    [navBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
    navBar.barTintColor = [UIColor whiteColor];
    navBar.translucent  = NO;
    navBar.barStyle     = UIBarStyleBlack;
    NSMutableDictionary * textAtt = [NSMutableDictionary dictionary];
    textAtt[NSForegroundColorAttributeName] = [UIColor blackColor];
    [navBar setTitleTextAttributes:textAtt];
    
}
- (void)backBtn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)userDefaultsValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

- (id)userDefaultsForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

//配置基本的API路径
- (NSString*)buildApi:(NSString *)api
{
    MYBaseConfigUtils *cfg = [MYBaseConfigUtils sharedInstance];
    
    return [NSString stringWithFormat:@"http://%@/%@/%@",[cfg host],[cfg path],api];
}

//返回时间戳
- (NSString*)timestamp
{
    
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
    
    double timestamp = timeInterval * 1000;
    
    long long str = [[NSNumber numberWithDouble:timestamp] longLongValue];
    
    return [NSString stringWithFormat:@"%lld",str];
    
}
-(void)setTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

@end
