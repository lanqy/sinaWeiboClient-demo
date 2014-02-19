//
//  PotosListViewController.h
//  Sina_weibo
//
//  Created by lanqy on 13-12-15.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class photoDetalViewController;
@interface PotosListViewController : UICollectionViewController<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) id photoList;
@property (nonatomic,strong) photoDetalViewController* phDetailview;
@end
