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
    }
    
    return self;
    
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
    
    //stertitemstore for auth? or just do it all here?
    
    //contruct json request to post
    
    //response should contain authentication token
    
    //if successful, save username and password
    
    [[StertItemStore sharedStore] getAuthToken:username withHash:password];
    
    
}

- (IBAction)cancelButtonClick:(id)sender {
    
    
}
@end
