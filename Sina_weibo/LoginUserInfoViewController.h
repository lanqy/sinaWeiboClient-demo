//
//  LoginUserInfoViewController.h
//  Sina_weibo
//
//  Created by lanqy on 13-11-17.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class PotosListViewController;
@class UserInfoViewController;
@class FavoriteListViewController;
@interface LoginUserInfoViewController :  UIViewController <UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>{
    //UITableView *tableView;
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) id loginUserInfo;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PotosListViewController *photosView;
@property (nonatomic,strong) UserInfoViewController *userInfoView;
@property (nonatomic,strong) FavoriteListViewController *favoriteView;
@property (nonatomic,strong) UIImageView *profireImgView;
@end

