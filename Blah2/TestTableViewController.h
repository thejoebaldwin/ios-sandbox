//
//  TestTableViewController.h
//  Blah2
//
//  Created by Joseph on 3/4/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTableViewController : UIViewController
{
    
    NSMutableArray  *_IceCreamFlavors;
    
}

-(void) SetIceCreamFlavors:(NSMutableArray *) array;

- (IBAction)SubmitButtonClick:(id)sender;

@end
