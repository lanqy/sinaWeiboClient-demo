//
//  photoDetalViewController.h
//  Sina_weibo
//
//  Created by lanqy on 13-12-15.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MBProgressHUD.h"
@interface photoDetalViewController : UIViewController <UIScrollViewDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property(nonatomic,strong) UIImageView* imageView;
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) id photoItem;
-(void)sendPhotoByEmail;
-(void)saveToPhotoAlum;
@end
