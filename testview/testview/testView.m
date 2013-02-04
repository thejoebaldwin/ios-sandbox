//
//  testView.m
//  testview
//
//  Created by Joseph on 2/4/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "testView.h"

@implementation testView




- (void) drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2;
    center.y = bounds.origin.y + bounds.size.height / 2;
    
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 4.0;
    
    CGContextSetLineWidth(ctx, 1.2);
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
    CGContextAddArc(ctx, center.x, center.y, maxRadius, 0, M_PI * 2.0, YES);
    CGContextStrokePath(ctx);
    
}


@end
