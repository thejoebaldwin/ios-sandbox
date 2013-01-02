//
//  AttendanceAppDelegate.m
//  Attendance
//
//  Created by Joseph on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttendanceAppDelegate.h"

#import "MainViewController.h"

@implementation AttendanceAppDelegate


@synthesize window=_window;
@synthesize webView;


@synthesize mainViewController=_mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    NSString *urlAddress = @"http://www.google.com";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    ///Load the request in the UIWebView.
    [webView loadRequest:requestObj];

    
    // Override point for customization after application launch.
    // Add the main view controller's view to the window and display.
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    
    
       

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [super dealloc];
}

@end
