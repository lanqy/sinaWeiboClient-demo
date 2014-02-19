//
//  HomeViewController.m
//  Sina_weibo
//
//  Created by lanqy on 13-11-28.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//
#define FONT_SIZE 17.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 8.0f
#define kWBAlertViewLogOutTag 100
#define apiUrl @"https://api.weibo.com/2/"
#define kAppKey @"3242834701"
#define kAppSecret @"0f15121ac886c7b8195dd5e59607847e"
int CURRENTPAGE = 1;
int selectedIndex = nil;
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIMenuItem+CXAImageSupport.h"
#import "DetailViewController.h"
#import "UserInfoViewController.h"
#import "AFHTTPRequestOperation.h"
#import "LoginUserInfoViewController.h"
#import "MessageViewController.h"
#import "PersonalMedicineViewController.h"
#import "HomeViewController.h"
#import "ReplyViewController.h"
#import "TTTAttributedLabel.h"
#import "LQYCustomCell.h"

@interface HomeViewController ()

- (void)refreshTimeline;

@end

@implementation HomeViewController
@synthesize weiBoEngine;
@synthesize timeLine = _timeLine;
@synthesize indicatorView = _indicatorView;
@synthesize tableView = _tableView;
@synthesize acessToken = _acessToken;

@synthesize detailViewController = _detailVeiwController;
@synthesize userInfoViewController = _userInfoViewController;
@synthesize createdAt = _createdAt;
@synthesize retweetedStatus = _retweetedStatus;
@synthesize currentId = _currentId;
@synthesize replyViewController = _replyViewController;
@synthesize LoginUserInfo = _LoginUserInfo;
@synthesize loginUserInfoViewController = _loginUserInfoViewController;
@synthesize refreshControl = _refreshControl;
@synthesize favoriteIds = _favoriteIds;
@synthesize commentItem = _commentItem;
@synthesize actionItem = _actionItem;
@synthesize starItem = _starItem;
@synthesize retweetItem = _retweetItem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSString*)formatTime
{
	NSString *_timestamp;
    // Calculate distance time string
    //
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, self.createdAt);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"周前" : @"周前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.createdAt];
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}


// 时间转换
- (time_t)getTimeValueForKey:(NSString *)timeValue {
	NSString *stringTime   = timeValue;
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return 0;
}


