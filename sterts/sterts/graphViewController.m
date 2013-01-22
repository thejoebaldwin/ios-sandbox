//
//  graphViewController.m
//  sterts
//
//  Created by Joseph Baldwin on 1/21/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "graphViewController.h"

@interface graphViewController ()

@end

@implementation graphViewController


- (id)init
{
    self = [super init];
    
    if (self) {
             
        //set up tab
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Graph"];
        UIImage *image = [UIImage imageNamed:@"sterts_graph_tab.png"];
        [tbi setImage:image];

     
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

- (void) refreshWebView
{
    urlAddress = @"http://sterts.humboldttechgroup.com/web/app_dev.php/charts";
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    //URL Request Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [graphWebView loadRequest:requestObj];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshWebView];
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshButtonClick:(id)sender
{
    [self refreshWebView];
}
@end
