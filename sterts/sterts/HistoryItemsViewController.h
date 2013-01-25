//
//  HistoryItems.h
//  sterts
//
//  Created by Joseph Baldwin on 1/24/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryItemsViewController : UITableViewController
{
    IBOutlet UIView *headerView;
}
- (UIView *) headerView;
- (IBAction)toggleEditingMode:(id)sender;

@end
