//
//  LoginUserInfoViewController.m
//  Sina_weibo
//
//  Created by lanqy on 13-11-17.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#define apiUrl @"https://api.weibo.com/2/"
#define kAppKey @"3242834701"
#define kAppSecret @"0f15121ac886c7b8195dd5e59607847e"
#import "AppDelegate.h"
#import "AFHTTPRequestOperation.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "LoginUserInfoViewController.h"
#import "UserInfoViewController.h"
#import "PotosListViewController.h"
#import "FavoriteListViewController.h"

@interface LoginUserInfoViewController () {
    
}

@end

@implementation LoginUserInfoViewController
@synthesize tableView = _tableView;
@synthesize photosView = _photosView;
@synthesize userInfoView = _userInfoView;
@synthesize profireImgView = _profireImgView;
@synthesize favoriteView = _favoriteView;
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
    //Initialization
    
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - 90)
                                                   style:UITableViewStyleGrouped];
    
    // assuming that your controller adopts the UITableViewDelegate and
    // UITableViewDataSource protocols, add the following 2 lines:
    
    tv.delegate = self;
    tv.dataSource = self;
    
    
    self.tableView = tv;
    
    [self.view addSubview:self.tableView];
    
    // 修改Navigation Bar Title text color
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.0];
    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor blackColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"我", @"");
    [label sizeToFit];
    [self getLoginUserInfo];
    //NSLog(@"%@", self.loginUserInfo);
}


- (void)viewWillAppear:(BOOL)animated
{
    //去掉选中的背景颜色
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //  NSLog(@"%d",section);
    
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 4;
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"%d",indexPath.row);
     NSLog(@"%d",indexPath.section);
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        // 跳用户信息页
        [self goToUserInfoView];
    }else if(indexPath.row == 0 && indexPath.section == 1){
        //私信
        
    }else if(indexPath.row == 1 && indexPath.section == 1){
        //收藏
        [self goToFavoriteList];
    }else if(indexPath.row == 2 && indexPath.section == 1){
        //草稿
    }else if(indexPath.row == 3 && indexPath.section == 1){
        // 相册
        [self goToPhotosListView];
        
    }else if(indexPath.row == 0 && indexPath.section == 2){
       // 设置
    }
    
}

-(void)goToFavoriteList
{
    
    if (!self.favoriteView) {
        self.favoriteView = [[FavoriteListViewController alloc] initWithNibName:@"FavoriteListViewController" bundle:nil];
    }
    
    //self.userInfoView.userInfo = self.loginUserInfo;
    self.favoriteView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.favoriteView animated:YES];
   
}

-(void)goToUserInfoView
{
    
    if (!self.userInfoView) {
        self.userInfoView = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    }
    
    self.userInfoView.userInfo = self.loginUserInfo;
    self.userInfoView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.userInfoView animated:YES];
 
}

-(void)goToPhotosListView
{
    if (!self.photosView) {
        self.photosView = [[PotosListViewController alloc] initWithNibName:@"PotosListViewController" bundle:nil];
    }
    
    // self.potosView.userInfo = [self.detailItem objectForKey:@"user"];
    self.photosView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.photosView animated:YES];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    int row = [indexPath row];
    if (indexPath.section == 0) {
        UITableViewCell *meCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if (meCell == nil) {
            meCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        self.profireImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        
        [self.profireImgView setImageWithURL:[NSURL URLWithString:[self.loginUserInfo objectForKey:@"profile_image_url"]]
                       placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]];
        [self.profireImgView.layer setBorderColor: [[UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.2] CGColor]];
        [self.profireImgView.layer setBorderWidth: 1.0];
        self.profireImgView.layer.cornerRadius = 22.5; // this value vary as per your desire
        self.profireImgView.layer.masksToBounds = YES;
        
        UILabel *gbName = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 270, 30)];
        gbName.textColor = [UIColor blackColor];
        gbName.font = [UIFont fontWithName:@"Arial" size:17.0f];
        gbName.text = [self.loginUserInfo objectForKey:@"screen_name"];
        UILabel *userLocation = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 270, 30)];
        
        userLocation.textColor = [UIColor grayColor];
        userLocation.font = [UIFont fontWithName:@"Arial" size:15.0f];
        userLocation.text = [self.loginUserInfo objectForKey:@"location"];
        meCell.tag = 1001;
        [meCell addSubview:self.profireImgView];
        [meCell addSubview:gbName];
        [meCell addSubview:userLocation];
        meCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //  定义点击背景颜色
        
        gbName.highlightedTextColor = [UIColor whiteColor];
        userLocation.highlightedTextColor = [UIColor whiteColor];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor blackColor];
        bgColorView.layer.masksToBounds = YES;
        [meCell setSelectedBackgroundView:bgColorView];
        
        return meCell;
    }else if (indexPath.section == 1) {
        
        UITableViewCell *listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        listCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        listCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //  定义点击背景颜色
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor blackColor];
        bgColorView.layer.masksToBounds = YES;
        [listCell setSelectedBackgroundView:bgColorView];
        if (row == 0)
        {
            listCell.textLabel.text = @"私信";
        }
        else if (row == 1)
        {
            listCell.textLabel.text = @"收藏";
        }
        else if (row == 2)
        {
            listCell.textLabel.text = @"草稿";
        }
        else
        {
            listCell.textLabel.text = @"照片";
        }
        
        return listCell;
    }else if (indexPath.section == 2){
        
        UITableViewCell *settingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        settingCell.textLabel.text = @"设置";
        settingCell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        settingCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        //  定义点击背景颜色
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor blackColor];
        bgColorView.layer.masksToBounds = YES;
        [settingCell setSelectedBackgroundView:bgColorView];
        return settingCell;
    }
    return NO;
}

// 获取登陆用户的信息
- (void)getLoginUserInfo
{
    
    
   // MBProgressHUD *custuonHUD = [[MBProgressHUD alloc] initWithView:self.view];
   // custuonHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
   // custuonHUD.labelText = @"发送成功！";
   // custuonHUD.mode = MBProgressHUDModeCustomView;
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"加载中...";
    //[self.view addSubview:HUD];
    [HUD show:YES];
    AppDelegate *appdg=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@users/show.json?access_token=%@&source=%@&uid=%@",apiUrl,appdg.asscessToken,kAppKey,appdg.loginUid]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"%@", responseObject);
        self.LoginUserInfo = responseObject;
        [HUD hide:YES afterDelay:0.1];
        [self.tableView reloadData];
    } failure:nil];
    [operation start];
    
    /*
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    if(jsonData != nil)
    {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil){
            self.LoginUserInfo = result;
        }
    }
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }
    return 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 禁止横竖屏

- (BOOL)shouldAutorotate
{
    //returns true if want to allow orientation change
    return FALSE;
    
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskAll;
    
}

@end

@implementation UINavigationController (RotationIn_IOS6)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject]  preferredInterfaceOrientationForPresentation];
}

@end
