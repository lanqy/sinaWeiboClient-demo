//
//  DetailTwitterCell.m
//  Sina_weibo
//
//  Created by lanqy on 13-12-18.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import "DetailTwitterCell.h"

@implementation DetailTwitterCell
@synthesize gbName = _gbName;
@synthesize gbContent = _gbContent;
@synthesize from = _from;
@synthesize publicTime = _publicTime;
@synthesize profireImgView = _profireImgView;
@synthesize userLocation = _userLocation;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
