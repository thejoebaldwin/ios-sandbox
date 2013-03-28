//
//  PinViewController.m
//  twitterdemo
//
//  Created by Joseph Baldwin on 3/27/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "PinViewController.h"

@interface PinViewController ()

@end



@implementation PinViewController

@synthesize PinWebView;


-(void) SetAuthorizationURL:(NSString *) url
{
    _AuthorizationURL = url;
}


-(id) init
{
    self = [super init];
    if (self)
    {
        
        UIBarButtonItem *DoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(BackButtonClick)];
        [[self navigationItem] setLeftBarButtonItem:DoneButton];
    }
    
    
    return self;
    
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:_AuthorizationURL ];
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [PinWebView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)BackButtonClick
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
@end
