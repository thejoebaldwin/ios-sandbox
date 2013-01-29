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
#import "loginViewController.h"

@implementation mainViewController


@synthesize lastUpdatedLabel;

- (id) init
{
    self = [super init];
    
    if (self) {
        [[StertItemStore sharedStore] loadWithOwner:self completionSelector:@"loadComplete"];
        
        //[self loadUserFromArchive];
        [[StertItemStore sharedStore] loadSterts];

        
             //set up tab
        //[[StertItemStore sharedStore] loadSterts];
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Main"];
        UIImage *image = [UIImage imageNamed:@"sterts_tab.png"];
        [tbi setImage:image];
        
    }
    return self;
}


//this has to go somewhere else, duplicated in login view controller.
//should login view be presented first with login animation, then if successful load to main?


- (NSString *) itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //get one and only documemnt directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"user.archive"];
    
}



- (void) loadUserFromArchive
{
    NSString *path = [self itemArchivePath];
    User *tempUser =  [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"trying to load user");
    if (!tempUser) {
        NSLog(@"No User in archive");
    }
    else {
        NSLog(@"Restored User:%@", tempUser);
    }
    
    [[StertItemStore sharedStore] setCurrentUser:tempUser];
    
}



-(void) loadComplete
{
        //need to have it so this prevents loading if not logged in
    //also fix json request to require user id and auth token
    //also fix json post to contain user id and auth token
    //[self loadUserFromArchive];
    
    [self loadUserFromArchive];
    
    if (  [[StertItemStore sharedStore] isLoggedIn]) {
        
    }
    else
    {
        loginViewController *lvc = [[loginViewController alloc] init];
        UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:lvc];
        [self presentViewController:navController animated:YES completion:nil];
        
    }

    StertItem *tempStertItem = [[[StertItemStore sharedStore] allItems] objectAtIndex:0];
    
    [hitpointSlider setValue:(float)[tempStertItem hitpoints]];
    [hitpointLabel setText: [NSString stringWithFormat:@"%i", [tempStertItem hitpoints]] ];
    
    [manaSlider setValue:(float)[tempStertItem mana]];
    [manaLabel setText: [NSString stringWithFormat:@"%i", [tempStertItem mana]] ];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/YY h:mm a"];
    
    
    NSString* createdString = [formatter stringFromDate:[tempStertItem created]];
    [lastUpdatedLabel setText:createdString];
    
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