- (void)dealloc
{
   // [self.engine setDelegate:nil];
    [self.tableView setDelegate:nil];
    [self.tableView setDataSource:nil];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timeLine = [[NSMutableArray alloc] init];
    
   // NSLog(@"%@",self.timeLine);

    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 修改Navigation Bar Title text color
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.0];
    // label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor blackColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"首页", @"");
    [label sizeToFit];
    
    
    
    /*
    //pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self.tableView addSubview:self.refreshControl ];
     */
    // long press
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    [self.view addSubview:self.tableView];
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained HomeViewController *vc = self;
    
    // 3.3行集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    _header.delegate = self;
    
    // 4.3行集成上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        AppDelegate *ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@statuses/friends_timeline.json?access_token=%@&page=%d&source=%@&uid=%@",apiUrl,ap.asscessToken,CURRENTPAGE,kAppKey,ap.loginUid]];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        if(jsonData != nil)
        {
            NSError *error = nil;
            id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (error == nil){
                NSMutableDictionary *dict = (NSMutableDictionary *)result;
               // NSLog(@"%@",[dict objectForKey:@"statuses"]);
                //[self.timeLine addObjectsFromArray:[dict objectForKey:@"statuses"]];
                [self.timeLine addObjectsFromArray:[dict objectForKey:@"statuses"]];
                dict = nil;
            }
        }
        
        
        // 2秒后刷新表格
        [vc performSelector:@selector(reloadDeals) withObject:nil afterDelay:2];
        CURRENTPAGE = CURRENTPAGE + 1;
        
    };
    
    // 5.0.5秒后自动下拉刷新
  //  [_header performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0.5];
    
    /*
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(onLogOutButtonPressed)];
                                
                                 [self.navigationItem setLeftBarButtonItem:leftBtn];

     */
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                              target:self
                                                                              action:@selector(onSendButtonPressed)];
    
    
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    
    self.commentItem = [[UIMenuItem alloc] cxa_initWithTitle:NSLocalizedString(@"comment", nil) action:@selector(commentAction:) image:[UIImage imageNamed:@"w-1"]];
    
    self.retweetItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"retweet", nil) action:@selector(retweetAction:)];
    CXAMenuItemSettings *settings = [CXAMenuItemSettings new];
    settings.image = [UIImage imageNamed:@"w-2"];
    settings.shadowDisabled = YES;
    settings.shrinkWidth = 16;
    [self.retweetItem cxa_setSettings:settings];
    
    self.starItem = [[UIMenuItem alloc] cxa_initWithTitle:NSLocalizedString(@"star", nil) action:@selector(starAction:) image:[UIImage imageNamed:@"w-3"]];
   // [broomItem2 cxa_setSettings:settings];
    
    self.actionItem = [[UIMenuItem alloc] cxa_initWithTitle:NSLocalizedString(@"action", nil) action:@selector(doAction:) image:[UIImage imageNamed:@"w-4"]];
    [UIMenuController sharedMenuController].menuItems = @[self.commentItem, self.retweetItem, self.starItem, self.actionItem];
    
    [self refreshTimeline];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    AppDelegate *ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [params setObject:ap.asscessToken forKey:@"access_token"];
    [params setObject:ap.loginUid forKey:@"uid"];
    [self getLoginUserInfo:params];
}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) { // 下拉刷新
        //
        AppDelegate *ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@statuses/friends_timeline.json?access_token=%@&source=%@&uid=%@",apiUrl,ap.asscessToken,kAppKey,ap.loginUid]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                             initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            [self.timeLine replaceObjectsInRange:NSMakeRange(0,0)
                            withObjectsFromArray:[dic objectForKey:@"statuses"]];
             [self performSelector:@selector(reloadDeals) withObject:nil afterDelay:2];
            
        } failure:nil];
        [operation start];
    }
}

- (void)reloadDeals
{
    [self.tableView reloadData];
    // 结束刷新状态
    [_header endRefreshing];
    [_footer endRefreshing];
}

- (void)onLogOutButtonPressed
{
    [weiBoEngine logOut];
}
- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
													   message:@"登出成功！"
													  delegate:self
											 cancelButtonTitle:@"确定"
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
}

- (void)onSendButtonPressed
{
    if (!self.replyViewController) {
        self.replyViewController = [[ReplyViewController alloc] initWithNibName:@"ReplyViewController" bundle:nil];
    }
    
    [self presentViewController:self.replyViewController animated:YES completion:nil];
    
}

- (void)refreshTimeline
{
    AppDelegate *ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@statuses/friends_timeline.json?access_token=%@&source=%@&uid=%@",apiUrl,ap.asscessToken,kAppKey,ap.loginUid]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        [self.timeLine addObjectsFromArray:[dict objectForKey:@"statuses"]];
        CURRENTPAGE = CURRENTPAGE + 1;
        [self.tableView reloadData];

    } failure:nil];
    [operation start];
    
}


#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    if (action == @selector(cameraAction:) ||
        action == @selector(broomAction:) ||
        action == @selector(textAction:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - privates
- (void)pressme:(id)sender
{
    [[UIMenuController sharedMenuController] setTargetRect:[sender frame] inView:self.view];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)commentAction:(id)sender
{
    [self onSendButtonPressed];
}

- (void)retweetAction:(id)sender
{
    //
}

- (void)starAction:(id)sender
{
    
    AppDelegate *dgl=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *post =[NSString stringWithFormat:@"source=%@&access_token=%@&id=%@",kAppKey,dgl.asscessToken,dgl.weiboId];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];;
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.weibo.com/2/favorites/create.json"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",data);
    if (data) {
        [self showOperationMessage:@"已收藏！"];
    }
}

