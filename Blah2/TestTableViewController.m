//
//  TestTableViewController.m
//  Blah2
//
//  Created by Joseph on 3/4/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "TestTableViewController.h"

@interface TestTableViewController ()

@end

@implementation TestTableViewController

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

- (IBAction)SubmitButtonClick:(id)sender {
    
    
    [_IceCreamFlavors addObject:@"New Flavor"];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}


-(void) SetIceCreamFlavors:(NSMutableArray *) array
{
    _IceCreamFlavors = array;
}

@end
