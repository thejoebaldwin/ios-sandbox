//
//  loginViewController.h
//  sterts
//
//  Created by Joseph Baldwin on 1/26/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mainViewController;
@interface loginViewController : UIViewController
{
    mainViewController *main;
}

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
- (IBAction)loginButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)usernameFieldDone:(id)sender;
- (IBAction)passwordFieldDone:(id)sender;
- (IBAction)checkButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
