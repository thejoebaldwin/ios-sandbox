//
//  SwitchboardViewController.h
//  Lights
//
//  Created by Joseph Baldwin on 4/6/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchboardViewController : UIViewController
{
    NSArray *colors;
    NSMutableString *_LightsAddress;
    NSURLConnection *_connection;
    NSMutableData *_httpData;
    NSString *LIGHTS_CONTROL_POST;
    NSString *LIGHTS_LOOP_POST;
    NSTimer *_timer;
    NSInteger _lightIndex;
    BOOL _lightsFlashingOn;
}
- (IBAction)LoopButtonClick:(id)sender;
- (IBAction)RedButtonClick:(id)sender;
@end
