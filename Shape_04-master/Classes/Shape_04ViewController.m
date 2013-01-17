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
    
 	CGMutablePathRef tempPath2 = CGPathCreateMutable();

    
    CGPathMoveToPoint(tempPath2, &m, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(tempPath2, &m, topRight.x, topRight.y);
    CGPathAddLineToPoint(tempPath2, &m, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(tempPath2, &m, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(tempPath2);
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation1 setDelegate:self];
    animation1.duration = 2.0;
    animation1.removedOnCompletion = NO;
	animation1.fillMode = kCAFillModeForwards;
    animation1.fromValue = (id)tempPath1;
	animation1.toValue = (id)tempPath2;
    
    [animations addObject:animation1];
}


- (void) setupTrunk
{
    CGPoint center = self.view.center;
    center.y += 100;
	
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

    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation1 setDelegate:self];
    animation1.duration = 2.0;
    animation1.removedOnCompletion = NO;
	animation1.fillMode = kCAFillModeForwards;    
    animation1.fromValue = (id)tempPath1;
	animation1.toValue = (id)tempPath2;
    
    [animations addObject:animation1];
 
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
    
    animations = [[NSMutableArray alloc] init];

	CGPoint center = self.view.center;
    center.y += 100;

    [self setupTrunk];
    [self setupBranch];

	//Create Shape
	
	[self trunkAnimation];	
    
    
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
    [self startAnimation:0];
}

-(void) branchAnimation
{
    [self startAnimation:1];
}

-(void)startAnimation:(int)atIndex
{
    CAShapeLayer *tempLayer = [CAShapeLayer layer];
	UIColor *fillColor = [UIColor colorWithHue:0.584 saturation:0.8 brightness:0.9 alpha:1.0];
	
	tempLayer.fillColor = fillColor.CGColor;
	
	UIColor *strokeColor = [UIColor colorWithHue:0.557 saturation:0.55 brightness:0.96 alpha:1.0];
	
	tempLayer.strokeColor = strokeColor.CGColor;
	
	tempLayer.lineWidth = 3.0;
	
	tempLayer.fillRule = kCAFillRuleNonZero;
	
	[rootLayer addSublayer:tempLayer];
    
    CAAnimation *tempAnimation =  [animations objectAtIndex:atIndex];
    [tempLayer addAnimation:tempAnimation forKey:nil];
}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
	
}


- (void)dealloc 
{
    [super dealloc];
}

@end
