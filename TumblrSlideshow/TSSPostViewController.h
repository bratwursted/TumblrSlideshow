//
//  TSSPostViewController.h
//  TumblrSlideshow
//
//  Created by Joe on 12/5/13.
//  Copyright (c) 2013 Joe Bramhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostViewDelegate <NSObject>

- (void)dismissPostView;

@end

@interface TSSPostViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) id post;
@property (nonatomic, weak) id<PostViewDelegate> delegate; 
@property (nonatomic, strong) IBOutlet UIWebView *webview;

@end
