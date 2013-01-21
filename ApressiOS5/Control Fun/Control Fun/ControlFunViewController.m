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
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [doSomethingButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [doSomethingButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateNormal];
    
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
         [leftSwitch setHidden:NO];
         [rightSwitch setHidden:NO];
         [doSomethingButton setHidden:YES];

         
     } else {
         
         [leftSwitch setHidden:YES];
         [rightSwitch setHidden:YES];
         [doSomethingButton setHidden:NO];

     }
    
}


- (IBAction)buttonPressed:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                initWithTitle:@"Are you sure?"
                                  delegate:self
                                  cancelButtonTitle:@"No Way!"
                                  destructiveButtonTitle:@"Yes, I'm Sure"
                                  otherButtonTitles:nil];
    [actionSheet showInView:self.view];
                        
    
    
}

- (void) actionSheet:(UIActionSheet *) actionSheet
            didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        NSString *msg = nil;
        
        if (nameField.text.length > 0) {
            msg = [[NSString alloc] initWithFormat:@"You can breathe easy %@, everything went ok", nameField.text];
        } else {
            msg = @"You can breathe easy, everything went ok.";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something was done" message:msg delegate:self cancelButtonTitle:@"Phew!" otherButtonTitles:nil];
        [alert show];
}
}
@end
