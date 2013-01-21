//
//  ControlFunViewController.m
//  Control Fun
//
//  Created by Joseph Baldwin on 1/21/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "ControlFunViewController.h"

@interface ControlFunViewController ()

@end

@implementation ControlFunViewController

//brontosaurus image borrowed from http://geekcentricity.com/wp-content/uploads/2010/12/Brontosaurus.jpg

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
