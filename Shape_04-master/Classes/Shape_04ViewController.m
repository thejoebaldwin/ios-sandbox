//
//  Shape_04ViewController.m
//  Shape_04
//
//  Created by test on 9/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Shape_04ViewController.h"

@implementation Shape_04ViewController


- (void) setupBranch
{
    CGPoint center = self.view.center;
    //center.y;
	
	//Round Path
	
	    
	
    
    float bottomWidth = 5.0;
    float topWidth = bottomWidth/ 2;
    float initialHeight = 5.0;
    
    float topGrow = 3.5;
    float bottomGrow = 3.00;
    float heightGrow = 40.0;
    
    
    CGFloat angle = M_PI * -35 / 180.0;
    //angle = 0;
    CGAffineTransform rotate =  CGAffineTransformMakeRotation(angle);
    CGAffineTransform translate =  CGAffineTransformMakeTranslation(-150, -20);
    CGAffineTransform m = CGAffineTransformConcat(translate, rotate);
    //CGAffineTransform m = CGAff
    
    CGPoint topLeft = CGPointMake(center.x - topWidth, center.y - initialHeight);
    CGPoint topRight = CGPointMake(center.x + topWidth, center.y - initialHeight);
    CGPoint bottomRight = CGPointMake(center.x + bottomWidth, center.y + initialHeight);
    CGPoint bottomLeft = CGPointMake(center.x - bottomWidth, center.y + initialHeight);
	
	//Box Path
	
	CGMutablePathRef tempPath1 = CGPathCreateMutable();
  
    CGPathMoveToPoint(tempPath1, &m, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath1, &m, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath1, &m, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath1, &m, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath1);
	
    
    //Box Path 2
    topLeft.x -= topWidth * topGrow;
    topLeft.y -= initialHeight * heightGrow;
    
    topRight.x += topWidth * topGrow;
    topRight.y -= initialHeight * heightGrow;
	
    bottomRight.x += bottomWidth * bottomGrow;
    bottomLeft.x -= bottomWidth * bottomGrow;
    
    CGPathMoveToPoint(tempPath1, nil, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath1, nil, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath1, nil, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath1, nil, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath1);

    
    
    
 	CGMutablePathRef tempPath2 = CGPathCreateMutable();

    CGPathMoveToPoint(tempPath2, nil, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath2, nil, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath2, nil, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath2, nil, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath2);

    
    CGPathMoveToPoint(tempPath2, &m, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath2, &m, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath2, &m, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath2, &m, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath2);
    
    
    NSValue *value = [NSValue valueWithBytes:&tempPath1 objCType:@encode(CGMutablePathRef)];
    [paths addObject:value];
    value = [NSValue valueWithBytes:&tempPath2 objCType:@encode(CGMutablePathRef)];
    [paths addObject:value];
    

}


- (void) setupTrunk
{
    CGPoint center = self.view.center;
    center.y += 100;
	
	//Round Path
	/*
	roundPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(roundPath, nil, center.x , center.y - 75.0);
	CGPathAddArcToPoint(roundPath, nil, center.x + 75.0, center.y - 75.0, center.x + 75.0, center.y + 75.0, 75.0);
	CGPathAddArcToPoint(roundPath, nil, center.x + 75.0, center.y + 75.0, center.x - 75.0, center.y + 75.0, 75.0);
	CGPathAddArcToPoint(roundPath, nil, center.x - 75.0, center.y + 75.0, center.x - 75.0, center.y, 75.0);
	CGPathAddArcToPoint(roundPath, nil, center.x - 75.0, center.y - 75.0, center.x, center.y - 75.0, 75.0);
	
	CGPathCloseSubpath(roundPath);
    */
	
    
    float bottomWidth = 5.0;
    float topWidth = bottomWidth/ 2;
    float initialHeight = 5.0;
    
    float topGrow = 3.5;
    float bottomGrow = 3.00;
    float heightGrow = 40.0;
    
    
    
    CGPoint topLeft = CGPointMake(center.x - topWidth, center.y - initialHeight);
    CGPoint topRight = CGPointMake(center.x + topWidth, center.y - initialHeight);
    CGPoint bottomRight = CGPointMake(center.x + bottomWidth, center.y + initialHeight);
    CGPoint bottomLeft = CGPointMake(center.x - bottomWidth, center.y + initialHeight);
	
	//temp Path
	
    CGMutablePathRef tempPath1 = CGPathCreateMutable();
    CGPathMoveToPoint(tempPath1, nil, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath1, nil, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath1, nil, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath1, nil, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath1);
	
    
    //Temp Path 2
    topLeft.x -= topWidth * topGrow;
    topLeft.y -= initialHeight * heightGrow;
    
    topRight.x += topWidth * topGrow;
    topRight.y -= initialHeight * heightGrow;
	
    bottomRight.x += bottomWidth * bottomGrow;
    bottomLeft.x -= bottomWidth * bottomGrow;
    
 	 CGMutablePathRef tempPath2 = CGPathCreateMutable();
    
    
    
    CGPathMoveToPoint(tempPath2, nil, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath2, nil, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath2, nil, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath2, nil, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath2);
    //CGContextRotateCTM(tempPath2, 45);
    

    
    NSValue *value = [NSValue valueWithBytes:&tempPath1 objCType:@encode(CGMutablePathRef)];
    [paths addObject:value];
    value = [NSValue valueWithBytes:&tempPath2 objCType:@encode(CGMutablePathRef)];
    [paths addObject:value];    
    
    
}


