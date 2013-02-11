//
//  testviewViewController.m
//  PickerTest
//
//  Created by Joseph on 2/11/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "testviewViewController.h"

@interface testviewViewController ()

@end

@implementation testviewViewController

@synthesize pickerView;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
      
    //[pickerView setDelegate:self];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    arrNumbers = [[NSArray alloc] initWithObjects:
                  [NSNumber numberWithInt:0],
                  [NSNumber numberWithInt:1],
                  [NSNumber numberWithInt:2],
                  [NSNumber numberWithInt:3],
                  [NSNumber numberWithInt:4],
                  [NSNumber numberWithInt:5],
                  [NSNumber numberWithInt:6],
                  [NSNumber numberWithInt:7],
                  [NSNumber numberWithInt:8],
                  [NSNumber numberWithInt:9],
                  
                  nil];

    [self startTimer];
    
}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrNumbers count];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
    
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger tempNumber =[[arrNumbers objectAtIndex:row] intValue];
    NSString *title = [NSString stringWithFormat:@"%i", tempNumber];
    return title;
    
    
    //return @"Hi THere";
}



-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Component:%i Row:%i", row, component);
}
 

- (void) startTimer {
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) tick:(NSTimer *) timer {
    count++;
    
    [pickerView selectRow:(count / 10) % 10 inComponent:0 animated:YES];
    [pickerView selectRow:count % 10 inComponent:1 animated:YES];

    
    }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddButtonClick:(id)sender {
    
    count++;
    
    [pickerView selectRow:(count / 10) % 10 inComponent:0 animated:YES];
    [pickerView selectRow:count % 10 inComponent:1 animated:YES];
      
}
@end
