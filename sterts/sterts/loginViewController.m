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

@synthesize usernameField, passwordField, activity;

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
    
    
    [activity startAnimating];
    
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
    //NSLog(@"trying to load user");
    if (!tempUser) {
        NSLog(@"No User in archive");
    }
    else {
        NSLog(@"Restored User:%@", tempUser);
    }
    
    [[StertItemStore sharedStore] setCurrentUser:tempUser];
    
}



- (void) returnToForm
{
    UITabBarController *test = [self presentingViewController];
    mainViewController *m = [test selectedViewController];

    
    void (^block)(void) = ^{
        NSLog(@"Insode block 2");
        [m loadComplete];
    };
    
    
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:block];

}

//fires on json request to load user
- (void) loadComplete
{
    [activity stopAnimating];
    
    User *tempUser = [[StertItemStore sharedStore]  CurrentUser ];
    [tempUser setPassword:[passwordField text]];
    //NSLog(@"User Retrieved:%@", tempUser);
    [self saveChanges];
    //UIAlertView *uv = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You Have Successfully Logged in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //[uv show];
    
      
    void (^block)(void) = ^{
        NSLog(@"inside LVC calling block");
        //[m loadCompleteFromLogin];
        [self returnToForm];
              
        
        
       
        
        
        //[[StertItemStore sharedStore] loadSterts:self withSelector:@"loadComplete"];
    };
    //  NSLog(@"%@    ||   %@", test, [test selectedViewController]);

     [[StertItemStore sharedStore] loadSterts:nil withSelector:@"loadComplete" withBlock:block];
    
    
}



- (BOOL) saveChanges
{
    
      
    NSString *path = [self itemArchivePath];
    
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
   
    
}

- (IBAction)usernameFieldDone:(id)sender {
}

- (IBAction)passwordFieldDone:(id)sender {
}

- (IBAction)checkButtonClick:(id)sender {
    
    [self loadUserFromArchive];
    
    UITabBarController *test = [self presentingViewController];
    mainViewController *m = [test selectedViewController];
    
    NSLog(@"%@    ||   %@", test, [test selectedViewController]);
    

}
@end
