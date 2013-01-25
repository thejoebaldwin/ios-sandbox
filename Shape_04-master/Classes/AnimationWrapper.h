//
//  AnimationWrapper.h
//  Shape_04
//
//  Created by Joseph Baldwin on 1/25/13.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AnimationWrapper : NSObject
{
    CGPoint _location;
    CGFloat _angle;
}

@property (assign, nonatomic) CAAnimationGroup *animations;
@property (assign, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) UIColor *strokeColor;

-(void) setLocation: (CGPoint) withPoint;
-(void) setAngle: (CGFloat) withAngle;
-(CGPoint) Location;
-(CGFloat) Angle;
@end
