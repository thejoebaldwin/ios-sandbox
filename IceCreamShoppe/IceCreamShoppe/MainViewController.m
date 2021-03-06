//
//  MainViewController.m
//  IceCreamShoppe
//
//  Created by student on 3/4/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "FlavorItemStore.h"
#import "FlavorItem.h"

@implementation MainViewController

/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self HeaderView];
}
 */
/*
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [[self HeaderView] bounds].size.height;
}
*/

- (UIView *) HeaderView
{
    if (!_HeaderView)
    {
       [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    
    return _HeaderView;
}

- (IBAction) AddButtonClick:(id) sender
{
    NSLog(@"Add Button Click");
    
    //will call our detail view
    DetailViewController  *detail = [[DetailViewController alloc] init];
    [detail SetIceCreamFlavors:_IceCreamFlavors];
    [detail SetSelectedIndex: -1];
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:nav animated:YES completion:nil];

    
    
    
}
- (IBAction) DeleteButtonClick:(id) sender
{
    NSLog(@"Delete Button Click");
    if (_deleteMode)
    {
        _deleteMode = NO;
    }
    else
    {
        _deleteMode = YES;
    }
    
    
}


//New
- (IBAction)EditButtonClick:(id)sender {

    if ([self isEditing]) {
        //Change text of button
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        //turn off editing
        [self setEditing:NO animated:YES];
    }
    else {
        //change text
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        //turn on editing
        [self setEditing:YES animated:YES];
    }

}

//New
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        [_IceCreamFlavors removeObjectAtIndex:[indexPath row]];
        NSLog(@"New Length %i", [_IceCreamFlavors count]);

        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
          }
}

//new
- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *flavor = [_IceCreamFlavors objectAtIndex:[sourceIndexPath row]];
    [_IceCreamFlavors removeObjectAtIndex:[sourceIndexPath row]];
    [_IceCreamFlavors insertObject:flavor atIndex:[destinationIndexPath row]];
}

-(void) viewDidAppear:(BOOL)animated
{
    UITableView *view = (UITableView *) [self view];
    [view reloadData];
    
}

-(id) init
{
    self = [super init];
    //add custom initialization
    if (self) {
        //if properly initialized, do this code
        
        
       // _IceCreamFlavors = [[NSMutableArray alloc] init];
        
        
        [[[FlavorItemStore sharedStore] AllItems] addObject:[[FlavorItem alloc] initWithName:@"Chocolate"]];
        [[[FlavorItemStore sharedStore] AllItems] addObject:[[FlavorItem alloc] initWithName:@"Vanilla"]];
        [[[FlavorItemStore sharedStore] AllItems] addObject:[[FlavorItem alloc] initWithName:@"Strawberry"]];
        [[[FlavorItemStore sharedStore] AllItems] addObject:[[FlavorItem alloc] initWithName:@"Neopolitan"]];

        
        //[_IceCreamFlavors addObject:@"Chocolate"];
        //[_IceCreamFlavors addObject:@"Vanilla"];
        //[_IceCreamFlavors addObject:@"Strawberry"];
        //[_IceCreamFlavors addObject:@"Neopolitan"];
        
        
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(AddButtonClick:)];
        //Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];

        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];

    }
    return self;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //return [_IceCreamFlavors count];
    return [[[FlavorItemStore sharedStore] AllItems]  count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    
    FlavorItem *tempItem = [_IceCreamFlavors objectAtIndex:[indexPath row]];
    //NSString *display = [[NSString alloc] initWithString:[_IceCreamFlavors objectAtIndex:[indexPath row]]];
    [[cell textLabel] setText:[tempItem Name]];
    
    
    return cell;
}

- (NSMutableArray *) IceCreamFlavors
{
    return _IceCreamFlavors;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_deleteMode)
    {
        //delete selected row and update
        [_IceCreamFlavors removeObjectAtIndex:[indexPath row]];
        UITableView *view = (UITableView *) [self view];
        [view reloadData];
        _deleteMode = NO;
    }
    else
    {
    
    //will call our detail view
    DetailViewController  *detail = [[DetailViewController alloc] init];
    [detail SetIceCreamFlavors:_IceCreamFlavors];
    [detail SetSelectedIndex:[indexPath row]];
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:nav animated:YES completion:nil];
    }
}



@end
