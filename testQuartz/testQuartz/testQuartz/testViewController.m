//
//  testViewController.m
//  testQuartz
//
//  Created by Joseph on 1/16/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "testViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface testViewController ()

@end

@implementation testViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self bringSubviewToFront:testButton];
    [[self view] bringSubviewToFront:testButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
