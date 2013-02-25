//
//  NewAlbumViewController.m
//  AlbumTracker
//
//  Created by Joseph on 2/25/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "NewAlbumViewController.h"

@interface NewAlbumViewController ()

@end

@implementation NewAlbumViewController

@synthesize NameField, ArtistField;

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NameField resignFirstResponder];
    [ArtistField resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"NewAlbumViewController init");

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"NewAlbumViewController finished loading");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CancelButtonClick:(id)sender {
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}
- (IBAction)AddButtonClick:(id)sender {
    
    
    [albumItems addObject:@"Hi There"];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}


- (NSMutableArray *) AlbumItems
{
    return albumItems;
}
- (void) SetAlbumItems:(NSMutableArray *) items
{
    albumItems = items;
}
@end
