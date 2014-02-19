//
//  DetailViewController.m
//  GuestBook
//
//  Created by lanqy on 13-11-4.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#define FONT_SIZE 17.0f
#import "DetailViewController.h"
#import "UILabel+dynamicSizeMe.h"
#import "ReplyViewController.h"
#import "UserInfoViewController.h"
#import "NSString_stripHtml.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize gbName = _gbName;
@synthesize gbContent = _gbContent;
@synthesize gbreply = _gbreply;
@synthesize from = _from;
@synthesize publicTime = _publicTime;
@synthesize vc = _vc;
@synthesize detailReplyView = _detailReplyView;
@synthesize userInfoView = _userInfoView;
@synthesize profireImgView = _profireImgView;
@synthesize userLocation = _userLocation;
@synthesize goToUserInfo = _goToUserInfo;
@synthesize detailTableView = _detailTableView;

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
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"首页"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
    

    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height)
                                                   style:UITableViewStylePlain];
    
    tv.delegate = self;
    tv.dataSource = self;
    self.detailTableView = tv;
    self.detailTableView.separatorStyle = [UIColor clearColor];
    [self.view addSubview:self.detailTableView];
    
    // 修改Navigation Bar Title text color
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont boldSystemFontOfSize:17.0];
    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    lb.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    lb.textColor = [UIColor blackColor]; // change this color
    self.navigationItem.titleView = lb;
    lb.text = NSLocalizedString(@"详细", @"");
    [lb sizeToFit];
    
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
   // UIBarButtonItem *reply = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(replyAction:)];
    UIBarButtonItem *reply = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"11-sm"] style:UIBarButtonItemStylePlain target:self action:@selector(replyAction:)];
    UIBarButtonItem *retweet = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"22-sm"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmarkAction:)];
    
    UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"33-sm"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmarkAction:)];
    
    
    UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"44-sm"] style:UIBarButtonItemStylePlain target:self action:@selector(doActionSheet:)];
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    [toolbar setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
   // [toolbar setTintColor:[UIColor whiteColor]];
    CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 49, [[UIScreen mainScreen] bounds].size.width, 49);
    [toolbar setFrame:frame];
    NSArray *items = [NSArray arrayWithObjects:reply, flexiableItem, retweet,flexiableItem, bookmark, flexiableItem,action, nil];
    toolbar.items = items;
    [self.view addSubview:toolbar];
  // [self configureView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showUserInfo:nil]; // 跳转用户视图
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    if (indexPath.row == 0) {
        UITableViewCell *profileCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        self.profireImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        [self.profireImgView setImageWithURL:[NSURL URLWithString:[[self.detailItem objectForKey:@"user"] objectForKey:@"profile_image_url"]]
                            placeholderImage:[UIImage imageNamed:@"default.png"]];
        
        self.gbName = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 320, 30)];
        self.gbName.textColor = [UIColor blackColor];
        self.gbName.font = [UIFont fontWithName:@"Arial" size:17.0f];
        self.gbName.text = [[self.detailItem objectForKey:@"user"] objectForKey:@"screen_name"];
        /*圆角实现
         [self.userProfile.layer setBorderColor: [[UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.2] CGColor]];
         [self.userProfile.layer setBorderWidth: 1.0];
         self.userProfile.layer.cornerRadius = 22.5; // this value vary as per your desire
         self.userProfile.layer.masksToBounds = YES;
         */
        self.userLocation = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 270, 30)];
        self.userLocation.textColor = [UIColor grayColor];
        self.userLocation.font = [UIFont fontWithName:@"Arial" size:14.0f];
        self.userLocation.text = [[self.detailItem objectForKey:@"user"] objectForKey:@"location"];
        
        profileCell.tag = 1001;
        [profileCell addSubview:self.profireImgView];
        [profileCell addSubview:self.gbName];
        [profileCell addSubview:self.userLocation];
        profileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 67.5, self.view.bounds.size.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.2];
        
        [profileCell addSubview:lineView];
        
        UIView *er = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arror.png"]];
        
        er.frame = CGRectMake(20, 57, 22, 12);
        
        [profileCell addSubview:er];
        
        //  定义点击背景颜色
        self.gbName.highlightedTextColor = [UIColor whiteColor];
        self.userLocation.highlightedTextColor = [UIColor whiteColor];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor blackColor];
        bgColorView.layer.masksToBounds = YES;
        [profileCell setSelectedBackgroundView:bgColorView];
        
        // meCell.userInteractionEnabled = NO; // 禁止点击
        return profileCell;
    }else{
        UITableViewCell *contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        self.gbContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
        [self.gbContent setFont:[UIFont fontWithName:@"Enriqueta" size:17.0f]];
        [self.gbContent setBackgroundColor:[UIColor clearColor]];
        [self.gbContent setTextColor:[UIColor blackColor]];
        self.gbContent.numberOfLines = 0;
        self.gbContent.text = [self.detailItem objectForKey:@"text"];
        [self.gbContent resizeToFit];
        CGSize size = [self.gbContent.text sizeWithFont:self.gbContent.font constrainedToSize:CGSizeMake(self.gbContent.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        //根据计算结果重新设置UILabel的尺寸
        [self.gbContent setFrame:CGRectMake(10, 10, 300, size.height + 10)];
        [self setTextLingheight];
        NSString *textDate = [NSString stringWithFormat:@"%@",[self.detailItem objectForKey:@"created_at"]];
        NSString *y = [NSString stringWithFormat:@"%@",[textDate substringFromIndex:25]];
        
        NSString *t = [NSString stringWithFormat:@"%@",[textDate substringWithRange:NSMakeRange(11, 8)]];
        
        
        NSString *d = [NSString stringWithFormat:@"%@",[textDate substringWithRange:NSMakeRange(8, 2)]];
        
        NSString *m = [NSString stringWithFormat:@"%@",[textDate substringWithRange:NSMakeRange(4, 3)]];
        
        if ([m isEqualToString:@"Dec"]) {
            m = @"12";
        }else if([m isEqualToString:@"Nov"]){
            m = @"11";
        }else if([m isEqualToString:@"Oct"]){
            m = @"10";
        }else if([m isEqualToString:@"Sept"]){
            m = @"9";
        }else if([m isEqualToString:@"Aug"]){
            m = @"8";
        }else if([m isEqualToString:@"Jul"]){
            m = @"7";
        }else if([m isEqualToString:@"Jun"]){
            m = @"6";
        }else if([m isEqualToString:@"May"]){
            m = @"5";
        }else if([m isEqualToString:@"Apr"]){
            m = @"4";
        }else if([m isEqualToString:@"Mar"]){
            m = @"3";
        }else if([m isEqualToString:@"Feb"]){
            m = @"2";
        }else if([m isEqualToString:@"Jan"]){
            m = @"1";
        }
        
        NSString *fdateTime = [NSString stringWithFormat:@"%@年%@月%@日 %@",y,m,d,t];
        
        
        self.publicTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 200, 30)];
        self.publicTime.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.publicTime.textColor = [UIColor grayColor];
        self.publicTime.numberOfLines = 0;
        self.publicTime.text = fdateTime;
        
        self.publicTime.frame = CGRectMake(10, size.height + 20, 200, 30);
        [contentCell addSubview:self.publicTime];
        
        
        self.from = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 200, 30)];
        self.from.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.from.textColor = [UIColor grayColor];
        self.from.numberOfLines = 0;
        self.from.text = [NSString stringWithFormat:@"来自「%@」",[[self.detailItem objectForKey:@"source"] stripHtml]];
        self.from.frame = CGRectMake(160, size.height  + 20, 200, 30);
        [contentCell addSubview:self.from];
        
        //添加子视图
        [contentCell addSubview:self.gbContent];
        contentCell.userInteractionEnabled = NO; // 禁止点击
        return contentCell;
        
    }
    
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 68;
    }else if(indexPath.row == 1){
        return [self getIntroHeight];
    }
    return 100;
}

