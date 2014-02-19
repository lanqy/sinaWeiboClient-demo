//
//  PotosListViewController.m
//  Sina_weibo
//
//  Created by lanqy on 13-12-15.
//  Copyright (c) 2013年 lanqy. All rights reserved.
//

#define apiUrl @"https://api.weibo.com/2/"
#define kAppKey @"3242834701"
#define kAppSecret @"0f15121ac886c7b8195dd5e59607847e"
#import "AppDelegate.h"
#import "PotosListViewController.h"
#import "photoDetalViewController.h"
#import "AFHTTPRequestOperation.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AFCollectionViewFlowLargeLayout.h"
#import "AFCollectionViewFlowSmallLayout.h"
#import "AFCollectionViewCell.h"

@interface PotosListViewController ()

@property (nonatomic, strong) AFCollectionViewFlowLargeLayout *largeLayout;
@property (nonatomic, strong) AFCollectionViewFlowSmallLayout *smallLayout;
@property (nonatomic, strong) NSArray *images;


@end
static NSString *ItemIdentifier = @"ItemIdentifier";

@implementation PotosListViewController
@synthesize photoList = _photoList;
@synthesize phDetailview = _phDetailview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


-(void)loadView
{
    // Important to override this when not using a nib. Otherwise, the collection
    // view will be instantiated with a nil layout, crashing the app.
    
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    self.smallLayout = [[AFCollectionViewFlowSmallLayout alloc] init];
    self.largeLayout = [[AFCollectionViewFlowLargeLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.smallLayout];
    [self.collectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor blackColor]];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

- (void)viewDidLoad
{
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"我"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
    

    [super viewDidLoad];
    self.title = @"相片";
    [self.view setBackgroundColor:[UIColor redColor]];
    [self getPhotos];
    // Do any additional setup after loading the view from its nib.
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"小图", @"大图"]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - User Interface Methods

-(void)segmentedControlValueDidChange:(id)sender
{
    if (self.collectionView.collectionViewLayout == self.smallLayout)
    {
        [self.largeLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.largeLayout animated:YES];
    }
    else
    {
        [self.smallLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.smallLayout animated:YES];
    }
}

#pragma mark - UICollectionView DataSource & Delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.photoList objectForKey:@"statuses"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    
   // [cell setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", indexPath.item % 4]]];
    
    NSString *ImageURL = [[[self.photoList objectForKey:@"statuses"] objectAtIndex:indexPath.row] objectForKey:@"bmiddle_pic"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    [cell setImage:[UIImage imageWithData:imageData]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    
    if (!self.phDetailview) {
        self.phDetailview = [[photoDetalViewController alloc] initWithNibName:@"photoDetalViewController" bundle:nil];
    }
   // self.phDetailview.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.phDetailview.photoItem = [[self.photoList objectForKey:@"statuses"] objectAtIndex:indexPath.row];
    self.phDetailview.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:self.phDetailview animated:YES];
    [self presentModalViewController:self.phDetailview animated:YES];
    
    
    
    
}

-(void)getPhotos
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	//[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"加载中...";
    [self.view addSubview:HUD];
    [HUD show:YES];
    AppDelegate *appdg=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@place/users/photos.json?access_token=%@&source=%@&uid=%@",apiUrl,appdg.asscessToken,kAppKey,appdg.loginUid]];
    
    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.photoList = responseObject;
        [HUD hide:YES afterDelay:0.1];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

@end
