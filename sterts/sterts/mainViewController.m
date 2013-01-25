//
//  JsonViewController.m
//  sterts
//
//  Created by Joseph on 1/9/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "mainViewController.h"
#import "openGLViewController.h"
#import "StertItem.h"
#import "StertItemStore.h"

@implementation mainViewController


@synthesize lastUpdatedLabel;

- (id) init
{
    self = [super init];
    
    if (self) {
        [[StertItemStore sharedStore] loadWithOwner:self withSelector:@"loadComplete"];
        
        //set up tab
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Main"];
        UIImage *image = [UIImage imageNamed:@"sterts_tab.png"];
        [tbi setImage:image];

    }
    return self;
}

-(void) loadComplete
{
    StertItem *tempStertItem = [[[StertItemStore sharedStore] allItems] objectAtIndex:0];
    
    [hitpointSlider setValue:(float)[tempStertItem hitpoints]];
    [hitpointLabel setText: [NSString stringWithFormat:@"%i", [tempStertItem hitpoints]] ];
    
    [manaSlider setValue:(float)[tempStertItem mana]];
    [manaLabel setText: [NSString stringWithFormat:@"%i", [tempStertItem mana]] ];
}


- (IBAction)postButton:(id)sender
{
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Are you sure?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Submit"
                                  otherButtonTitles:nil];
    
    [actionSheet showInView:self.tabBarController.view];
}


- (void) actionSheet:(UIActionSheet *) actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {

        int hitpoints = [hitpointSlider value];
        int mana =[manaSlider value];
        [[StertItemStore sharedStore] addItemWithHitpoints:hitpoints withMana:mana];
        
        
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cancelled"
                                                     message:@"Submission Cancelled"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];

    }
}


- (IBAction)updateHitpointsLabel:(id)sender
{
    [hitpointLabel setText:[[NSString alloc] initWithFormat:@"%i", (int)[hitpointSlider value ]]];
}

- (IBAction)updateManaLabel:(id)sender
{
     [manaLabel setText:[[NSString alloc] initWithFormat:@"%i", (int)[manaSlider value ]]];
}


- (IBAction)go3DView:(id)sender
{
    
    openGLViewController *ovc = [[openGLViewController alloc] init];
    
    [[self navigationController] pushViewController:ovc animated:YES];

}

@end 
