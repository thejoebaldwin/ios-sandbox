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
    CGFloat _lineWidth;
    CGFloat _scaleX, _scaleY;
}

@property (nonatomic, retain) CAAnimationGroup *Animations;
@property (nonatomic, retain) UIColor *FillColor;
@property (nonatomic, retain) UIColor *StrokeColor;
@property (nonatomic, retain) NSMutableArray *Layers;

-(void) setLocation: (CGPoint) withPoint;
-(void) setAngle: (CGFloat) withAngle;
-(void) setLineWidth: (CGFloat) withLineWidth;
-(void) setScale:(CGFloat) scaleX withY:(CGFloat) scaleY;

-(CGPoint) Location;
-(CGFloat) Angle;
-(CGFloat) LineWidth;
-(CGFloat) ScaleX;
-(CGFloat) ScaleY;
-(void) addAnimationGroupLayers:(CGPoint) position;

@end
