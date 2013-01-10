//
//  slotViewController.m
//  MarioSlotMachine
//
//  Created by Joseph on 1/10/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "slotViewController.h"


@implementation slotViewController


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
 
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
    
    if (runningOne) {
        runningOne = NO;
    } else if (runningTwo) {
        runningTwo = NO;
    } else if (runningThree){
        runningThree = NO;
        
        //DID THEY WIN?
        NSLog(@"%d,%d,%d", indexOne, indexTwo, indexThree);
        if (indexOne == indexTwo && indexTwo == indexThree) {
           // [testLabel setText:@"WIN"];
            extraLife++;
            [helloLabel setText:[[NSString alloc] initWithFormat:@"%d", extraLife]];
            
        } else {
            //[testLabel setText:@"LOSS"];
        }
        
    }
}

- (int) getRandomImageIndex
{
    int r = arc4random() % [arrImages count];
    return r;
}

- (void) startTimer {
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) tick:(NSTimer *) timer {

    if (runningOne) {
        indexOne = [self getRandomImageIndex];
        [firstImage setImage:[arrImages objectAtIndex:indexOne]];
    }
    if (runningTwo) {
        indexTwo = [self getRandomImageIndex];
        [secondImage setImage:[arrImages objectAtIndex:indexTwo]];
    }
    if (runningThree) {
        indexThree = [self getRandomImageIndex];
        [thirdImage setImage:[arrImages objectAtIndex:indexThree]];
    }
}


- (void) viewDidLoad
{
    
}

- (id) init
{
    self = [super init];
       
    arrImages = [[NSMutableArray alloc] init];
    
    [arrImages addObject:[UIImage imageNamed: @"star.png"]];
    [arrImages addObject:[UIImage imageNamed: @"radish.png"]];
    [arrImages addObject:[UIImage imageNamed: @"shyguy.png"]];
    
    
    indexOne = [self getRandomImageIndex];
    indexTwo = [self getRandomImageIndex];
    indexThree = [self getRandomImageIndex];

    
    if (self) {
     
    }
    return self;
}


-(IBAction)updateImage:(id)sender
{
    if (timerRunning == NO)
    {
        [self startTimer];
        timerRunning = YES;
    }

    runningOne = YES;
    runningTwo = YES;
    runningThree = YES;
}

@end
