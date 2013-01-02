//
//  test2AppDelegate.h
//  test2
//
//  Created by Joseph on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class test2ViewController;

@interface test2AppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet test2ViewController *viewController;

@end
