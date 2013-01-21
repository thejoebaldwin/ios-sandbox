//
//  ControlFunViewController.h
//  Control Fun
//
//  Created by Joseph Baldwin on 1/21/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlFunViewController : UIViewController <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
- (IBAction) textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)sliderChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
- (IBAction)switchChanged:(id)sender;

- (IBAction)toggleControl:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *doSomethingButton;
- (IBAction)buttonPressed:(id)sender;
@end
