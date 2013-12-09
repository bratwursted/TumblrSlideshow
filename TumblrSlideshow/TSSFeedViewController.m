//
//  TSSFeedViewController.m
//  TumblrSlideshow
//
//  Created by Joe on 12/3/13.
//  Copyright (c) 2013 Joe Bramhall. All rights reserved.
//

#import "TSSFeedViewController.h"
#import "TMAPIClient.h"
#import "TSSCollectionViewCell.h"

@interface TSSFeedViewController ()

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, assign) NSInteger postOffset;
@property (nonatomic, strong) NSTimer *slideshowTimer;

#define kTokenKey @"tumblrToken"
#define kSecretKey @"tumblrSecret"

@end

@implementation TSSFeedViewController

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
	// Do any additional setup after loading the view.
    self.postOffset = 0;
    if ([self tumblrUserAuthenticated]) {
        [self setTumblrUserTokens];
        [self getDashPosts];
    } else {
        [[TMAPIClient sharedInstance] authenticate:@"com.thinxmedia.slideshow" callback:^(NSError *error) {
            if (error) {
                NSLog(@"There was a problem authenticating %@", error);
            } else {
                [self saveTumbleTokens];
                [self getDashPosts];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startSlideshow
{
    self.slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(showNextPicture) userInfo:nil repeats:YES];
}

- (void)stopSlideshow
{
    if (self.slideshowTimer) {
        [self.slideshowTimer invalidate];
    }
    self.slideshowTimer = nil;
    self.postOffset = 0;
}

- (void)showNextPicture
{
    if (self.postOffset > [self.posts count]) {
        // stop slideshow
        [self stopSlideshow];
        return;
    }
    
    self.postOffset++;
    id post = [self.posts objectAtIndex:self.postOffset];
    TSSCollectionViewCell *cell = (TSSCollectionViewCell *)[[self.collectionView visibleCells] objectAtIndex:0];
    [cell fadeToNextPost:post];
}

#pragma mark - Collection view datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TSSCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    id post = [self.posts objectAtIndex:indexPath.row];
    [cell layoutCellForPost:post];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"post"]) {
        UINavigationController *nc = [segue destinationViewController];
        TSSPostViewController *postViewController = (TSSPostViewController *)[nc topViewController];

        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        postViewController.post = (indexPath.row) ? [self.posts objectAtIndex:indexPath.row] : [self.posts objectAtIndex:self.postOffset];
        postViewController.delegate = self;
    }
}

- (void)dismissPostView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self stopSlideshow];
}

#pragma mark - Tumblr methods

- (void)getDashPosts
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"photo", @"type", nil];
    [[TMAPIClient sharedInstance] dashboard:params callback:^(id results, NSError *error) {
        self.posts = [NSArray arrayWithArray:[results valueForKey:@"posts"]];
        [self.collectionView reloadData];
        [self startSlideshow];
        if (error) {
            NSLog(@"There was a problem getting dash info %@", error);
        }
    }];
}

- (void)setTumblrUserTokens
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[TMAPIClient sharedInstance] setOAuthToken:[defaults valueForKey:kTokenKey]];
    [[TMAPIClient sharedInstance] setOAuthTokenSecret:[defaults valueForKey:kSecretKey]];
}

- (void)saveTumbleTokens
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [[TMAPIClient sharedInstance] OAuthToken];
    NSString *secret = [[TMAPIClient sharedInstance] OAuthTokenSecret];
    [defaults setValue:token forKey:kTokenKey];
    [defaults setValue:secret forKey:kSecretKey];
    [defaults synchronize];
}

- (BOOL)tumblrUserAuthenticated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:kTokenKey]) {
        return YES;
    }
    return NO;
}

@end
