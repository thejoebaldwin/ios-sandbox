//
//  OkToRotateViewController.m
//  TestNoRotate
//
//  Created by Joseph Baldwin on 4/19/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "OkToRotateViewController.h"

@interface OkToRotateViewController ()

@end

@implementation OkToRotateViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) SetOtherView:(UIViewController *)other
{
    otherView = other;
}

- (IBAction)GoToButtonCLick:(id)sender {
    
    [[[self view] window] setRootViewController:otherView];
}

@end
