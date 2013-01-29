//
//  loginViewController.m
//  sterts
//
//  Created by Joseph Baldwin on 1/26/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "loginViewController.h"
#import "StertItemStore.h"
#import "mainViewController.h"
#import "User.h"
@interface loginViewController ()

@end

@implementation loginViewController

@synthesize usernameField, passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) init
{
    
    self = [super init];
    if (self) {
            //UIImage *image = [UIImage imageNamed:@"sterts_tab.png"];
        //[tbi setImage:image];
        

        //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width - 30, self.view.frame.size.height - 30);
        
    }
    
    return self;
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:TRUE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    User *temp = [[StertItemStore sharedStore] CurrentUser];
    if (temp) {
        [usernameField setText:[temp username]];
        [passwordField setText:[temp password]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setMainController:(mainViewController *) mvc
{
    main = mvc;
}

- (IBAction)loginButtonClick:(id)sender {
    
    
    NSString *username = [usernameField text];
    NSString *password = [passwordField text];
    //use the password to encrypt something. username plus date?
    
  [[StertItemStore sharedStore] getAuthToken:username withPassword:password withOwner:self completionSelector:@"loadComplete"];

    
}



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



//fires on json request to load user
- (void) loadComplete
{
    User *tempUser = [[StertItemStore sharedStore]  CurrentUser ];
    [tempUser setPassword:[passwordField text]];
    NSLog(@"User Retrieved:%@", tempUser);
    [self saveChanges];
}



- (BOOL) saveChanges
{
    
    NSLog(@"SAVING");
    
    // returns success or failure
    NSString *path = [self itemArchivePath];
    
    
    //THIS IS WORKING HERE
    //IT KNOWS WHEN ITS STORED A NULL VALUE
    
    
    //THIS IS NOT WORKING
    User *temp = [[StertItemStore sharedStore] CurrentUser];
    
    if (!temp) {
        temp = [[User alloc] init];
        [temp setUsername:@"t"];
        [temp setPassword:@"t"];
        
    }
   
    BOOL success = [NSKeyedArchiver archiveRootObject:temp toFile:path];
    if (success) {
        NSLog(@"Saved the current user:%@", temp);
    } else {
        NSLog(@"Could not save the current user");
    }
    //NSLog(@"Path:%@", path);
    return success;
}


- (IBAction)cancelButtonClick:(id)sender {
    
       
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    //[self saveChanges];
    
}

- (IBAction)usernameFieldDone:(id)sender {
}

- (IBAction)passwordFieldDone:(id)sender {
}

- (IBAction)checkButtonClick:(id)sender {
    
    [self loadUserFromArchive];

}
@end
