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
        NSString *username = [[[StertItemStore sharedStore] CurrentUser] username ];
        [usernameField setText:username];
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
    

    
    //contruct json request to post
    
    
    //if successful, save username and password
    
    //if not need to communication bad login to user
    
    
    
    //need a completion block on this call!!!
    
    [[StertItemStore sharedStore] getAuthToken:username withPassword:password];
    
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}



- (NSString *) itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //get one and only documemnt directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"user.archive"];
    
}

- (BOOL) saveChanges
{
    
    NSLog(@"SAVING");
    
    // returns success or failure
    NSString *path = [self itemArchivePath];
    //NSLog(@"%@", path);
    User *temp = [[User alloc] init];
                  [temp setUsername:@"t"];
                  [temp setPassword:@"t"];
    temp = [[StertItemStore sharedStore] CurrentUser];
    //OOL success = [NSKeyedArchiver archiveRootObject:[[StertItemStore sharedStore] CurrentUser] toFile:path];
                  BOOL success = [NSKeyedArchiver archiveRootObject:temp toFile:path];
    if (success) {
        NSLog(@"Saved the current user");
    } else {
        NSLog(@"Could not save the current user");
    }
    //NSLog(@"Path:%@", path);
    return success;
}

- (void) loadUserFromArchive
{
    NSString *path = [self itemArchivePath];
    User *tempUser =  [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [[StertItemStore sharedStore] setCurrentUser:tempUser];
    NSLog(@"trying to load user");
    if (!tempUser) {
        NSLog(@"No User in archive");
    }
    else {
        NSLog(@"User:%@", tempUser);
    }
}


- (IBAction)cancelButtonClick:(id)sender {
    
       
   // [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self saveChanges];
}

- (IBAction)usernameFieldDone:(id)sender {
}

- (IBAction)passwordFieldDone:(id)sender {
}

- (IBAction)checkButtonClick:(id)sender {
    [self loadUserFromArchive];

}
@end
