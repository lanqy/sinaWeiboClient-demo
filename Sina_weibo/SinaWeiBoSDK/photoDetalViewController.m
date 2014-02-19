//
//  photoDetalViewController.m
//  Sina_weibo
//
//  Created by lanqy on 13-12-15.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//
#import "photoDetalViewController.h"

#import "UIImageView+WebCache.h"
@interface photoDetalViewController ()

@end

@implementation photoDetalViewController
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
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
    
    CGRect screen = [UIScreen mainScreen].bounds;
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    [scrollView setMinimumZoomScale:1];
    [scrollView setMaximumZoomScale:3];
    [self.view addSubview:scrollView];
    NSLog(@"%@",self.photoItem);
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    [self.imageView setImageWithURL:[NSURL URLWithString:[self.photoItem objectForKey:@"original_pic"]]
                 placeholderImage:[UIImage imageNamed:@"default.png"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [scrollView setBackgroundColor:[UIColor blackColor]];
    [scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [tapGesture setNumberOfTapsRequired:2]; // 设置点击多少次 触发onTap方法
    
    [scrollView addGestureRecognizer:tapGesture];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, screen.size.width, 50)];
    [toolView setBackgroundColor:[UIColor blackColor]];
    toolView.alpha = 0.6;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismissImage:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"close-btn"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(10, 20, 25, 25);
    
    [toolView addSubview:closeBtn];
    
    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [actBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
    [actBtn setImage:[UIImage imageNamed:@"save-btn"] forState:UIControlStateNormal];
    actBtn.frame = CGRectMake(280, 20, 25, 25);
    [toolView addSubview:actBtn];
    
    [toolView setFrame:CGRectMake( 0.0f, -50.0f, screen.size.width, 50.0f)]; //notice this is OFF screen!
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:10];
    [toolView setFrame:CGRectMake( 0.0f, 0.0f, screen.size.width, 50.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    
    
    [self.view addSubview:toolView];
    
   [self.imageView setUserInteractionEnabled:YES]; // imageView 滑动事件默认是关闭的，设为YES表示打开，此时才可以用UISwipeGestureRecognizer
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    
    // 设置滑动方向.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionDown];
    
    // 滑动事件加到imageview
    [self.imageView addGestureRecognizer:swipeLeft];
    [self.imageView addGestureRecognizer:swipeRight];
}

//居中显示内容

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
   // UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)dismissImage:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleSwipeGesture:(UISwipeGestureRecognizer *) sender
{
    //判断滑动的方向
    if(sender.direction == UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@"up");
       // [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(sender.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"down");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.imageView setImageWithURL:[NSURL URLWithString:[self.photoItem objectForKey:@"original_pic"]]
                   placeholderImage:[UIImage imageNamed:@"default.png"]];
}


- (void)imageAction:(id)sender //
{
    NSString *actionSheetTitle = @""; //Action Sheet Title
    //  NSString *destructiveTitle = @""; //Action Sheet Button Titles
    NSString *other1 = @"通过电子邮件发送相片";
    NSString *other2 = @"保存到相册";
    NSString *cancelTitle = @"取消";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
															 delegate:self
													cancelButtonTitle:cancelTitle
											   destructiveButtonTitle:nil
													otherButtonTitles:other1, other2, nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"通过电子邮件发送相片"]) {
        [self sendPhotoByEmail];
    }
    if ([buttonTitle isEqualToString:@"保存到相册"]) {
        [self saveToPhotoAlum];
    }
    if ([buttonTitle isEqualToString:@"取消"]) {
        
    }
    
}
// 通过邮件发送图片
-(void)sendPhotoByEmail
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:nil];
    NSData *lionData = UIImageJPEGRepresentation(self.imageView.image, 1);
    [controller addAttachmentData:lionData mimeType:@"image/jpeg" fileName:@"photos.jpg"];
    //[controller setMessageBody:self.imageView.image isHTML:YES];
    if (controller){
        // [self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        [self showMessageTips:@"发送成功!"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 保存图片到相册
-(void)saveToPhotoAlum
{
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(saveImageTo:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
}

- (void)saveImageTo:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        NSLog(@"save error");
    } else {
        [self showMessageTips:@"已保存到相册！"];
    }
}

- (void)showMessageTips:(NSString *)message
{
    
    MBProgressHUD *custuonHUD = [[MBProgressHUD alloc] initWithView:self.view];
    custuonHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    custuonHUD.labelText = message;
    custuonHUD.mode = MBProgressHUDModeCustomView;
    [self.view addSubview:custuonHUD];
    [custuonHUD show:YES];
    [custuonHUD hide:YES afterDelay:1];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)onTap
{
    float scale = self.scrollView.zoomScale;
    if (scale > 1.5) {
        [self.scrollView setZoomScale:1 animated:YES];
    }else{
        [self.scrollView setZoomScale:3 animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
