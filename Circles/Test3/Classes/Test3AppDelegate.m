//
//  Test3AppDelegate.m
//  Test3
//
//  Created by Joseph on 6/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "Test3AppDelegate.h"
#import "GLView.h"
#import "OpenGLCommon.h"

@implementation Test3AppDelegate

@synthesize window;
@synthesize glView;
@synthesize lblPoints, lblSliderValue, lblDebug;
@synthesize sliderScale;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	glView.animationInterval = 1.0 / kRenderingFrequency;
	[glView startAnimation];
    [application setStatusBarHidden:YES];
    [application setIdleTimerDisabled:YES];

   }


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / kInactiveRenderingFrequency;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 60.0;
}


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
