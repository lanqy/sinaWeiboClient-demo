//
//  UserInfoViewController.h
//  Sina_weibo
//
//  Created by lanqy on 13-11-9.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController;
@class followListViewController;
@class FansListViewController;
@class FavoriteListViewController;
@class MessageListViewController;
@interface UserInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) id userInfo;
@property (nonatomic,strong) id cid;
@property (nonatomic,strong) id token;
@property (nonatomic,strong) DetailViewController *detailUserInfo;
@property (nonatomic,strong) followListViewController *followListView;
@property (nonatomic,strong) FansListViewController *fansListView;
@property (nonatomic,strong) FavoriteListViewController *favoriteListView;
@property (nonatomic,strong) MessageListViewController *messageListView;
@property (nonatomic,strong) UILabel *user;
@property (nonatomic,strong) UIImageView *userProfile;
@property (nonatomic,strong) UILabel *location;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *intro;
@property (nonatomic,strong) UILabel *follower;
@property (nonatomic,strong) UILabel *followerCount;
@property (nonatomic,strong) UILabel *following;
@property (nonatomic,strong) UILabel *followingCount;
@property (nonatomic,strong) UILabel *message;
@property (nonatomic,strong) UILabel *messageCount;
@property (nonatomic,strong) UILabel *mark;
@property (nonatomic,strong) UILabel *markCount;
@property (nonatomic,strong) UIButton *followBtn;
@property (nonatomic,strong) UIButton *cannelFollowBtn;
@property (nonatomic,strong) UILabel *navbarTitle;
@property (nonatomic,retain) UIScrollView *userViewScroll;
@property (nonatomic,strong) UIView *bottomline;
@property (nonatomic,strong) UIView *countTopLine;
@property (nonatomic,strong) UIView *countMiddleLine;
@property (nonatomic,strong) UIView *countBottomLine;
@property (nonatomic,strong) UIView *countVerticalMiddleLine;
@property (nonatomic,strong) UIButton *goTofollowListBtn;
@property (nonatomic,strong) UIButton *goTofollowingListBtn;
@property (nonatomic,strong) UIButton *goToMessageListBtn;
@property (nonatomic,strong) UIButton *goToFavoriteListBtn;

@property (nonatomic,strong) UITableView *userTableView;

@end
