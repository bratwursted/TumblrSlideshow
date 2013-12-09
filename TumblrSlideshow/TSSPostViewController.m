//
//  TSSPostViewController.m
//  TumblrSlideshow
//
//  Created by Joe on 12/5/13.
//  Copyright (c) 2013 Joe Bramhall. All rights reserved.
//

#import "TSSPostViewController.h"

@interface TSSPostViewController ()

- (IBAction)done:(id)sender;

@end

@implementation TSSPostViewController

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
    NSString *postURL = [self.post valueForKey:@"post_url"];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:postURL]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    [self.delegate dismissPostView];
}

@end
