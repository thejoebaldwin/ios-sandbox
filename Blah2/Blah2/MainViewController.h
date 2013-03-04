//
//  MainViewController.h
//  Blah2
//
//  Created by Joseph on 3/4/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainViewController : UITableViewController
{
    NSMutableArray *IceCreamFlavors;
    IBOutlet UIView *_HeaderView;
}

- (UIView *) HeaderView;
- (IBAction) AddNewItem:(id) sender;
- (IBAction) EditItem:(id) sender;

@end
