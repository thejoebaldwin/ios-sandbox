//
//  AnimationWrapper.m
//  Shape_04
//
//  Created by Joseph Baldwin on 1/25/13.
//
//

#import "AnimationWrapper.h"

@implementation AnimationWrapper


- (void) setAngle:(CGFloat)withAngle
{
    _angle = withAngle;
}

- (void) setLocation:(CGPoint)withPoint
{
    _location = withPoint;
    
}


- (CGPoint) Location
{
    return _location;
}

- (CGFloat) Angle
{
    return _angle;
}



@end
