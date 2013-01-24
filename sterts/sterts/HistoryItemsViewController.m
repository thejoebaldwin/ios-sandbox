//
//  HistoryItems.m
//  sterts
//
//  Created by Joseph Baldwin on 1/24/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "HistoryItemsViewController.h"

#import "StertItemStore.h"
#import "StertItem.h"

@implementation HistoryItemsViewController


-(id) init{
    // Call the super class's desingated  initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        //set up tab
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"History"];

    }
    return self;
}

- (id) initWithStyle:(UITableViewStyle)style
{
    return [self init];
    
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{

    return [[[StertItemStore sharedStore] allItems] count];
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create an instance of uiTableViewCell with default appearance
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    StertItem *s = [[[StertItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];

    [[cell textLabel] setText:[s descriptionQuick]];
    
    return cell;
}


@end
