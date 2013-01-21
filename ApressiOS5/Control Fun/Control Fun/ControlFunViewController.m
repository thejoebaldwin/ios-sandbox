//
//  ControlFunViewController.m
//  Control Fun
//
//  Created by Joseph Baldwin on 1/21/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "ControlFunViewController.h"



@implementation ControlFunViewController

@synthesize nameField, numberField, sliderLabel, leftSwitch, rightSwitch, doSomethingButton;

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

- (IBAction)backgroundTap:(id)sender
{
    [nameField resignFirstResponder];
    [numberField resignFirstResponder];
    
}

- (IBAction)sliderChanged:(id)sender {
    UISlider *slider  = (UISlider *) sender;
    int progressAsInt = (int) roundf([slider value]);
    [sliderLabel setText:[NSString stringWithFormat:@"%i", progressAsInt]];
}

- (IBAction)switchChanged:(id)sender {
    
    UISwitch *whichSwitch = (UISwitch *) sender;
    BOOL setting = whichSwitch.isOn;
    [leftSwitch setOn:setting animated:YES];
    [rightSwitch setOn:setting animated:YES];
}

- (IBAction)toggleControl:(id)sender {
    
     if([sender selectedSegmentIndex] == 0) {
         [leftSwitch setHidden:YES];
         [rightSwitch setHidden:YES];
         [doSomethingButton setHidden:YES];

         
     } else {
         
         [leftSwitch setHidden:NO];
         [rightSwitch setHidden:NO];
         [doSomethingButton setHidden:NO];

     }
    
}

- (IBAction)toggleControls:(id)sender {
    
    //0 = switches index
    if([sender selectedIndex] == 0) {
        //[leftSwitch setHidden:YES];
        //[rightSwitch setHidden:YES];
        //[doSomethingButton setHidden:YES];
    } else {
        //[leftSwitch setHidden:NO];
        //[rightSwitch setHidden:NO];
        //[doSomethingButton setHidden:NO];

        
    }
    
}
- (IBAction)buttonPressed:(id)sender {
}
@end
