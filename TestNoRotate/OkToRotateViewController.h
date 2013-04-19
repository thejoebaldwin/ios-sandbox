//
//  OkToRotateViewController.h
//  TestNoRotate
//
//  Created by Joseph Baldwin on 4/19/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OkToRotateViewController : UIViewController

{
    UIViewController *otherView;
    
    
}

-(void) SetOtherView:(UIViewController *) other;

- (IBAction)GoToButtonCLick:(id)sender;

@end
