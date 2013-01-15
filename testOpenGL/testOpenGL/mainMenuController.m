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

@end
