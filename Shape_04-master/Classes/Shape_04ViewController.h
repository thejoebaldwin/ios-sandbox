//
//  Shape_04ViewController.h
//  Shape_04
//
//  Created by test on 9/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Shape_04ViewController : UIViewController {

	CALayer						*rootLayer;
	
	CAShapeLayer			*shapeLayer;
    CAShapeLayer			*shapeLayer2;
	
	//CGMutablePathRef		squarePath;
	//CGMutablePathRef		roundPath;
    //	CGMutablePathRef		boxPath;
    
    //CGMutablePathRef		boxPath2;
    NSMutableArray *paths;
    BOOL ranOnce;

}

-(void)startAnimation;
-(void)setupTrunk;

@end