- (void)loadView 
{
	
	UIView *appView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	appView.backgroundColor = [UIColor blackColor];
	
	self.view = appView;
	
	[appView release];
	
	rootLayer	= [CALayer layer];
	
	rootLayer.frame = self.view.bounds;
	
	[self.view.layer addSublayer:rootLayer];

    
    paths = [[NSMutableArray alloc] init];
    

	
	CGPoint center = self.view.center;
    center.y += 100;
	
	
    
    [self setupTrunk];
    [self setupBranch];

	//Create Shape
	
	shapeLayer = [CAShapeLayer layer];
	
    
    //CGMutablePathRef tempPath;
    // NSValue *value = [paths objectAtIndex:0];
    //[value getValue:&tempPath];

    
	//shapeLayer.path = tempPath;
	
	UIColor *fillColor = [UIColor colorWithHue:0.584 saturation:0.8 brightness:0.9 alpha:1.0];
	
	shapeLayer.fillColor = fillColor.CGColor; 
	
	UIColor *strokeColor = [UIColor colorWithHue:0.557 saturation:0.55 brightness:0.96 alpha:1.0];
	
	shapeLayer.strokeColor = strokeColor.CGColor;
	
	shapeLayer.lineWidth = 3.0;
	
	shapeLayer.fillRule = kCAFillRuleNonZero;
	
	[rootLayer addSublayer:shapeLayer];
	
	[self performSelector:@selector(trunkAnimation) withObject:nil afterDelay:0];

	
    
    
    
    
   // shapeLayer2.path = tempPath;
	
		
	shapeLayer2.fillColor = fillColor.CGColor;
	
		
	shapeLayer2.strokeColor = strokeColor.CGColor;
	
	shapeLayer2.lineWidth = 3.0;
	
	shapeLayer2.fillRule = kCAFillRuleNonZero;
	
	//[rootLayer addSublayer:shapeLayer2];
	
	//[self performSelector:@selector(branchAnimation) withObject:nil afterDelay:1.5];

    
    
}
 - (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"Finished %@ %d", anim, flag );
    if (!ranOnce) {
        [self branchAnimation];
    }
    ranOnce = YES;
    
    }


-(void) trunkAnimation
{
    [self startAnimation:0 toPathIndex:1];
    //[self branchAnimation];

}

-(void) branchAnimation
{
    [self startAnimation:2 toPathIndex:3];
    
}

-(void)startAnimation:(int)fromIndex toPathIndex: (int) toIndex
{
    
    
   
    
    
	CABasicAnimation *animation1;

    CABasicAnimation *animation2;
//if (!ranOnce) {
      animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
      animation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    //} else {
      //        animation = [CABasicAnimation animationWithKeyPath:@"path"];
    //}
    
	
    
   [animation1 setDelegate:self];
    
	animation1.duration = 2.0;
    
    [animation2 setDelegate:self];
    
	animation2.duration = 2.0;
	
	//animation.repeatCount = HUGE_VALF;
    //animation.repeatCount = 0;
	
	//animation.autoreverses = YES;
	animation1.removedOnCompletion = NO;
    animation2.removedOnCompletion = NO;
	//animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
    animation1.fillMode = kCAFillModeForwards;

    animation2.fillMode = kCAFillModeForwards;

    
    
    
    CGMutablePathRef tempPath1;
    NSValue *value = [paths objectAtIndex:fromIndex];
    [value getValue:&tempPath1];

    
    
    CGMutablePathRef tempPath3;
    value = [paths objectAtIndex:2];
    [value getValue:&tempPath3];
    
    CGMutablePathRef tempPath4;
    value = [paths objectAtIndex:3];
    [value getValue:&tempPath4];

    
    CGMutablePathRef tempPath2;
    value = [paths objectAtIndex:toIndex];
    [value getValue:&tempPath2];
   
    
	//animation.fromValue = (id)boxPath;
	
	//animation.toValue = (id)boxPath2;
	
    
    animation1.fromValue = (id)tempPath1;
	
	animation1.toValue = (id)tempPath2;
    
    
    animation2.fromValue = (id)tempPath3;
	
	animation2.toValue = (id)tempPath4;
	/*
    if (!ranOnce) {
        
        [shapeLayer addAnimation:animation forKey:@"path1"];
    } else {
        
        [shapeLayer2 addAnimation:animation forKey:@"path2"];
    }
   */
    
    
    
    CAAnimationGroup *anim = [CAAnimationGroup animation];
    [anim setAnimations:[NSArray arrayWithObjects:animation2, animation1, nil]];
    [anim setDuration:10.0];
    [anim setRemovedOnCompletion:NO];
    [anim setFillMode:kCAFillModeForwards];
    [shapeLayer addAnimation:animation1 forKey:nil];
}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
	
}


- (void)dealloc 
{
    [super dealloc];
}

@end
