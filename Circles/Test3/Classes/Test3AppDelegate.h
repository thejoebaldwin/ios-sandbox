//
//  Test3AppDelegate.h
//  Test3
//
//  Created by Joseph on 6/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLView;

@interface Test3AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLView *glView;
@property (nonatomic, retain) IBOutlet UILabel *lblPoints;
@property (nonatomic, retain) IBOutlet UILabel *lblSliderValue;
@property (nonatomic, retain) IBOutlet UILabel *lblDebug;
@property (nonatomic, retain) IBOutlet UISlider *sliderScale;
@end

