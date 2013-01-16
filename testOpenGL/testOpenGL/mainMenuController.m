//
//  mainMenuController.m
//  testOpenGL
//
//  Created by Joseph on 1/15/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "mainMenuController.h"

@interface mainMenuController ()

@end

@implementation mainMenuController

@synthesize myTVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id) init
{
    self = [super init];
    if (self) {
        
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Main"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)updateSlider:(id)sender
{
    float scaleSize =  [scaleSlider value];
    [valueLabel setText:[[NSString alloc] initWithFormat:@"%f", (float) scaleSize]];
    scaleSize = scaleSize / 10.0f;
    [myTVC setScaleSize:scaleSize];
}

-(IBAction)updateSpeedSlider:(id)sender
{
    float speed =  [speedSlider value];
    [speedLabel setText:[[NSString alloc] initWithFormat:@"%f", (float) speed]];
    speed = speed / 100.0f;
    [myTVC setSpeed:speed];
}

@end
