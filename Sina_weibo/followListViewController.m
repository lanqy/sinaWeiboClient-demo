//
//  followListViewController.m
//  Sina_weibo
//
//  Created by lanqy on 13-11-19.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import "followListViewController.h"

#define kAppKey @"3242834701"
#define apiUrl @"https://api.weibo.com/2/"
@interface followListViewController ()

@end

@implementation followListViewController
@synthesize assToken = _assToken;
@synthesize userId = _userId;
@synthesize cid = _cid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self followerList];
    // Do any additional setup after loading the view from its nib.
}

- (void)followerList{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@friendships/friends.json?access_token=%@&source=%@&uid=%@",apiUrl,self.assToken,kAppKey,self.userId]];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    if(jsonData != nil)
    {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil){
           NSLog(@"%@", result);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
