//
//  Shape_04ViewController.h
//  Shape_04
//
//  Created by test on 9/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Shape_04ViewController : UIViewController
{
	CALayer	*rootLayer;
    NSMutableArray *paths;
    BOOL ranOnce;
   
    
    NSMutableArray *smartAnimations;
    
    int currentAnimationIndex;
    CGFloat animationTimeOffset;
    CGFloat animationDuration;
    
    IBOutlet UIButton *clearButton;
    
    IBOutlet UIButton *mainButton;
    CGPoint orgLastTouch;
    CGPoint lastTouch;
}

-(void)startAnimation:(int) atIndex;
- (IBAction) clearButtonClick:(id) sender;

@end

