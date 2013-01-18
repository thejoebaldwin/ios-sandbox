//
//  Shape_04ViewController.m
//  Shape_04
//
//  Created by test on 9/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Shape_04ViewController.h"

@implementation Shape_04ViewController

- (id)init
{
    self = [super init];
    if (self){
        currentAnimationIndex = 0;
    }
    return self;
    }

- (void) setupBranchWithAngle:(float)angle withTranslateX:(float)translateX withTranslateY:(float)translateY withScaleX:(float)scaleX withScaleY:(float)scaleY
{
    CGPoint center = self.view.center;
    
        
    float bottomWidth = 5.0;
    float topWidth = bottomWidth/ 2;
    float initialHeight = 5.0;
    
    float topGrow = 3.5;
    float bottomGrow = 3.00;
    float heightGrow = 40.0;
    
    CGAffineTransform m = CGAffineTransformIdentity;

    //Initial Shape State for animation
    CGPoint topLeft = CGPointMake(center.x - topWidth / 2, center.y - initialHeight);
    CGPoint topRight = CGPointMake(center.x + topWidth / 2, center.y - initialHeight);
    CGPoint bottomRight = CGPointMake(center.x + bottomWidth / 2, center.y + initialHeight);
    CGPoint bottomLeft = CGPointMake(center.x - bottomWidth / 2, center.y + initialHeight);
	
	CGMutablePathRef tempPath1 = CGPathCreateMutable();
    CGPathMoveToPoint(tempPath1, &m, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath1, &m, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath1, &m, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath1, &m, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath1);
	
    
    //Ending Shape State for animation
    topLeft.x -= topWidth / 2 * topGrow;
    topLeft.y -= initialHeight * heightGrow;
    topRight.x += topWidth / 2 * topGrow;
    topRight.y -= initialHeight * heightGrow;
    bottomRight.x += bottomWidth / 2 * bottomGrow;
    bottomLeft.x -= bottomWidth / 2 * bottomGrow;
    
 	CGMutablePathRef tempPath2 = CGPathCreateMutable();
    CGPathMoveToPoint(tempPath2, &m, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath2, &m, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath2, &m, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath2, &m, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath2);
    
    //Build animation
    CABasicAnimation *tempAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];

    tempAnimation1.duration = animationDuration;
    tempAnimation1.beginTime = animationTimeOffset;
    tempAnimation1.removedOnCompletion = NO;
	tempAnimation1.fillMode = kCAFillModeForwards;
    tempAnimation1.fromValue = (id)tempPath1;
	tempAnimation1.toValue = (id)tempPath2;
    
    
    CABasicAnimation *rotateAnim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.beginTime = animationTimeOffset;
    rotateAnim.fromValue=[NSNumber numberWithDouble:angle];
    rotateAnim.toValue=[NSNumber numberWithDouble:angle];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.autoreverses = NO;
    group.duration = animationDuration + animationTimeOffset;
    
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = [NSArray arrayWithObjects:tempAnimation1, rotateAnim,  nil];
 
    NSLog(@"adding animation # %i with a begin time of %f and a length of %f", 0, animationTimeOffset, animationDuration );
       animationTimeOffset += animationDuration;
    [animations addObject:group];
}




- (void)loadView 
{
	
    animationDuration = 3.0;
    animationTimeOffset = 0;

    
	UIView *appView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	appView.backgroundColor = [UIColor blackColor];
	self.view = appView;
	[appView release];
	
	rootLayer	= [CALayer layer];
	rootLayer.frame = self.view.bounds;
	[self.view.layer addSublayer:rootLayer];

    animations = [[NSMutableArray alloc] init];

    CGFloat angle = M_PI * -5 / 180.0;
   
    [self setupBranchWithAngle:-angle withTranslateX:0.0f withTranslateY:0 withScaleX:0.25f withScaleY:0.25f];

    [self setupBranchWithAngle:angle withTranslateX:0 withTranslateY:0 withScaleX:0.25f withScaleY:0.25f];
    
    [self setupBranchWithAngle:0 withTranslateX:0 withTranslateY:0.0f withScaleX:1.0f withScaleY:1.0f];
    
    [self nextAnimation];
}


- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"Finished %@ %d", anim, flag );
}



-(void) trunkAnimation
{
    [self startAnimation:0];
}

-(void) branchAnimation
{
    [self startAnimation:1];
}

-(void) nextAnimation
{
    for (int i = 0; i < [animations count]; i++) {
        
        [self startAnimation:i];
       
    }

}

-(void)startAnimation:(int)atIndex
{
    CAShapeLayer *tempLayer = [CAShapeLayer layer];
	UIColor *fillColor = [UIColor colorWithHue:0.584 saturation:0.8 brightness:0.9 alpha:1.0];
    
    
    switch (atIndex)
    {
        case 0:
            fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            break;
        case 1:
            fillColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            break;
        case 2:
            fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            break;
    }
    
	tempLayer.fillColor = fillColor.CGColor;
	//UIColor *strokeColor = [UIColor colorWithHue:0.557 saturation:0.55 brightness:0.96 alpha:1.0];
	UIColor *strokeColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

	tempLayer.strokeColor = strokeColor.CGColor;
	tempLayer.lineWidth = 3.0;
	tempLayer.fillRule = kCAFillRuleNonZero;
    
    CGPoint center = self.view.center;
    [tempLayer setAnchorPoint:CGPointMake(center.x , center.y + 100)];
    [rootLayer addSublayer:tempLayer];
    CAAnimationGroup *group = [animations objectAtIndex:atIndex];
    NSString *key = [[NSString alloc] initWithFormat:@"allMyAnimations%i", atIndex];
    [tempLayer addAnimation:group forKey: key];
    NSLog(@"Finished adding animation group #%i", atIndex);

}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
	
}


- (void)dealloc 
{
    [super dealloc];
}

@end
