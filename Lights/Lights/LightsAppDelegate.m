//
//  LightsAppDelegate.m
//  Lights
//
//  Created by Joseph Baldwin on 4/1/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "LightsAppDelegate.h"

#import "LightsViewController.h"
#import "ConfigViewController.h"
#import "SwitchboardViewController.h"
#import "AddressViewController.h"

@implementation LightsAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    
    self.viewController = [[LightsViewController alloc] initWithNibName:@"LightsViewController" bundle:nil];
    
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
       
    [[self window] setRootViewController:tabBarController];

    LightsViewController *main;
    ConfigViewController *config;
    
    config = [[ConfigViewController alloc] initWithNibName:@"ConfigViewController" bundle:nil];
    SwitchboardViewController *switchBoard = [[SwitchboardViewController alloc] initWithNibName:@"SwitchboardViewController" bundle:nil];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
       main = [[LightsViewController alloc] initWithNibName:@"LightsViewController_iPhone" bundle:nil];
    } else {
        main = [[LightsViewController alloc] initWithNibName:@"LightsViewController" bundle:nil];
    }

    
    AddressViewController *address = [[AddressViewController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects: switchBoard,config,address, nil];
    [tabBarController setViewControllers:viewControllers];

    
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
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