- (CGFloat)getIntroHeight
{
    CGSize size = [[self.detailItem objectForKey:@"text"] sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = size.height + 20 + 30;
    
    return height;
    
}

- (void)doActionSheet:(id)sender //Define method to show action sheet
{
    NSString *actionSheetTitle = @""; //Action Sheet Title
    //  NSString *destructiveTitle = @""; //Action Sheet Button Titles
    NSString *cpmessage = @"复制消息";
    NSString *sendFromemail = @"通过电子邮件发送";
    NSString *sendmessage = @"通过短信发送";
    NSString *cancelTitle = @"取消";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
															 delegate:self
													cancelButtonTitle:cancelTitle
											   destructiveButtonTitle:nil
													otherButtonTitles:cpmessage, sendFromemail,sendmessage, nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"复制消息"]) {
        [self copyDetailMessage];
    }
    if ([buttonTitle isEqualToString:@"通过电子邮件发送"]) {
        [self sendDetailMessageByEmail];
    }
    if ([buttonTitle isEqualToString:@"通过短信发送"]) {
        [self sendDetailMessageByMess];
    }
    if ([buttonTitle isEqualToString:@"取消"]) {
        //[self.msgArea becomeFirstResponder];
    }
    
}

-(void)copyDetailMessage
{
    [[UIPasteboard generalPasteboard] setString:[self.detailItem objectForKey:@"text"]];
}

