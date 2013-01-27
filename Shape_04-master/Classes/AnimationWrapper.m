//
//  AnimationWrapper.m
//  Shape_04
//
//  Created by Joseph Baldwin on 1/25/13.
//
//

#import "AnimationWrapper.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimationWrapper

@synthesize StrokeColor, FillColor, Animations, Layers;


-(id) init
{
    self = [super init];
    if (self) {
        Layers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setAngle:(CGFloat)withAngle
{
    _angle = withAngle;
}

- (void) setLocation:(CGPoint)withPoint
{
    _location = withPoint;
    
}

- (void) setLineWidth:(CGFloat)withLineWidth
{
    _lineWidth = withLineWidth;
}

- (CGPoint) Location
{
    return _location;
}

- (CGFloat) Angle
{
    return _angle;
}

- (CGFloat) LineWidth
{
    return _lineWidth;
}

-(void) setScale:(CGFloat)scaleX withY:(CGFloat)scaleY
{
    _scaleX = scaleX;
    _scaleY = scaleY;
    }

- (CGFloat) ScaleX
{
    return _scaleX;
}

- (CGFloat) ScaleY
{
    return _scaleX;
}

-(void) addAnimationGroupLayers:(CGPoint) position
{

    CAShapeLayer *tempLayer = [CAShapeLayer layer];
    tempLayer.position = position;
    tempLayer.strokeColor = [self StrokeColor].CGColor;
    tempLayer.fillColor = [self FillColor].CGColor;
	tempLayer.lineWidth = [self LineWidth];
	tempLayer.fillRule = kCAFillRuleNonZero;
    
    //not sure if this will be needed. x/y coordinates get skewed when transforming
    //[tempLayer setTransform:CATransform3DMakeScale( [tempWrapper ScaleX], [tempWrapper ScaleY], 1.0 )];
    
    
    //SHOULD ANIMATION WRAPPER HAVE THE LAYER IN IT TOO??????
    CAAnimationGroup *group = [self Animations];
    NSString *key = [[NSString alloc] initWithFormat:@"allMyAnimations%i", 0];
    [tempLayer addAnimation:group forKey: key];
    
    //[rootLayer addSublayer:tempLayer];
    [Layers addObject:tempLayer];
    
    NSLog(@"Finished starting animation group #%i", 0);
    
}
@end
