//
//  ReplyViewController.h
//  Sina_weibo
//
//  Created by lanqy on 13-11-4.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "WBEngine.h"

@class ReplyViewController;

@protocol ReplyViewControllerDelegate <NSObject>

@end

@interface ReplyViewController : UIViewController <UITextViewDelegate,WBEngineDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSURLConnectionDataDelegate,MBProgressHUDDelegate>{
MBProgressHUD *HUD;
}
@property NSInteger msgId;
@property (nonatomic,strong) NSMutableString *atUser;
@property (nonatomic,strong) NSMutableString *tweet;
@property (strong,nonatomic) UITextView *msgArea;
@property(nonatomic,retain) WBEngine *engine;
@property (nonatomic,strong) UIButton *sendMsg;
@property (nonatomic,strong) UILabel *countText;
@property (nonatomic,strong) UIImageView *imgSend;
@property (nonatomic,strong) UIImagePickerController *imagePickercontroller;

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret text:(NSString *)text image:(UIImage *)image;

@end