-(void)sendDetailMessageByEmail
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:nil];
    [controller setMessageBody:[self.detailItem objectForKey:@"text"] isHTML:YES];
    if (controller){
    // [self presentModalViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)sendDetailMessageByMess
{
     NSLog(@"sendmess");
    MFMessageComposeViewController *sendMessagecontroller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		sendMessagecontroller.body = [self.detailItem objectForKey:@"text"];
		sendMessagecontroller.recipients = [NSArray arrayWithObjects:nil, nil];
		sendMessagecontroller.messageComposeDelegate = self;
		[self presentViewController:sendMessagecontroller animated:YES completion:nil];
	}
    
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"发送成功!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
            
            // failed code here
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(void)replyAction:(id)sender {
    if (!self.detailReplyView) {
        self.detailReplyView = [[ReplyViewController alloc] initWithNibName:@"ReplyViewController" bundle:nil];
    }
    
    self.detailReplyView.atUser = [NSString stringWithFormat:@"@%@ ", self.gbName.text];
    
    [self presentViewController:self.detailReplyView animated:YES completion:nil];
    
}

- (void)bookmarkAction:(id)sender {
    //some code
}

- (void)doAction:(id)sender
{
    //
}
-(void)viewWillAppear:(BOOL)animated {
    [self.detailTableView reloadData];
}

- (void)setTextLingheight
{
    //设置label行间距 ios6+
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.gbContent.text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [self.gbContent.text length])];
    self.gbContent.attributedText = attributedString;
    self.vc.contentSize = CGSizeMake(310, self.gbContent.frame.size.height + 40);

}

-(void)viewDidAppear:(BOOL)animated
{
    [[self.navigationController.navigationBar backItem] setTitle:@"首页"];
}

-(void)detailReply:(id)sender{
    
    if (!self.detailReplyView) {
        self.detailReplyView = [[ReplyViewController alloc] initWithNibName:@"ReplyViewController" bundle:nil];
    }
    
    self.detailReplyView.msgId = [sender tag];
    [self presentViewController:self.detailReplyView animated:YES completion:nil];
}

-(void)showUserInfo:(id)sender
{
    if (!self.userInfoView) {
        self.userInfoView = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    }
    
    self.userInfoView.userInfo = [self.detailItem objectForKey:@"user"];
    
    [self.navigationController pushViewController:self.userInfoView animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
   // [self.view removeFromSuperview];
}

- (BOOL)shouldAutorotate
{
    //returns true if want to allow orientation change
    return FALSE;
    
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskAll;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UINavigationController (RotationIn_IOS6)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject]  preferredInterfaceOrientationForPresentation];
}

@end
