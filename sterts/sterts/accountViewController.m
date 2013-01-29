//
//  accountViewController.m
//  Sterts
//
//  Created by Joseph on 1/28/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "accountViewController.h"
#import "loginViewController.h"
@interface accountViewController ()

@end

@implementation accountViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}

 - (id) init
{
    self = [super init];
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Account"];

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
    
    
    loginViewController *lvc = [[loginViewController alloc] init];
    UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:lvc];
    [self presentViewController:navController animated:YES completion:nil];

}


@end
