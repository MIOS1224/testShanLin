//
//  EMManualLocViewController.m
//  emclient
//
//  Created by mqs on 14/10/23.
//  Copyright (c) 2014年 easymin. All rights reserved.
//

#import "EMManualLocViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "FMLocationManager.h"
#import "SVProgressHUD.h"
#import "iToast.h"
@interface EMManualLocViewController ()<UITableViewDataSource,UITableViewDelegate,BMKPoiSearchDelegate,UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>


//搜索返回的poi集合
@property (nonatomic,strong) NSMutableArray *address;
@property (strong,nonatomic) IBOutlet UITextField *textfield;

@property (strong,nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *topBgView;

@end

@implementation EMManualLocViewController

@synthesize textfield = _textfield;
@synthesize tableView = _tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTable];
    [self initTextField];
    
    [self nearByBtnClick:nil];
    
    self.topBgView.backgroundColor = [UIColor colorWithDtString:MYNAVIGATIONCOLORDATA];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"ManualLoc"];
    
    //加载搜索结果
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(nearbySearchResult:)
                                          name:kNearbySearchOptionSuccess
                                          object:nil];
    
    //加载当前位置信息
    [self loadDataFromLocal];

}
- (IBAction)backBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


//- (IBAction)confirmBtnClicked:(id)sender {
//    
//    [self.view endEditing:YES];
//    NSString *text = self.textfield.text;
//    [FMLocationManager sharedManager].keyWords = text;
//}
- (IBAction)nearByBtnClick:(id)sender {
    
    [FMLocationManager sharedManager].keyWords = [FMLocationManager sharedManager].currentAddress;
    [self.textfield endEditing:YES];
    self.textfield.text = @"";
    
}
#pragma mark - Init

- (void) initTable
{
    _address = [[NSMutableArray alloc] init];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)initTextField
{
    _textfield.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_address count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    BMKPoiInfo *poi = [_address objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicTableViewCell"];
    if (!cell) {
      cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"basicTableViewCell"];
    }
    
    cell.textLabel.text       = poi.name;
    cell.detailTextLabel.text = poi.address;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.textfield endEditing:YES];
    self.textfield.text = @"";
    
    BMKPoiInfo *poi = [_address objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([MYUtils isEmpty:poi.address] ) {
        [iToast makeText:@"位置信息获取错误，请重新选择 ！"];
        return;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(manualLocViewController:didSelectedPoi:)]) {
        [self.delegate manualLocViewController:self didSelectedPoi:poi];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"manulocaselect" object:nil userInfo:@{@"BMKPoiInfo":poi}];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - BMKLocationServiceDelegate

//获得当前搜索结果
-(void)nearbySearchResult:(NSNotification *)userInfo
{
    NSDictionary * dict = userInfo.userInfo;
    _address = dict[kSearchAddressArray];
    if (_address && _address.count != 0) {
        
        [_tableView reloadData];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *text = textField.text;
    NSString *key = [text stringByReplacingCharactersInRange:range withString:string];
    [FMLocationManager sharedManager].keyWords = key;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [FMLocationManager sharedManager].keyWords = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [FMLocationManager sharedManager].keyWords = textField.text;
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Handlers

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Method
-(void)loadCurrentLocationData:(NSNotification *)userinfo
{
    _address = [FMLocationManager sharedManager].addressArray;
   
}

- (void)loadDataFromLocal
{
    NSString *addr = [FMLocationManager sharedManager].currentAddress;
    CLLocationDegrees lat = [FMLocationManager sharedManager].currentLocation.location.coordinate.latitude;
    CLLocationDegrees lng = [FMLocationManager sharedManager].currentLocation.location.coordinate.longitude;

    
    if (addr && lat && lng) {
        
        BMKPoiInfo *poi = [[BMKPoiInfo alloc] init];
        poi.name = addr;
        poi.pt = CLLocationCoordinate2DMake(lat, lng);

        [_address addObject:poi];
        [_tableView reloadData];
        
    }else{
        
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeGradient)];
//        [SVProgressHUD showWithStatus:@"定位中..." maskType:SVProgressHUDMaskTypeGradient];
        [[FMLocationManager sharedManager]startLocationService];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
