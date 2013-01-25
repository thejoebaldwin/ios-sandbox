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


- (UIView *) headerView
{
       if (!headerView) {
               [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
        NSLog(@"loaded the headerview");
    }
    return headerView;
}

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
     //check to see if we can reuse a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    
    StertItem *s = [[[StertItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[s descriptionQuick]];
    return cell;
}


- (UIView *) tableView: (UITableView *) tv viewForHeaderInSection:(NSInteger)section
{
    return [self headerView];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [[self headerView] bounds].size.height;
}

- (IBAction) toggleEditingMode:(id)sender
{
    // if we are currently in editing mode...
    if ([self isEditing]) {
        //change the text of the button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        //turn off editing mode'
        [self setEditing:NO animated:YES];
        
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
        
    }
    
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if the tableview is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[StertItemStore sharedStore] allItems];
        StertItem *s = [items objectAtIndex: [indexPath row] ];
        NSLog(@"about to delete");
        [[StertItemStore sharedStore] removeItem:s];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
