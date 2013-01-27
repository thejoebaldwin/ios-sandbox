//
//  loginViewController.m
//  sterts
//
//  Created by Joseph Baldwin on 1/26/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "loginViewController.h"
#import "StertItemStore.h"

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
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Account"];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)cancelButtonClick:(id)sender {
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)usernameFieldDone:(id)sender {
}

- (IBAction)passwordFieldDone:(id)sender {
}
@end
