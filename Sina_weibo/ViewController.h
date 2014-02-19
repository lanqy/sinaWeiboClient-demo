//
//  ViewController.h
//  Sina_weibo
//
//  Created by lanqy on 13-11-4.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "ReplyViewController.h"
#import "WBLogInAlertView.h"
#import "MBProgressHUD.h"
#import "WBSDKTimelineViewController.h"

@interface ViewController : UIViewController<WBEngineDelegate,UIApplicationDelegate, UIAlertViewDelegate, WBLogInAlertViewDelegate,MBProgressHUDDelegate> {
    WBEngine *weiBoEngine;
    
    WBSDKTimelineViewController *timeLineViewController;
    UIActivityIndicatorView *indicatorView;

    UIButton *logInBtnOAuth;
    UIButton *logInBtnXAuth;
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) WBEngine *weiBoEngine;
@property (nonatomic, strong) WBSDKTimelineViewController *timeLineViewController;
@property (strong, nonatomic) UINavigationController *navigationController;



@end
