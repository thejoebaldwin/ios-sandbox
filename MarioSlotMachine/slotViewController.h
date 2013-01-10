//
//  slotViewController.h
//  MarioSlotMachine
//
//  Created by Joseph on 1/10/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface slotViewController : UIViewController
{

    __weak IBOutlet UIImageView *firstImage;
    __weak IBOutlet UIImageView *secondImage;
   
    __weak IBOutlet UILabel *helloLabel;
    
    __weak IBOutlet UIImageView *thirdImage;
    NSMutableArray *arrImages;
    int indexOne, indexTwo, indexThree;
    int extraLife;
    
    bool runningOne, runningTwo, runningThree, timerRunning;
    
}

- (IBAction)updateImage:(id)sender;

- (int) getRandomImageIndex;

@end