// 操作提示
- (void)showOperationMessage:(NSString *)message
{
    
    MBProgressHUD *custuonHUD = [[MBProgressHUD alloc] initWithView:self.view];
    custuonHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    custuonHUD.labelText = message;
    custuonHUD.mode = MBProgressHUDModeCustomView;
    [self.view addSubview:custuonHUD];
    [custuonHUD show:YES];
    [custuonHUD hide:YES afterDelay:1];
}

- (void)doAction:(id)sender
{
    [self showActionSheet:sender];
}

- (void)showActionSheet:(id)sender //Define method to show action sheet
{
    NSString *actionSheetTitle = @""; //Action Sheet Title
    //  NSString *destructiveTitle = @""; //Action Sheet Button Titles
    NSString *cpmessage = @"复制消息";
    NSString *sendFromemail = @"通过电子邮件发送消息";
    NSString *sendmessage = @"发送短信";
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
        [self copyMessage];
    }
    if ([buttonTitle isEqualToString:@"通过电子邮件发送消息"]) {
        [self sendMessageByEmail];
    }
    if ([buttonTitle isEqualToString:@"发送短信"]) {
        [self sendMessageByMess];
    }
    if ([buttonTitle isEqualToString:@"取消"]) {
        //[self.msgArea becomeFirstResponder];
    }
    
}

-(void)copyMessage
{
    NSLog(@"copy");
    
    [[UIPasteboard generalPasteboard] setString:[[self.timeLine objectAtIndex:selectedIndex] objectForKey:@"text"]];
}

-(void)sendMessageByEmail
{
    NSLog(@"sendemail");
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:nil];
    [controller setMessageBody:[[self.timeLine objectAtIndex:selectedIndex] objectForKey:@"text"] isHTML:YES];
    if (controller){
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)sendMessageByMess
{
    NSLog(@"sendmess");
    MFMessageComposeViewController *sendMessagecontroller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		sendMessagecontroller.body = [[self.timeLine objectAtIndex:selectedIndex] objectForKey:@"text"];
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
        [self showOperationMessage:@"发送成功！"];
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


// 长按操作出现菜单
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        
        //Do Whatever You want on End of Gesture
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        [self getFavoriteIDs];
        
       // NSLog(@"%@",self.favoriteIds);
        

        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        selectedIndex = indexPath.row;
        AppDelegate *sel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        sel.weiboId = [[self.timeLine objectAtIndex:selectedIndex] objectForKey:@"mid"];
        
        if ([self.favoriteIds containsObject:sel.weiboId]) {
            self.starItem = [[UIMenuItem alloc] cxa_initWithTitle:NSLocalizedString(@"star", nil) action:@selector(starAction:) image:[UIImage imageNamed:@"w-3-half"]];
        }else{
            self.starItem = [[UIMenuItem alloc] cxa_initWithTitle:NSLocalizedString(@"star", nil) action:@selector(starAction:) image:[UIImage imageNamed:@"w-3"]];
            
        }
        
        CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];

        [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(cellRect.origin.x, cellRect.origin.y, cellRect.size.width, cellRect.size.height) inView:self.tableView];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

