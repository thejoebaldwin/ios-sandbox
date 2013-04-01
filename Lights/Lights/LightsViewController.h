//
//  LightsViewController.h
//  Lights
//
//  Created by Joseph Baldwin on 4/1/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightsViewController : UIViewController 
{
    NSURLConnection *_connection;
    NSMutableData *_httpData;

    
}


- (IBAction)PostButtonClick:(id)sender;
- (IBAction)ClearButtonClick:(id)sender;
- (IBAction)SliderChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *OnSwitch;
@property (weak, nonatomic) IBOutlet UILabel *SliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *OnSLider;

@end
