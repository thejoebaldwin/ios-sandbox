 //
//  brontoViewController.m
//  BrontoPronto
//
//  Created by Joseph Baldwin on 1/10/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "brontoViewController.h"



@implementation brontoViewController

- (id) init{
    
    self =  [super init];
    if (self)
    {
        
        
    }
    
    return self;
    
}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        org = [t locationInView:[super view ]];
            }
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        CGPoint loc = [t locationInView:[super view ]];

        CGRect oneFrame = [oneImage frame];
        oneFrame.origin.y = oneFrame.origin.y +  (loc.y - org.y);
        if (super.view.frame.origin.y + super.view.frame.size.height < oneFrame.origin.y) {
            oneFrame.origin.y = super.view.frame.origin.y - oneFrame.size.height;
        }
        [oneImage setFrame:oneFrame];

        
        CGRect twoFrame = [twoImage frame];
        twoFrame.origin.y = twoFrame.origin.y +  (loc.y - org.y);
        if (super.view.frame.origin.y + super.view.frame.size.height < twoFrame.origin.y) {
            twoFrame.origin.y = super.view.frame.origin.y - twoFrame.size.height;
        }
        [twoImage setFrame:twoFrame];

        CGRect threeFrame = [threeImage frame];
        threeFrame.origin.y = threeFrame.origin.y +  (loc.y - org.y);
        if (super.view.frame.origin.y + super.view.frame.size.height < threeFrame.origin.y) {
            threeFrame.origin.y = super.view.frame.origin.y - threeFrame.size.height;
        }
        [threeImage setFrame:threeFrame];

        
        
        org = loc;

    }
    //redraw
    [[super view] setNeedsDisplay ];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


@end
