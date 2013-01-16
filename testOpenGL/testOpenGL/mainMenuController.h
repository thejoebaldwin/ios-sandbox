//
//  mainMenuController.h
//  testOpenGL
//
//  Created by Joseph on 1/15/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "testViewController.h"

@interface mainMenuController : UIViewController
{
    
  
    __weak IBOutlet UISlider *scaleSlider;

    __weak IBOutlet UILabel *speedLabel;
    __weak IBOutlet UISlider *speedSlider;
    __weak IBOutlet UILabel *valueLabel;
}

@property (nonatomic, weak) testViewController *myTVC;

- (IBAction)updateSlider:(id)sender;
- (IBAction)updateSpeedSlider:(id)sender;

@end
