//
//  MainViewController.m
//  AlbumTracker
//
//  Created by Joseph on 2/25/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "MainViewController.h"
#import "NewAlbumViewController.h";

@interface MainViewController ()

@end

@implementation MainViewController


@synthesize pickerView;

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //will return the number of rows displayed in the picker
    return [albumItems count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //number of "dials" displayed in the picker
    return 1;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   //formatted string for picker display
   return @"temp";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        albumItems = [[NSMutableArray alloc] init];
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

- (IBAction)AddButtonClick:(id)sender
{
    //set up "popover" viewcontroller
    NewAlbumViewController *nac = [[NewAlbumViewController alloc] init];
    [nac SetAlbumItems:albumItems];
    
    //create navigation controller 
    UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:nac];
    [self presentViewController:navController animated:YES completion:nil];
    

    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"View Appeared:%@", albumItems);
    [pickerView reloadComponent:0];

}

- (IBAction)DeleteButtonClick:(id)sender {

    int selectedIndex = [pickerView selectedRowInComponent:0];
    [albumItems removeObjectAtIndex:selectedIndex];
    [pickerView reloadComponent:0];
}
@end
