//
//  DetailTwitterCell.h
//  Sina_weibo
//
//  Created by lanqy on 13-12-18.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTwitterCell : UITableViewCell
@property (nonatomic, strong) UILabel *gbName;
@property (nonatomic, strong) UILabel *gbContent;
@property (nonatomic, strong) UILabel *publicTime;
@property (nonatomic, strong) UILabel *from;
@property (nonatomic,strong) UIImageView *profireImgView;
@property (nonatomic,strong) UILabel *userLocation;
@end
