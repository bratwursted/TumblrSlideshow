//
//  TSSAppDelegate.m
//  TumblrSlideshow
//
//  Created by Joe on 12/3/13.
//  Copyright (c) 2013 Joe Bramhall. All rights reserved.
//

#import "TSSAppDelegate.h"
#import "TMAPIClient.h"

@implementation TSSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // init set Tumblr API client
    [TMAPIClient sharedInstance].OAuthConsumerKey = @"l2jbGKjm2cnwJtM4R9a4iJp9AkPwyLTBHTMh621QVbBovgdK8M";
    [TMAPIClient sharedInstance].OAuthConsumerSecret = @"LBjSdcIaLX0lO8tfSGRf33ZKscXKeek4D2gqLEFJ28Ih9DQlx7";

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[TMAPIClient sharedInstance] handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
