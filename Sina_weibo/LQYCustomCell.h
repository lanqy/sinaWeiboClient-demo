//
//  LQYCustomCell.h
//  Sina_weibo
//
//  Created by lanqy on 13-8-18.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LQYCustomCell : UITableViewCell
@property(nonatomic,retain) UILabel *name;
@property(nonatomic,retain) UILabel *content;
@property(nonatomic,retain) UILabel *ptime;
@property(nonatomic,retain) UIButton *profile;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *retweetText;
@property(nonatomic,strong) UIButton *retweetUser;
@property(nonatomic,strong) UIImageView *retweetImg;
@property(nonatomic,strong) UIView *retweetView;
@property(nonatomic,strong) NSDictionary *retweetedStatus;
@property(nonatomic,strong) UIImageView *arrow;
@property(nonatomic,strong) UIImageView *tweetImg;
@property(nonatomic,strong) UIImageView *rtweetImg;
- (IBAction)doReply:(id)sender;
@end
