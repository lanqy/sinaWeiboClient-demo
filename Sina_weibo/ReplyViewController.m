//
//  ReplyViewController.m
//  Sina_weibo
//
//  Created by lanqy on 13-11-4.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//
#import "NSString+Urlencode.h"
#import "AppDelegate.h"
#import "ReplyViewController.h"
#define kAppKey @"3242834701"
#define kAppSecret @"0f15121ac886c7b8195dd5e59607847e"

@interface ReplyViewController ()

@end

@implementation ReplyViewController
@synthesize msgArea = _msgArea;
@synthesize engine = _engine;
@synthesize sendMsg = _sendMsg;
@synthesize countText = _countText;
@synthesize imgSend = _imgSend;
@synthesize imagePickercontroller = _imagePickercontroller;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark Text Length

- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

- (void)calculateTextLength
{
    if (self.msgArea.text.length > 0)
	{
		[self.sendMsg setEnabled:YES];
		[self.sendMsg setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	}
	else
	{
		[self.sendMsg setEnabled:NO];
		[self.sendMsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
	
	int wordcount = [self textLength:self.msgArea.text];
	NSInteger count  = 140 - wordcount;
	if (count < 0)
    {
		[self.countText setTextColor:[UIColor redColor]];
		[self.sendMsg setEnabled:NO];
		[self.sendMsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
    else if(count == 140){
		[self.sendMsg setEnabled:NO];
		[self.sendMsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
	else
    {
		[self.countText setTextColor:[UIColor darkGrayColor]];
		[self.sendMsg setEnabled:YES];
        [self.sendMsg setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
	}
	
	[self.countText setText:[NSString stringWithFormat:@"%i",count]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.engine = [[WBEngine alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    [self.engine setRootViewController:self];
    [self.engine setDelegate:self];
    [self.engine setRedirectURI:@"http://"];
    [self.engine setIsUserExclusive:NO];
    [self.engine accessToken];
    
    UIButton *goBack = [UIButton buttonWithType:UIButtonTypeCustom];
    goBack.frame = CGRectMake(0, 30, 50, 18);
    [goBack setTitle:@"取消" forState:UIControlStateNormal];
    [goBack.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    [goBack setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(Back:) forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    [navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),60)];
    [navBar addSubview:goBack];
    

    self.sendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendMsg.frame = CGRectMake(270, 30, 50, 18);
    [self.sendMsg setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendMsg setEnabled:NO];
    [self.sendMsg setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendMsg.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [self.sendMsg addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:self.sendMsg];
    [self.view addSubview:navBar];
    
    CGRect frame = CGRectMake(10, 70, 300, 118);
    self.msgArea = [[UITextView alloc] initWithFrame:frame];
    self.msgArea.delegate = self;
    self.msgArea.font = [UIFont fontWithName:@"Arial" size:17.0f];
    [self.msgArea.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
   
    // [self.msgArea.layer setBorderColor: [[[UIColor grayColor] colorWithAlphaComponent:0.3] CGColor]];
   // [self.msgArea.layer setBorderWidth: 1.0];
   // [self.msgArea.layer setCornerRadius:5.0f];
   // [self.msgArea.layer setMasksToBounds:YES];
    
    [self.view addSubview:self.msgArea];
    self.countText = [[UILabel alloc] initWithFrame:CGRectMake(270, 180.0, 40, 30)];
    self.countText.text = @"140";
    self.countText.font = [UIFont fontWithName:@"Arial" size:11.0f];
    [self.view addSubview:self.countText];
    
    UIButton *button = [UIButton buttonWithType:UIBarButtonSystemItemCamera];
    [button addTarget:self
               action:@selector(showActionSheet:)
     forControlEvents:UIControlEventTouchDown];
    [button setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    // [button setTitle:@"拍照" forState:UIControlStateNormal];
    button.frame = CGRectMake(10.0, 180.0, 40.0, 40.0);
    [self.view addSubview:button];
    
    
    self.imgSend = [[UIImageView alloc] initWithFrame:CGRectMake(100, 177, 40, 40)];
    [self.view addSubview:self.imgSend];

}

- (void)takePictureBtn
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从系统相册选择",@"拍照", nil];
    [alert show];
    
    
   /*
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    //self.imagePickercontroller = ipc;
    
    [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:ipc animated:YES completion:nil];
    */
}





- (void)showActionSheet:(id)sender //Define method to show action sheet
{
    NSString *actionSheetTitle = @""; //Action Sheet Title
  //  NSString *destructiveTitle = @""; //Action Sheet Button Titles
    NSString *other1 = @"拍照";
    NSString *other2 = @"从相册中选择";
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
    if ([buttonTitle isEqualToString:@"拍照"]) {
        [self takePhoto];
    }
    if ([buttonTitle isEqualToString:@"从相册中选择"]) {
        [self addPhoto];
    }
    if ([buttonTitle isEqualToString:@"取消"]) {
        [self.msgArea becomeFirstResponder];
    }
    
}

/*
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self addPhoto];
    }
    else if(buttonIndex == 2)
    {
        [self takePhoto];
    }
}
*/
- (void)addPhoto
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"该设备不支持拍照功能"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (IBAction)Back:(id)sender
{
    self.msgArea.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    [self.imgSend setImage:image];
    [self.msgArea becomeFirstResponder];
}
- (IBAction)SendMessage:(id)sender
{
    UIImage *myImage = self.imgSend.image;
   // NSLog(@"%@",myImage);
    
   // NSData *dataForPNGFile = UIImagePNGRepresentation(myImage);
    //NSLog(@"%@",dataForPNGFile);
    AppDelegate *dg=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"%@",dg.weiboId);
    
    if (dg.weiboId != nil) {
        [self commentMessage:dg.weiboId];
    }else{
    
        NSString *text = [self.msgArea.text urlencode];
    
        NSLog(@"%@",text);
        [self.engine sendWeiBoWithText:self.msgArea.text image:myImage];
    }
}


-(void)commentMessage:(NSString *)weiboId{
    NSLog(@"%@",weiboId);
    AppDelegate *dgl=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *post =[NSString stringWithFormat:@"source=%@&access_token=%@&comment=%@&id=%@",kAppKey,dgl.asscessToken,[self.msgArea.text urlencode],weiboId];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];;
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.weibo.com/2/comments/create.json"]];
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
        MBProgressHUD *custuonHUD = [[MBProgressHUD alloc] initWithView:self.view];
        custuonHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        custuonHUD.labelText = @"发送成功！";
        custuonHUD.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:custuonHUD];
        [custuonHUD show:YES];
        [custuonHUD hide:YES afterDelay:1];
    }
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"%@",[NSMutableData data]);
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self calculateTextLength];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


- (void)onClearTextButtonTouched:(id)sender
{
    [self.msgArea setText:@""];
	[self calculateTextLength];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if(self.atUser){
        self.msgArea.text = self.atUser;
    }
    
    [self.msgArea becomeFirstResponder];
    
    [super viewWillAppear:animated];
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