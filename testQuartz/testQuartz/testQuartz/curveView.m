//
//  curveView.m
//  testQuartz
//
//  Created by Joseph on 1/16/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "curveView.h"

@implementation curveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.0];
    
    return self;
}



- (void) drawRect: (CGRect) dirtyRect
{
    [super drawRect:dirtyRect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGRect bounds = [self bounds];
    
    
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width/ 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The radius of the circle should be nearly as big as the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    //the thickness of the line should be 10 points wide
    CGContextSetLineWidth(ctx, 10);
    
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];
    
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
      
    // Draw the lines.
    //[aPath addLineToPoint:CGPointMake(200.0, 40.0)];
    
    
    //[aPath CGContextAddCurveToPoint(context, 0, 50, 300, 250, 300, 400)];
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(100.0, 100.0);
    CGPoint controlOne = CGPointMake(200.0, 40.0);
    CGPoint controlTwo = CGPointMake(200.0, 60.0);
    
    
    
    // Add a path to the context
    CGContextAddArc(ctx, controlOne.x, controlOne.y, 2.0, 0.0, M_PI * 2.0, YES);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx, controlTwo.x, controlTwo.y, 2.0, 0.0, M_PI * 2.0, YES);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx, start.x, start.y, 2.0, 0.0, M_PI * 2.0, YES);
    CGContextStrokePath(ctx);
    CGContextAddArc(ctx, end.x, end.y, 2.0, 0.0, M_PI * 2.0, YES);
    CGContextStrokePath(ctx);
    
    // Performs drawing instruction; removes path
    [aPath moveToPoint:start];
    [aPath addCurveToPoint:end controlPoint1:controlOne controlPoint2:controlTwo];
    //[aPath addLineToPoint:CGPointMake(160, 140)];
    //[aPath addLineToPoint:CGPointMake(40.0, 140)];
    //[aPath addLineToPoint:CGPointMake(0.0, 40.0)];
    //[aPath closePath];
    [aPath stroke];
    //[aPath fill];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
