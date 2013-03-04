//
//  MainViewController.m
//  Blah2
//
//  Created by Joseph on 3/4/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "MainViewController.h"

#import "TestTableViewController.h"

@implementation MainViewController



-(id) init
{
    
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    
    IceCreamFlavors = [[NSMutableArray alloc] init];
    [IceCreamFlavors addObject:@"Chocolate"];
    [IceCreamFlavors addObject:@"Vanilla"];
    [IceCreamFlavors addObject:@"Strawberry"];
    [IceCreamFlavors addObject:@"Mint Chocolate Chip"];
    }
    
    
    
    return self;
    
}


-(id) initWithStyle:(UITableViewStyle)style
{
    
    return [self init];
    
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [IceCreamFlavors count];
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestTableViewController *test = [[TestTableViewController alloc] init];
    [test SetIceCreamFlavors:IceCreamFlavors];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:test];
    [self presentViewController:navController animated:YES completion:nil];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    //UITableView *view = (UITableView *) [self view];
    [[self tableView] reloadData];
//    [view reloadData];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self HeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [[self HeaderView] bounds].size.height;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    
    [[cell textLabel] setText:[IceCreamFlavors objectAtIndex:[indexPath row]]];
    return cell;
    
    
}


-(IBAction) AddNewItem:(id)sender
{
    TestTableViewController *test = [[TestTableViewController alloc] init];
    
    [test SetIceCreamFlavors:IceCreamFlavors];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:test];
    [self presentViewController:navController animated:YES completion:nil];

}

- (UIView *) HeaderView
{
    if (!_HeaderView)
    {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _HeaderView;
}




@end
