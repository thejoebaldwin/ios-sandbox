//
//  loginViewController.h
//  sterts
//
//  Created by Joseph Baldwin on 1/26/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
- (IBAction)loginButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;

@end
