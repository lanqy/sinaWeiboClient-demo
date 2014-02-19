//
//  AppDelegate.h
//  Sina_weibo
//
//  Created by lanqy on 13-11-4.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSString *asscessToken;

@property (strong, nonatomic) NSMutableString *weiboId;

@property (strong, nonatomic) NSString *loginUid;
@property (strong, nonatomic) NSMutableDictionary *params;

@end
