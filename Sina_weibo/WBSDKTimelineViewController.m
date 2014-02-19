//
//  WBSDKTimelineViewController.m
//  SinaWeiBoSDKDemo
//
//  Created by Wang Buping on 11-12-15.
//  Copyright (c) 2011 Sina. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "WBSDKTimelineViewController.h"
#import "MessageViewController.h"
#import "HomeViewController.h"
#import "LoginUserInfoViewController.h"
#import "UserInfoViewController.h"
#import "MessageListViewController.h"
#import "ReplyViewController.h"
#import "PersonalMedicineViewController.h"
@interface WBSDKTimelineViewController (Private)

@end
@implementation WBSDKTimelineViewController
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize engine = _engine;

#pragma mark - WBSDKTimelineViewController Life Circle

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    if (self = [super init])
    {
        self.appKey = theAppKey;
        self.appSecret = theAppSecret;
        
        self.engine = [[WBEngine alloc] initWithAppKey:self.appKey appSecret:self.appSecret];
        [self.engine setDelegate:self];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.asscessToken = [self.engine accessToken];
        app.loginUid = [self.engine userID];
        
        NSMutableDictionary *loginParams = [NSMutableDictionary dictionaryWithCapacity:2];
        [loginParams setObject:app.asscessToken forKey:@"access_token"];
        [loginParams setObject:app.loginUid forKey:@"uid"];
        
        app.params = loginParams;
       // [self getLoginUserInfo:params];

        
    }
    
    return self;
}



- (void)dealloc
{
    [self.engine setDelegate:nil];
   // [self.tableView setDelegate:nil];
   // [self.tableView setDataSource:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController = [[UITabBarController alloc] init];
    NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    HomeViewController *ptr_homeTab= [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *homeNavBar=[[UINavigationController alloc]initWithRootViewController:ptr_homeTab];
    // homeNavBar.tabBarItem.title=@"";
    homeNavBar.tabBarItem.image=[UIImage imageNamed:@"home.png"];
    
    
    MessageListViewController *myHospitalviewController=[[MessageListViewController alloc]initWithNibName:@"MessageListViewController" bundle:nil];
    UINavigationController *myHospitalNavBar=[[UINavigationController alloc]initWithRootViewController:myHospitalviewController];
    // myHospitalNavBar.title=@"My Hospital";
    myHospitalNavBar.tabBarItem.image=[UIImage imageNamed:@"email.png"];
    
    
    MessageViewController *viewController = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
    UINavigationController *hospitalNavBar=[[UINavigationController alloc]initWithRootViewController:viewController];
    // hospitalNavBar.tabBarItem.title=@"Hospital";
    hospitalNavBar.tabBarItem.image=[UIImage imageNamed:@"message.png"];
    
    
    LoginUserInfoViewController *ptr_PersonalMedicine = [[LoginUserInfoViewController alloc] initWithNibName:@"LoginUserInfoViewController" bundle:nil];
    UINavigationController *managerNavBar=[[UINavigationController alloc]initWithRootViewController:ptr_PersonalMedicine];
    // managerNavBar.tabBarItem.title=@"";
    managerNavBar.tabBarItem.image=[UIImage imageNamed:@"man.png"];
    
    
    [localViewControllersArray addObject:homeNavBar];
    [localViewControllersArray addObject:hospitalNavBar];
    [localViewControllersArray addObject:myHospitalNavBar];
    [localViewControllersArray addObject:managerNavBar];
    
    self.tabBarController.viewControllers = localViewControllersArray;
    self.tabBarController.view.autoresizingMask==(UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:self.tabBarController.view];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)handleLongPress
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
