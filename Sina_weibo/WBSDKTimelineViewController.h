//
//  WBSDKTimelineViewController.h
//  SinaWeiBoSDKDemo
//
//  Created by Wang Buping on 11-12-15.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#define apiUrl @"https://api.weibo.com/2/"
#define kAppKey @"3242834701"
#define kAppSecret @"0f15121ac886c7b8195dd5e59607847e"
#import <UIKit/UIKit.h>
#import "WBEngine.h"
@interface WBSDKTimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate, WBEngineDelegate>
@property (nonatomic, retain)NSString *appKey;
@property (nonatomic, retain)NSString *appSecret;
@property (nonatomic, retain)NSMutableArray *timeLine;
@property (nonatomic, strong)WBEngine *engine;
@property (nonatomic,strong) id currentId;
@property (nonatomic,strong) id acessToken;
@property (strong, nonatomic) UITabBarController *tabBarController;
- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;
- (NSString*)formatTime;
- (NSDictionary*)getLoginUserInfo:(NSDictionary*)params;
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
@end