-(void)getFavoriteIDs
{
    
    AppDelegate *ap=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@favorites/ids.json?access_token=%@&source=%@&uid=%@",apiUrl,ap.asscessToken,kAppKey,ap.loginUid]];
    //NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        self.favoriteIds = [[NSMutableArray alloc] init];
        int len = [[dict objectForKey:@"favorites"] count];
       // NSLog(@"%d",[[dict objectForKey:@"favorites"] count]);
        for (int i = 0; i < len ; i++) {
            [self.favoriteIds addObject:[[[dict objectForKey:@"favorites"] objectAtIndex:i] objectForKey:@"status"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

#pragma mark - UITableViewDelegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *selectedRow = [self.timeLine objectAtIndex:indexPath.row];
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    self.detailViewController.hidesBottomBarWhenPushed = YES;
    self.detailViewController.detailItem = selectedRow;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [[self.timeLine objectAtIndex:[indexPath row]] objectForKey:@"text"];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = size.height;
    
    // NSLog(@" %s", hasRetwitter ? "true" : "false");
    
    [self hasRetweet:[indexPath row]];
    
    //NSLog(@"hasImage %s", hasImage ? "true" : "false");
    
   // NSLog(@"haveRetwitterImage %s", haveRetwitterImage ? "true" : "false");
    
    if (hasRetwitter) {
        NSDictionary* r = [[self.timeLine objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"];
        NSString *rt = [r objectForKey:@"text"];
        CGSize rtsize = [rt sizeWithFont:[UIFont fontWithName:@"Arial" size:16.0f] constrainedToSize:CGSizeMake(220, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        height = height + rtsize.height + 30 + 30 + 3;
    }
    // return the height, with a bit of extra padding in
    return height + (CELL_CONTENT_MARGIN * 2) + 30 + 3;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.timeLine count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"HistoryCell";
    LQYCustomCell *cell = (LQYCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     //if (cell == nil) {
         cell = [[LQYCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    // }
    NSDictionary *detail = [self.timeLine objectAtIndex:indexPath.row];
    [cell.name setText:[[detail objectForKey:@"user"] objectForKey:@"screen_name"]];
    [cell.content setText:[detail objectForKey:@"text"]];
    
    self.createdAt = [self getTimeValueForKey:[detail objectForKey:@"created_at"]];
    
    CGSize size = [[detail objectForKey:@"text"] sizeWithFont:cell.content.font constrainedToSize:CGSizeMake(cell.content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    [cell.content setFrame:CGRectMake(70, 35, 240, size.height)];
    
    // NSLog(@"%@",self.timeLine);
    [self hasRetweet:[indexPath row]];
    
    if (hasRetwitter) {
        cell.retweetView.hidden = NO;
        cell.arrow.hidden = NO;
        
        NSDictionary* r = [[self.timeLine objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"];
        
        NSString *t = [r objectForKey:@"text"];
        
        [cell.retweetUser setTitle:[NSString stringWithFormat:@"@%@",[[r objectForKey:@"user"] objectForKey:@"screen_name"]] forState:UIButtonTypeCustom];
        [cell.retweetUser addTarget:self action:@selector(showUserInfoFormRetweet:) forControlEvents:UIControlEventTouchUpInside];
        cell.retweetUser.tag = indexPath.row;
        
        cell.retweetText.text = t;
        cell.retweetText.highlightedTextColor = [UIColor whiteColor];
        cell.arrow.highlightedImage = [UIImage imageNamed:@"er_a.png"];
        cell.retweetUser.opaque = YES;
        CGSize rtsize = [t sizeWithFont:cell.retweetText.font constrainedToSize:CGSizeMake(cell.retweetText.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        
        [cell.retweetText sizeToFit];
        cell.retweetView.frame = CGRectMake(70, size.height + 35 + 3 + 10, 240, rtsize.height + 20 + 30);
        cell.arrow.frame = CGRectMake(90, size.height + 35 + 1.5f, 22, 12);
    }else{
        cell.arrow.hidden = YES;
        cell.retweetView.hidden = YES;
    }
    
    cell.ptime.text = [self formatTime];
    
    cell.content.highlightedTextColor = [UIColor whiteColor];
    cell.name.highlightedTextColor = [UIColor whiteColor];
    cell.name.opaque = YES;// 优化table cell
    cell.content.opaque = YES;// 优化table cell
    [cell.imgView setImageWithURL:[NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]]
                 placeholderImage:[UIImage imageNamed:@"default.png"]];
    
    
    [cell.imgView.layer setBorderColor: [[UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.2] CGColor]];
    [cell.imgView.layer setBorderWidth: 1.0];
    cell.imgView.layer.cornerRadius = 2; // this value vary as per your desire
    cell.imgView.layer.masksToBounds = YES;
    
    [cell.profile addTarget:self action:@selector(showUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.profile.tag = indexPath.row;
    
    [cell.profile setShowsTouchWhenHighlighted:YES];
    // 设置label行间距
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.content.text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [cell.content.text length])];
    cell.content.attributedText = attributedString ;
    [cell.content sizeToFit];
    [cell.content setNeedsDisplay];
    //  定义点击背景颜色
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor blackColor];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    [cell.retweetView setBackgroundColor:[UIColor whiteColor]];
    return cell;
    
}

- (void)hasRetweet:(int)index
{
    
    NSDictionary* retweetedStatusDic = [[self.timeLine objectAtIndex:index] objectForKey:@"retweeted_status"];
    
    if (retweetedStatusDic) {
        self.retweetedStatus = [retweetedStatusDic objectForKey:@"text"];
        //有转发的博文
        if (self.retweetedStatus && ![self.retweetedStatus isEqual:[NSNull null]])
        {
            hasRetwitter = YES;
            NSString *url = [retweetedStatusDic objectForKey:@"thumbnail_pic"];
            haveRetwitterImage = (url != nil && [url length] != 0 ? YES : NO);
        }
    }
    //无转发
    else
    {
        hasRetwitter = NO;
        NSString *url = [[self.timeLine objectAtIndex:index] objectForKey:@"thumbnail_pic"];
        hasImage = (url != nil && [url length] != 0 ? YES : NO);
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    //去掉选中的背景颜色
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

#pragma mark - WBEngineDelegate Methods

-(IBAction)showUserInfo:(id)sender
{
    if (!self.userInfoViewController) {
        self.userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    }
    self.userInfoViewController.userInfo = [[self.timeLine objectAtIndex:[sender tag]] objectForKey:@"user"];
    self.userInfoViewController.token = self.acessToken;
    self.userInfoViewController.cid = self.currentId;
    self.userInfoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.userInfoViewController animated:YES];
}


-(IBAction)showUserInfoFormRetweet:(id)sender
{
    if (!self.userInfoViewController) {
        self.userInfoViewController = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
    }
    self.userInfoViewController.userInfo = [[[self.timeLine objectAtIndex:[sender tag]] objectForKey:@"retweeted_status"] objectForKey:@"user"];
    [self.navigationController pushViewController:self.userInfoViewController animated:YES];
}


// 获取登陆用户的信息
- (void)getLoginUserInfo:(NSDictionary*)params
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@users/show.json?access_token=%@&source=%@&uid=%@",apiUrl,[params objectForKey:@"access_token"],self.appKey,[params objectForKey:@"uid"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.LoginUserInfo = responseObject;
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.LoginUserInfo objectForKey:@"profile_image_url"]]]];
        CGRect pf = CGRectMake(0, 0, 30, 30);
        UIButton *porfButton = [[UIButton alloc] initWithFrame:pf];
        [porfButton setBackgroundImage:image forState:UIControlStateNormal];
        [porfButton addTarget:self action:@selector(showLoginUserInfo:)
             forControlEvents:UIControlEventTouchUpInside];
        
        [porfButton.layer setBorderColor: [[UIColor colorWithRed:207 / 255 green:207 / 255 blue:207 / 255 alpha:0.2] CGColor]];
        [porfButton.layer setBorderWidth: 1.0];
        porfButton.layer.cornerRadius = 15; // this value vary as per your desire
        porfButton.layer.masksToBounds = YES;
        [porfButton setShowsTouchWhenHighlighted:YES];
        UIBarButtonItem *me =[[UIBarButtonItem alloc] initWithCustomView:porfButton];
        self.navigationItem.leftBarButtonItem= me;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    

}

- (void)showLoginUserInfo:(id)sender
{
    //NSDictionary *selectedRow = [self.timeLine objectAtIndex:indexPath.row];
   /*
    if (!self.loginUserInfoViewController) {
        self.loginUserInfoViewController = [[LoginUserInfoViewController alloc] initWithNibName:@"LoginUserInfoViewController" bundle:nil];
    }
    self.loginUserInfoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.loginUserInfoViewController.loginUserInfo = self.LoginUserInfo;
    // [self.navigationController pushViewController:self.loginUserInfoViewController animated:YES];
    [self presentModalViewController:self.loginUserInfoViewController animated:YES];
    */
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
