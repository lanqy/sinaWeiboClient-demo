//
//  DetailViewController.h
//  GuestBook
//
//  Created by lanqy on 13-11-4.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@class ReplyViewController;
@class UserInfoViewController;
@interface DetailViewController : UIViewController <UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) NSDictionary *selectRow;
@property (nonatomic, strong) id detailItem;
@property (nonatomic, strong) UILabel *gbName;
@property (nonatomic, strong) UIButton *gbreply;
@property (nonatomic, strong) UILabel *gbContent;
@property (nonatomic, strong) UILabel *publicTime;
@property (nonatomic, strong) UILabel *from;
@property (nonatomic, strong) ReplyViewController *detailReplyView;
@property (nonatomic, strong) UserInfoViewController *userInfoView;
@property (nonatomic, strong) UIScrollView *vc;
@property (nonatomic,strong) UIImageView *profireImgView;
@property (nonatomic,strong) UILabel *userLocation;
@property (nonatomic,strong) UIButton *goToUserInfo;
@property (nonatomic,strong) UITableView *detailTableView;
@end
