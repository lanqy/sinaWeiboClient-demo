//
//  LQYCustomCell.m
//  Sina_weibo
//
//  Created by lanqy on 13-8-18.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import "LQYCustomCell.h"

@implementation LQYCustomCell

@synthesize name = _name;
@synthesize content = _content;
@synthesize ptime = _ptime;
@synthesize profile = _profile;
@synthesize imageView = _imageView;
@synthesize retweetView = _retweetView;
@synthesize retweetText = _retweetText;
@synthesize retweetImg = _retweetImg;
@synthesize arrow = _arrow;
@synthesize retweetUser = _retweetUser;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self BuildUiForTable];
    }
    return self;
}

- (void)BuildUiForTable
{
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 45, 45)];
    
    self.profile = [UIButton buttonWithType:UIButtonTypeCustom];
    self.profile.frame = CGRectMake(15, 10, 45, 45);
    
    [self.profile setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:self.imgView];
    
    [self addSubview:self.profile];
    self.ptime = [[UILabel alloc] initWithFrame:CGRectMake(225, 3, 80, 30)];
    self.ptime.textColor = [UIColor grayColor];
    self.ptime.font = [UIFont fontWithName:@"Arial" size:13.0f];
    self.ptime.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.ptime];

    // Initialization code
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(70, 3, 150, 30)];
    self.name.textColor = [UIColor grayColor];
    self.name.font = [UIFont fontWithName:@"Arial" size:17.0f];
    [self addSubview:self.name];
    
    
    self.content = [[UILabel alloc] initWithFrame:CGRectMake(70, 33, 240, 20)];
    self.content.textColor = [UIColor blackColor];
    self.content.numberOfLines = 0;
    [self.content setFont:[UIFont systemFontOfSize:17.0f]];
    [self addSubview:self.content];
    
    
    self.retweetView = [[UIView alloc] initWithFrame: CGRectMake ( 0, 80, 240, 150)];
    [self.retweetView setBackgroundColor:[UIColor whiteColor]];
    self.retweetView.layer.borderColor = [UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.2].CGColor;
    self.retweetView.layer.borderWidth = 0.5f;
    
    self.retweetUser = [UIButton buttonWithType:UIButtonTypeCustom];
    self.retweetUser.frame = CGRectMake(10, 3, 180, 30);
    [self.retweetUser setTitle:@"" forState:UIControlStateNormal];
    self.retweetUser.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.retweetUser setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.retweetView addSubview:self.retweetUser];
    
    self.retweetText = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 230, 30)];
    self.retweetText.textColor = [UIColor grayColor];
    self.retweetText.font = [UIFont fontWithName:@"Arial" size:16.0f];
    self.retweetText.numberOfLines = 0;
    [self.retweetView addSubview:self.retweetText];
    
    [self addSubview:self.retweetView];
    
    self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arror.png"]];
    self.arrow.frame = CGRectMake(90, 50, 22, 12);
    [self addSubview:self.arrow];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

  //   Configure the view for the selected state
}

@end
