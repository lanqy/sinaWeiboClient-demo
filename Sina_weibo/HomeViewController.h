//
//  HomeViewController.h
//  Sina_weibo
//
//  Created by lanqy on 13-11-28.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBEngine.h"
#import "MJRefresh/MJRefresh.h"
#import "WBLogInAlertView.h"

BOOL  hasRetwitter;
BOOL  haveRetwitterImage;
BOOL  hasImage;
@class DetailViewController;
@class ReplyViewController;
@class UserInfoViewController;
@class LoginUserInfoViewController;
BOOL  hasRetwitter;
BOOL  haveRetwitterImage;
BOOL  hasImage;

@interface HomeViewController : UIViewController <WBEngineDelegate,UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate,UIAlertViewDelegate,WBLogInAlertViewDelegate,UIGestureRecognizerDelegate,MJRefreshBaseViewDelegate>{
    WBEngine *weiBoEngine;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;

}

@property (nonatomic, strong) WBEngine *weiBoEngine;


@property (nonatomic, retain)NSString *appKey;
@property (nonatomic, retain)NSString *appSecret;
@property (nonatomic, retain)NSMutableArray *timeLine;
@property (nonatomic, retain)UITableView *timeLineTableView;
@property (nonatomic, retain)UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) ReplyViewController *replyViewController;
@property (nonatomic, retain) DetailViewController *detailViewController;
@property (nonatomic, retain) UserInfoViewController *userInfoViewController;
@property (nonatomic, retain) UIRefreshControl *refreshControl;


@property (nonatomic, retain) LoginUserInfoViewController *loginUserInfoViewController;
@property (nonatomic,strong) id LoginUserInfo;

@property (nonatomic,strong) id retweetedStatus;
@property (nonatomic,strong) id currentId;
@property (nonatomic,strong) id acessToken;
@property (nonatomic, assign) time_t createdAt;
@property (nonatomic,strong) NSMutableArray *favoriteIds;
@property (nonatomic,strong) UIMenuItem *commentItem;
@property (nonatomic,strong) UIMenuItem *retweetItem;
@property (nonatomic,strong) UIMenuItem *starItem;
@property (nonatomic,strong) UIMenuItem *actionItem;

@end
