//
//  ConfigViewController.h
//  Lights
//
//  Created by Joseph on 4/2/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController
{
    NSArray *colors;
    
    NSURLConnection *_connection;
    NSMutableData *_httpData;
    NSString *LIGHTS_CONFIG_POST;
     NSMutableString *_LightsAddress;
}
- (IBAction)StartButtonClick:(id)sender;
- (IBAction)NotUsedClick:(id)sender;
- (void) SetLightsAddress:(NSMutableString *) url;
@property (weak, nonatomic) IBOutlet UILabel *CurrentLabel;
@end
