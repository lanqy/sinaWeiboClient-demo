//
//  ViewController.m
//  Sina_weibo
//
//  Created by lanqy on 13-11-4.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//
#import "ViewController.h"
#import "DetailViewController.h"
#import "UserInfoViewController.h"
#import "LoginUserInfoViewController.h"
#define kAppKey @"3242834701"
#define kAppSecret @"0f15121ac886c7b8195dd5e59607847e"

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101
@interface ViewController ()

@end

@implementation ViewController

@synthesize weiBoEngine;
@synthesize timeLineViewController;
- (void)viewDidLoad
{
    [super viewDidLoad];
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.weiBoEngine = engine;
    [engine accessToken];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"加载中...";
    [self.view addSubview:HUD];
    [HUD show:YES];
    logInBtnOAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logInBtnOAuth setFrame:CGRectMake(85, 160, 150, 40)];
    [logInBtnOAuth setTitle:@"通过OAuth认证登陆" forState:UIControlStateNormal];
    [logInBtnOAuth addTarget:self action:@selector(onLogInOAuthButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logInBtnOAuth];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:CGPointMake(160, 240)];
    [self.view addSubview:indicatorView];

    if ([weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired])
    {
        logInBtnOAuth.hidden = YES;
        [self performSelector:@selector(presentTimelineViewControllerWithoutAnimation) withObject:nil afterDelay:0.0];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)onLogInOAuthButtonPressed
{
    [weiBoEngine setRedirectURI:@"http://www.baidu.com"];
    [weiBoEngine logIn];
}

- (void)onLogInXAuthButtonPressed
{
    WBLogInAlertView *logInView = [[WBLogInAlertView alloc] init];
    [logInView setDelegate:self];
    [logInView show];
}

- (void)onLogOutButtonPressed
{
    [weiBoEngine logOut];
}

- (void)dismissTimelineViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)presentTimelineViewController:(BOOL)animated
{
    WBSDKTimelineViewController *controller = [[WBSDKTimelineViewController alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    
    self.timeLineViewController = controller;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(onLogOutButtonPressed)];
   
    
    [controller.navigationItem setLeftBarButtonItem:leftBtn];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                target:controller
                                                                action:@selector(onSendButtonPressed)];
    
    
    [controller.navigationItem setRightBarButtonItem:rightBtn];
    
  //  NSLog(@"%@",self.timeLineViewController)
    
   // [controller.navigationItem setTitle:@"微博"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navController animated:animated];
    
}

- (void)presentTimelineViewControllerWithoutAnimation
{
    [self presentTimelineViewController:NO];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kWBAlertViewLogInTag)
    {
        [self presentTimelineViewController:YES];
    }
    else if (alertView.tag == kWBAlertViewLogOutTag)
    {
        [self dismissTimelineViewController];
    }
}

#pragma mark - WBLogInAlertViewDelegate Methods

- (void)logInAlertView:(WBLogInAlertView *)alertView logInWithUserID:(NSString *)userID password:(NSString *)password
{
    [weiBoEngine logInUsingUserID:userID password:password];
    
    [indicatorView startAnimating];
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    [indicatorView stopAnimating];
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"请先登出！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)engineDidLogIn:(WBEngine *)enginegit
{
    [indicatorView stopAnimating];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登录成功！"
													  delegate:self
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogInTag];
	[alertView show];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登录失败！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登出成功！"
													  delegate:self
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"请重新登录！"
													  delegate:nil
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
	[alertView show];
}



@end
