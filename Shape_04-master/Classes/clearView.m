//
//  clearView.m
//  Shape_04
//
//  Created by Joseph Baldwin on 1/20/13.
//
//

#import "clearView.h"

@implementation clearView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
 
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
    }
}
 */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
