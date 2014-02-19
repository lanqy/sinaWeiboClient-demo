//
//  UserInfoViewController.m
//  Sina_weibo
//
//  Created by lanqy on 13-11-9.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#define FONT_SIZE 17.0f
#import "AppDelegate.h"
#import "UserInfoViewController.h"
#import "FansListViewController.h"
#import "followListViewController.h"
#import "FavoriteListViewController.h"
#import "MessageListViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

@synthesize user = _user;
@synthesize followBtn = _followBtn;
@synthesize location = _location;
@synthesize userName = _userName;
@synthesize userProfile = _userProfile;
@synthesize follower = _follower;
@synthesize following = _following;
@synthesize followingCount = _followingCount;
@synthesize followerCount = _followCount;
@synthesize message = _message;
@synthesize messageCount = _messageCount;
@synthesize cannelFollowBtn = _cannelFollowBtn;
@synthesize intro = _intro;
@synthesize navbarTitle = _navbarTitle;
@synthesize userViewScroll = _userViewScroll;
@synthesize bottomline = _bottomline;
@synthesize countTopLine = _countTopLine;
@synthesize countMiddleLine = _countMiddleLine;
@synthesize countBottomLine = _countBottomLine;
@synthesize mark = _mark;
@synthesize markCount = _markCount;
@synthesize countVerticalMiddleLine = _countVerticalMiddleLine;

@synthesize goTofollowListBtn = _goTofollowListBtn;
@synthesize goToFavoriteListBtn = _goToFavoriteListBtn;
@synthesize goTofollowingListBtn = _goTofollowingListBtn;
@synthesize goToMessageListBtn = _goToMessageListBtn;

@synthesize fansListView = _fansListView;
@synthesize favoriteListView = _favoriteListView;
@synthesize messageListView = _messageListView;
@synthesize followListView = _followListView;


