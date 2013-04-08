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

@synthesize CurrentLabel;


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
        
        LIGHTS_CONFIG_POST = @"http://192.168.1.84:8124?cmd=config";
        
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
            //NSLog(@"touched:%@", l.name);
            
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
                
                
                NSString *postBody = [self lightConfigJSON:l.name];
                [self postDataWithUrl:LIGHTS_CONFIG_POST withPostBody:postBody];
                

            }
            
          }
       }

        

    }
 }



- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSString *response = [[NSString alloc] initWithData:_httpData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response:%@", response);
    
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_httpData options:kNilOptions error:nil];
    //NSLog(@"ReturnedData=%@", json);
    
    //if ([json objectForKey:@"response"]){
        
        //this is returned on item create
        NSLog(@"Response:%@", json);
    
    
    if ([json objectForKey:@"pin"]){
        
        //this is returned on item create
        //NSLog(@"response JSON");
       // NSString *operation = json[@"response"][@"operation"];
        [CurrentLabel setText:json[@"pin"]];
    }
      //  NSString *operation = json[@"response"][@"operation"];

    
    
}

- (void) connection:(NSURLConnection *) conn didReceiveData:(NSData *)data
{
    NSLog(@"Appending data");
    
    [_httpData appendData:data];
}


-(NSString *) startConfigJSON
{
    NSMutableString *json = [[NSMutableString alloc] init];
    [json appendString:@"{     \"mode\": \"start\" }" ];
    return json;
}


-(NSString *) lightConfigJSON:(NSString *) lightId
{
    NSMutableString *json = [[NSMutableString alloc] init];
    [json appendFormat:@" { \"id\": \"%@\",", lightId];
    [json appendString:@"     \"mode\": \"configure\" }" ];
    return json;
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
        [self.view.layer addSublayer:[self NewCircleLayer:p withColor:[colors objectAtIndex:i % 6] withName: [NSString stringWithFormat: @"%i", i]]];
    
          
        CATextLayer *label = [[CATextLayer alloc] init];
        [label setFont:@"Helvetica-Bold"];
        [label setFontSize:10 * modifier];
        [label setFrame:[self.view.layer frame]];
        [label setString: [NSString stringWithFormat:  @"%i", i]];
        [label setForegroundColor:[[UIColor blackColor] CGColor]];
        [label setPosition:CGPointMake(p.x + 174,p.y + 285)];
        [self.view.layer addSublayer:label];

    }
    //[self postDataWithUrl:LIGHTS_CONFIG_POST withPostBody:[self startConfigJSON]];

       
   }

- (void) postDataWithUrl:(NSString *) urlString withPostBody:(NSString *) postBody;
{
    _httpData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSData *postData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    NSLog(@"Post:%@", postBody);
    _connection  = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartButtonClick:(id)sender {
    
   

    for (CAShapeLayer *l in self.view.layer.sublayers)
    {
        
        if ([l isKindOfClass:[CAShapeLayer class]]) {
            
                    
                        
                               l.lineWidth = 5;
                    l.strokeColor = [UIColor blackColor].CGColor;
                    //l.shadowColor = l.strokeColor;
                    //l.shadowRadius = 30;
                    //l.shadowOffset = CGSizeMake(1.5f, 1.5f);
                    l.shadowOpacity = 0.0;
                    
                    
                              
            
        }
    }

    
    
    [self postDataWithUrl:LIGHTS_CONFIG_POST withPostBody:[self startConfigJSON]];
    
    
}

- (IBAction)NotUsedClick:(id)sender {
    
    NSString *postBody = [self lightConfigJSON:@"-1"];
    [self postDataWithUrl:LIGHTS_CONFIG_POST withPostBody:postBody];

    
}
@end
