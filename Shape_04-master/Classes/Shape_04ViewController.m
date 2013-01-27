//
//  Shape_04ViewController.m
//  Shape_04
//
//  Created by test on 9/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Shape_04ViewController.h"

#import "clearView.h"

#import "AnimationWrapper.h"

@implementation Shape_04ViewController

- (id)init
{
    self = [super init];
    if (self){
        currentAnimationIndex = 0;
    }
    return self;
}


- (void) clearAll
{
    
    if ([[rootLayer sublayers] count] > 0)  {
    
        for (int i = [[rootLayer sublayers] count] - 1; i >= 0 ; i-- ) {
            [[[rootLayer sublayers] objectAtIndex: i] removeFromSuperlayer];
        }
    }
    
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *t = [touches anyObject];
    orgLastTouch = [t locationInView:self.view];
    animationTimeOffset = 0;
    
    [self createAnimations];
    [self nextAnimation];
    
    [[self nextResponder] touchesBegan:touches withEvent:event];
    
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
       [[self nextResponder] touchesMoved:touches withEvent:event];  
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self clearAll];
   [[self nextResponder] touchesEnded:touches withEvent:event];    
}



- (void) ball:(float)angle withTranslateX:(float)translateX withTranslateY:(float)translateY withScaleX:(float)scaleX withScaleY:(float)scaleY withFillColor:(UIColor *) fillColor withStrokeColor:(UIColor *) strokeColor withLineWidth:(CGFloat) lineWidth withPosition:(CGPoint) position withOffset:(int) offset
{
    CGPoint center = position;
    center = CGPointMake(0, 0);
    
    angle = 0;
    
    float bottomWidth = 5.0;
    float topWidth = bottomWidth/ 2;
    float initialHeight = 5.0;
    
   
    
    CGAffineTransform m = CGAffineTransformIdentity;
    
    //Initial Shape State for animation
    CGPoint topLeft = CGPointMake(center.x - topWidth, center.y - initialHeight);
    CGPoint topRight = CGPointMake(center.x + topWidth, center.y - initialHeight);
    CGPoint bottomRight = CGPointMake(center.x + topWidth, center.y + initialHeight);
    CGPoint bottomLeft = CGPointMake(center.x - topWidth, center.y + initialHeight);
	
	CGMutablePathRef drawStartPath = CGPathCreateMutable();
    CGPathMoveToPoint(drawStartPath, &m, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(drawStartPath, &m, topRight.x, topRight.y);
    CGPathAddLineToPoint(drawStartPath, &m, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(drawStartPath, &m, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(drawStartPath);
	
    
     
    CABasicAnimation *tempAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    
    //tempAnimation1.duration = animationDuration + 2 * offset;
    //tempAnimation1.beginTime = offset;
    tempAnimation1.removedOnCompletion = NO;
	tempAnimation1.fillMode = kCAFillModeForwards;
    tempAnimation1.fromValue = (id)drawStartPath;
	tempAnimation1.toValue = (id)drawStartPath;
    
      
    CABasicAnimation *translateAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    [translateAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(position.x + translateX , position.y + translateY )]];
    [translateAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(position.x, position.y )]];
    //translateAnim.beginTime = offset;
    translateAnim.removedOnCompletion = NO;
	translateAnim.fillMode = kCAFillModeForwards;
        //translateAnim.duration = animationDuration + offset;



    
    
  
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.autoreverses = NO; 
   group.duration = animationDuration + offset;
   group.beginTime = offset;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.repeatCount = HUGE_VALF;
    group.animations = [NSArray arrayWithObjects:tempAnimation1, translateAnim, nil];
    
    NSLog(@"adding animation # %i with a begin time of %f and a length of %f", 0, animationTimeOffset, animationDuration );
    animationTimeOffset += animationDuration;
    
    AnimationWrapper *tempWrapper = [[AnimationWrapper alloc] init];
    [tempWrapper setFillColor:fillColor];
    [tempWrapper setStrokeColor:strokeColor];
    [tempWrapper setLineWidth:lineWidth];
    [tempWrapper setScale:scaleX withY:scaleY];
    
    [tempWrapper setAnimations:group];
    [tempWrapper setLocation:CGPointMake(translateX, translateY)];
    [tempWrapper setAngle:angle];
    
    
    [smartAnimations addObject:tempWrapper];
    
}


- (void) setupBranchWithAngle:(float)angle withTranslateX:(float)translateX withTranslateY:(float)translateY withScaleX:(float)scaleX withScaleY:(float)scaleY withFillColor:(UIColor *) fillColor withStrokeColor:(UIColor *) strokeColor withLineWidth:(CGFloat) lineWidth withPosition:(CGPoint) position
{
    CGPoint center = position;
    
    
    //angle = 0;
    
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
	
	CGMutablePathRef drawStartPath = CGPathCreateMutable();
    CGPathMoveToPoint(drawStartPath, &m, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(drawStartPath, &m, topRight.x, topRight.y);
    CGPathAddLineToPoint(drawStartPath, &m, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(drawStartPath, &m, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(drawStartPath);
	
    
    //Ending Shape State for animation
    topLeft.x -= topWidth / 2 * topGrow;
    topLeft.y -= initialHeight * heightGrow;
    topRight.x += topWidth / 2 * topGrow;
    topRight.y -= initialHeight * heightGrow;
    bottomRight.x += bottomWidth / 2 * bottomGrow;
    bottomLeft.x -= bottomWidth / 2 * bottomGrow;
    
 	CGMutablePathRef drawEndPath = CGPathCreateMutable();
    CGPathMoveToPoint(drawEndPath, &m, topLeft.x, topLeft.y);
    CGPathAddLineToPoint(drawEndPath, &m, topRight.x, topRight.y);
    CGPathAddLineToPoint(drawEndPath, &m, bottomRight.x, bottomRight.y);
    CGPathAddLineToPoint(drawEndPath, &m, bottomLeft.x, bottomLeft.y);
    CGPathCloseSubpath(drawEndPath);
    
    //Build animation
    CABasicAnimation *tempAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];

    tempAnimation1.duration = animationDuration;
    tempAnimation1.beginTime = animationTimeOffset;
    tempAnimation1.removedOnCompletion = NO;
	tempAnimation1.fillMode = kCAFillModeForwards;
    tempAnimation1.fromValue = (id)drawStartPath;
	tempAnimation1.toValue = (id)drawEndPath;
    
    
    CABasicAnimation *rotateAnim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.beginTime = animationTimeOffset;
    rotateAnim.fromValue=[NSNumber numberWithDouble:angle];
    rotateAnim.toValue=[NSNumber numberWithDouble:angle];

    CABasicAnimation *translateAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    [translateAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(topRight.x, topRight.y )]];
    [translateAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(topRight.x, topRight.y)]];


    
    CABasicAnimation *translateAnimX = [CABasicAnimation animationWithKeyPath:@"position.x"];
    translateAnimX.beginTime = animationTimeOffset;
    translateAnimX.fromValue=[NSNumber numberWithDouble:0];
    translateAnimX.toValue=[NSNumber numberWithDouble:translateX];

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.autoreverses = NO;
    group.duration = animationDuration + animationTimeOffset;
    
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = [NSArray arrayWithObjects:rotateAnim,tempAnimation1, translateAnim, nil];
 
    NSLog(@"adding animation # %i with a begin time of %f and a length of %f", 0, animationTimeOffset, animationDuration );
       animationTimeOffset += animationDuration;
   // [animations addObject:group];
    
    AnimationWrapper *tempWrapper = [[AnimationWrapper alloc] init];
    
    
    

    
    [tempWrapper setFillColor:fillColor];
    [tempWrapper setStrokeColor:strokeColor];
    [tempWrapper setLineWidth:lineWidth];
    [tempWrapper setScale:scaleX withY:scaleY];
    
    [tempWrapper setAnimations:group];
    [tempWrapper setLocation:CGPointMake(translateX, translateY)];
    [tempWrapper setAngle:angle];
    
    
    [smartAnimations addObject:tempWrapper];
    
}


- (IBAction) clearButtonClick
{
    NSLog(@"yup");
    
    
    [self clearAll];
}

- (void)loadView 
{
	
    animationDuration = 1.0;
    animationTimeOffset = 0;

    UIView *behindView = [[[NSBundle mainBundle] loadNibNamed:@"behindView" owner:self options:nil ] lastObject];
    behindView.backgroundColor = [UIColor clearColor];
    
    
	clearView *appView = [[clearView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	appView.backgroundColor = [UIColor blackColor];
	self.view = appView;
	
    [[self view] addSubview:behindView];
    
    [appView release];
	
	rootLayer	= [CALayer layer];
	rootLayer.frame = self.view.bounds;
	[self.view.layer addSublayer:rootLayer];

     smartAnimations = [[NSMutableArray alloc] init];

}

-(void) createAnimations
{
    CGFloat angle = M_PI * -5 / 180.0;
    [smartAnimations removeAllObjects];
    
    UIColor *fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    UIColor *strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    CGFloat radius = 0;
    int totalBalls = 50;
    
    /*
    for(int i=0;  i < totalBalls; i++)
    {
        radius = rand() % 200 + 100;
        int theta = rand() % 360;
        CGFloat x = 0 + radius * cos(theta);
        CGFloat y = 0 - radius * sin(theta);   
        int offset = (rand() % 10) / 5.0;
        //TODO: random duration
        [self ball:-angle withTranslateX:x withTranslateY:y withScaleX:1.0 withScaleY:1.0f withFillColor:fillColor withStrokeColor:strokeColor withLineWidth:3.0 withPosition:orgLastTouch withOffset:offset];
    }
     */
    [self setupBranchWithAngle:angle withTranslateX:0 withTranslateY:0 withScaleX:1 withScaleY:1 withFillColor:fillColor withStrokeColor:strokeColor withLineWidth:3.0 withPosition:orgLastTouch];
    fillColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    [self setupBranchWithAngle:angle + 30 withTranslateX:0 withTranslateY:0 withScaleX:1 withScaleY:1 withFillColor:fillColor withStrokeColor:strokeColor withLineWidth:3.0 withPosition:orgLastTouch];
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
    for (int i = 0; i < [smartAnimations count]; i++) {
        
        [self startAnimation:i];
       
    }

}

-(void)startAnimation:(int)atIndex
{
    lastTouch = orgLastTouch;
    
    //offset from window size(?)
    lastTouch.x -= 150;
    lastTouch.y -= 250;
    
    AnimationWrapper *tempWrapper = [smartAnimations objectAtIndex:atIndex];
    [tempWrapper addAnimationGroupLayers:lastTouch];
    
    for (int i = 0; i < [[tempWrapper Layers] count]; i++)
    {
        [rootLayer addSublayer:[[tempWrapper Layers] objectAtIndex:i]];
    }
    
    NSLog(@"Finished starting animation group #%i", atIndex);
    
}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
	
}


- (void)dealloc 
{
    [mainButton release];
    [clearButton release];
    [super dealloc];
}

@end
