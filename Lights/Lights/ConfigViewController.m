//
//  ConfigViewController.m
//  Lights
//
//  Created by Joseph on 4/2/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "ConfigViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Config"];
       colors = [NSArray arrayWithObjects:[UIColor redColor],
                [UIColor grayColor],
              [UIColor greenColor],
                 [UIColor yellowColor],
                 [UIColor blueColor],
                 [UIColor purpleColor],
               nil];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint p = [[touches anyObject] locationInView:self.view];
    
   /*
    for (NSString *string in myArray) {
        NSLog(@\"%@\",string);
              }
    
    if(CGPathContainsPoint(textLayer.path,nil, p, NO))
    {
        
        NSLog(@"touched");
        // the touch is inside the shape
    }   
    */
    float modifier = 1.0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
    } else {
        modifier = 2.0;
        //radius *= modifier;
    }
    

    
    for (CAShapeLayer *l in self.view.layer.sublayers)
    {
               
       if ([l isKindOfClass:[CAShapeLayer class]]) {
        
        CGAffineTransform transf = CGAffineTransformMakeTranslation(-l.position.x, -l.position.y);
        
        if(CGPathContainsPoint(l.path, &transf, p, NO)){
            
            // the touch is inside the shape
            NSLog(@"touched:%@", l.name);
            
            if (l.lineWidth == 8 * modifier)
            {
                l.lineWidth = 5;
                l.strokeColor = [UIColor blackColor].CGColor;
                //l.shadowColor = l.strokeColor;
                //l.shadowRadius = 30;
                //l.shadowOffset = CGSizeMake(1.5f, 1.5f);
                l.shadowOpacity = 0.0;

                
            }
            else
            {
                l.lineWidth = 8 * modifier;
                l.strokeColor = l.fillColor;
                l.shadowColor = l.strokeColor;
                l.shadowRadius = 5 * modifier;
                l.shadowOffset = CGSizeMake(1.5f, 1.5f);
                l.shadowOpacity = 1.0;

            }
            
                   }
       }

        

    }
    
    
   }
-(CAShapeLayer *) NewCircleLayer:(CGPoint) p withColor:(UIColor *) c withName:(NSString *) n
{
    
    int radius = 20;
    float modifier = 1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
    } else {
        modifier = 2.0;
        //radius *= modifier;
    }

    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    
  
    
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius * modifier, 2.0*radius * modifier)
                                             cornerRadius:radius  * modifier].CGPath;
    // Center the shape in self.view
    circle.position = p;
    // Configure the apperence of the circle
    circle.fillColor = c.CGColor;
    circle.strokeColor =  [UIColor blackColor].CGColor;
;

    circle.lineWidth = 5;
    
    circle.name = n;
    /*
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFont:@"Helvetica-Bold"];
    [label setFontSize:10];
    [label setFrame:[circle frame]];
    [label setString:  @"****************"];
    //[label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor blackColor] CGColor]];
    [label setPosition:CGPointMake(0.0f, 0.0f)];
    [circle addSublayer:label];
*/
      //[label release];
    
    return circle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    int radius = 75;
    
    for (int i = 0; i < 15; i++)
    {
        float modifier = 1.0;
        
        float y_offset = 200;

               
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        } else {
            modifier = 2.0;
            //radius *= modifier;
             y_offset = 100;

        }
                
        
        CGPoint p = CGPointMake(CGRectGetMidX(self.view.frame)-radius * modifier + ((i % 2  * modifier) * 33 * modifier),
                                CGRectGetMidY(self.view.frame)-radius * modifier + (i * 27  * modifier) - y_offset);
        [self.view.layer addSublayer:[self NewCircleLayer:p withColor:[colors objectAtIndex:i % 6] withName: [NSString stringWithFormat: @"%i", i + 1 ]]];
    
          
        CATextLayer *label = [[CATextLayer alloc] init];
        [label setFont:@"Helvetica-Bold"];
        [label setFontSize:10 * modifier];
        [label setFrame:[self.view.layer frame]];
        [label setString: [NSString stringWithFormat:  @"%i", i + 1]];
        [label setForegroundColor:[[UIColor blackColor] CGColor]];
        [label setPosition:CGPointMake(p.x + 174,p.y + 285)];
        [self.view.layer addSublayer:label];

    }
    
       
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
