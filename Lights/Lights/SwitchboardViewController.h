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
    
    NSURLConnection *_connection;
    NSMutableData *_httpData;
    NSString *LIGHTS_CONTROL_POST;
    NSString *LIGHTS_LOOP_POST;
}
- (IBAction)LoopButtonClick:(id)sender;
@end