@synthesize userTableView = _userTableView;
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

    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"详细"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
    

    
    // 修改Navigation Bar Title text color
    self.navbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    self.navbarTitle.backgroundColor = [UIColor clearColor];
    self.navbarTitle.font = [UIFont boldSystemFontOfSize:17.0];
    self.navbarTitle.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    self.navbarTitle.textColor = [UIColor blackColor]; // change this color
    self.navigationItem.titleView = self.navbarTitle;
    self.navbarTitle.text = [self.userInfo objectForKey:@"screen_name"];
    [self.navbarTitle sizeToFit];
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - 90)
                                                   style:UITableViewStyleGrouped];
    
    // assuming that your controller adopts the UITableViewDelegate and
    // UITableViewDataSource protocols, add the following 2 lines:
    
    tv.delegate = self;
    tv.dataSource = self;
    
    
    self.userTableView = tv;
    [self.view addSubview:self.userTableView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self refreshUserInfo];
    [self.userTableView reloadData];
    [super viewWillAppear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    //int row = [indexPath row];
    if (indexPath.row == 0 && indexPath.section == 0) {
 
        UITableViewCell *meCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        NSURL *url = [NSURL URLWithString:[self.userInfo objectForKey:@"profile_image_url"]];
        self.userProfile = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        [self.userProfile setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default.png"]];

        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 320, 30)];
        self.userName.textColor = [UIColor blackColor];
        self.userName.font = [UIFont fontWithName:@"Arial" size:17.0f];
        self.userName.text = [self.userInfo objectForKey:@"screen_name"];
        /*圆角实现
         [self.userProfile.layer setBorderColor: [[UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.2] CGColor]];
         [self.userProfile.layer setBorderWidth: 1.0];
         self.userProfile.layer.cornerRadius = 22.5; // this value vary as per your desire
         self.userProfile.layer.masksToBounds = YES;
         */
        self.location = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 270, 30)];
        self.location.textColor = [UIColor grayColor];
        self.location.font = [UIFont fontWithName:@"Arial" size:14.0f];
        self.location.text = [self.userInfo objectForKey:@"location"];
        
        meCell.tag = 1001;
        [meCell addSubview:self.userProfile];
        [meCell addSubview:self.userName];
        [meCell addSubview:self.location];
        meCell.userInteractionEnabled = NO; // 禁止点击
        return meCell;
        
    }else if(indexPath.section == 0 && indexPath.row == 1){
        
        UITableViewCell *introCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        self.intro = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 10)];
        self.intro.font = [UIFont fontWithName:@"Arial" size:17.0f];
        self.intro.text = [self.userInfo objectForKey:@"description"];
        self.intro.textColor = [UIColor blackColor];
        self.intro.numberOfLines = 0;
        [introCell addSubview:self.intro];
        [self.intro sizeToFit];
        introCell.userInteractionEnabled = NO;
        return introCell;
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        UITableViewCell *totalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
        self.countMiddleLine =[[UIView alloc] initWithFrame:CGRectMake(0,  50 , self.view.bounds.size.width, 0.5)];
        self.countMiddleLine.backgroundColor = [UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.1];
        [totalCell addSubview:self.countMiddleLine];
        

        self.countVerticalMiddleLine =[[UIView alloc] initWithFrame:CGRectMake(159, 0, 0.5f, 105)];
        self.countVerticalMiddleLine.backgroundColor = [UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.1];
        [totalCell addSubview:self.countVerticalMiddleLine];
        
        self.follower = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, 160,20)];
        
        self.follower.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.follower.text = @"正在关注";
        self.follower.textAlignment = NSTextAlignmentCenter;
        self.follower.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        [totalCell addSubview:self.follower];
        
        self.followerCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 160, 20)];
        self.followerCount.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.followerCount.text =[NSString stringWithFormat:@"%@", [self.userInfo objectForKey:@"friends_count"]];
        self.followerCount.textAlignment = NSTextAlignmentCenter;
        self.followerCount.textColor = [UIColor blackColor];
        [totalCell addSubview:self.followerCount];
        
        self.following = [[UILabel alloc] initWithFrame:CGRectMake(10, 78, 160, 20)];
        self.following.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.following.text = @"关注者";
        self.following.textAlignment = NSTextAlignmentCenter;
        self.following.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        [totalCell addSubview:self.following];
        
        
        self.followingCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 58, 160, 20)];
        self.followingCount.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.followingCount.text = [NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"followers_count"]];
        self.followingCount.textAlignment = NSTextAlignmentCenter;
        self.followingCount.textColor = [UIColor blackColor];
        
        [totalCell addSubview:self.followingCount];
        
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(160, 28, 160,20)];
        self.message.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.message.text = @"消息";
        self.message.textAlignment = NSTextAlignmentCenter;
        self.message.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        [totalCell addSubview:self.message];
        
        self.messageCount = [[UILabel alloc] initWithFrame:CGRectMake(160, 7, 160, 20)];
        self.messageCount.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.messageCount.text =[NSString stringWithFormat:@"%@", [self.userInfo objectForKey:@"statuses_count"]];
        self.messageCount.textAlignment = NSTextAlignmentCenter;
        self.messageCount.textColor = [UIColor blackColor];
        [totalCell addSubview:self.messageCount];
        
        
        self.mark = [[UILabel alloc] initWithFrame:CGRectMake(160, 78, 160, 20)];
        self.mark.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.mark.text = @"收藏";
        self.mark.textAlignment = NSTextAlignmentCenter;
        self.mark.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        [totalCell addSubview:self.mark];
        
        
        self.markCount = [[UILabel alloc] initWithFrame:CGRectMake(160,  58, 160, 20)];
        self.markCount.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.markCount.text = [NSString stringWithFormat:@"%@",[self.userInfo objectForKey:@"favourites_count"]];
        self.markCount.textAlignment = NSTextAlignmentCenter;
        self.markCount.textColor = [UIColor blackColor];
        [totalCell addSubview:self.markCount];
        totalCell.userInteractionEnabled = NO;
        return totalCell;
        
    }
    
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 65;
    }else if(indexPath.section == 0 && indexPath.row == 1){
        return [self getIntroHeight];
    }
    return 100;
}

- (CGFloat)getIntroHeight
{
    CGSize size = [[self.userInfo objectForKey:@"description"] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = size.height + 20;
    if (height <= 44) {
        return 60;
    }
    return height;
    
}

- (void)refreshUserInfo
{
    self.userName.text = [self.userInfo objectForKey:@"screen_name"];
    self.navigationItem.titleView = self.navbarTitle;
    self.navbarTitle.text = self.userName.text;
}

- (void)getFollowList:(id)sender
{

    if (!self.followListView) {
        self.followListView = [[followListViewController alloc] initWithNibName:@"followListViewController" bundle:nil];
    }
    
    self.followListView.assToken = self.token;
    self.followListView.userId = [self.userInfo objectForKey:@"id"];
    self.followListView.cid = self.cid;
    [self.navigationController pushViewController:self.followListView animated:YES];

}

- (void)getMessageList:(id)sender
{
    //
}

- (void)getFollowingList:(id)sender
{
    //
}


- (void)getFavoriteList:(id)sender
{
    //
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
