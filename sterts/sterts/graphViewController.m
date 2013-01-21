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
        
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Graph"];
        
        // Crea a UIImage from a file
        // This will use Hypno@2x.png on retina display devices
        // UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        // Put that image on the tab bar item
        // [tbi setImage:i];
     
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
    NSString *urlAddress = @"http://sterts.humboldttechgroup.com/web/app_dev.php/charts";
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    //URL Request Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [graphWebView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
