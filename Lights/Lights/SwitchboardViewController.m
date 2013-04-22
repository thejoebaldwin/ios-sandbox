//
//  SwitchboardViewController.m
//  Lights
//
//  Created by Joseph Baldwin on 4/6/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "SwitchboardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AddressViewController.h"
@interface SwitchboardViewController ()

@end

@implementation SwitchboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Switchboard"];
        colors = [NSArray arrayWithObjects:[UIColor redColor],
                  [UIColor grayColor],
                  [UIColor greenColor],
                  [UIColor yellowColor],
                  [UIColor blueColor],
                  [UIColor purpleColor],
                  nil];
        
        LIGHTS_CONTROL_POST = @"http://192.168.1.86:8124?cmd=control";
        LIGHTS_LOOP_POST = @"http://192.168.1.86:8124?cmd=loop";
        
    }
    return self;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    
    //CGPoint p = [[touches anyObject] locationInView:self.view];
   
    
    float modifier = 1.0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
    } else {
        modifier = 2.0;
        //radius *= modifier;
    }
    
    
    NSMutableString *lightsJSON = [[NSMutableString alloc] init];
    
   for (UITouch *touch in [event allTouches]) {
       CGPoint p = [touch locationInView:self.view];
       
       
       for (CAShapeLayer *l in self.view.layer.sublayers)
       {
        
           
           //TODO: build array of touches, then use that for JSON array in single request.
           
           if ([l isKindOfClass:[CAShapeLayer class]]) {
               
               CGAffineTransform transf = CGAffineTransformMakeTranslation(-l.position.x, -l.position.y);
               
               if(CGPathContainsPoint(l.path, &transf, p, NO)){
                   
                   if (l.lineWidth == 8 * modifier)
                   {
                       l.lineWidth = 5;
                       l.strokeColor = [UIColor blackColor].CGColor;
                       l.shadowOpacity = 0.0;
                       if (![lightsJSON isEqualToString:@""])
                       {
                           [lightsJSON appendString:@","];
                       }
                       [lightsJSON appendString:[self lightControlItemJSON:l.name withState:@"off"]];
                       
                   }
                   else
                   {
                       l.lineWidth = 8 * modifier;
                       l.strokeColor = l.fillColor;
                       l.shadowColor = l.strokeColor;
                       l.shadowRadius = 5 * modifier;
                       l.shadowOffset = CGSizeMake(1.5f, 1.5f);
                       l.shadowOpacity = 1.0;
                       if (![lightsJSON isEqualToString:@""])
                       {
                           [lightsJSON appendString:@","];
                       }
                       [lightsJSON appendString:[self lightControlItemJSON:l.name withState:@"on"]];
                       
                   }
                   
               }
           }
           
                                         
           
       }

       
       
   }
    
    if (![lightsJSON isEqualToString:@""])
    {
        NSString *postBody = [self lightControlJSON:lightsJSON];
        [self postDataWithUrl:LIGHTS_CONTROL_POST withPostBody:postBody];
    }
   
    
    
    
}


-(NSString *)getUTCTrim
{
    float seconds = [[NSDate date] timeIntervalSince1970];
    int FloorSeconds = (int) floor(seconds);
    FloorSeconds = FloorSeconds / 1000;
    NSString *t =  [NSString stringWithFormat:@"%i", FloorSeconds ];
    return t;
}

-(NSString *) lightControlJSON:(NSString *) lightsJSON
{
    NSMutableString *json = [[NSMutableString alloc] init];
    NSString *timestamp = [self getUTCTrim];
    [json appendFormat:@" { \"lights\":[%@],", lightsJSON];
    [json appendFormat:@"    \"timestamp\": \"%@\", ", timestamp ];
    [json appendString:@"    \"mode\": \"control\" }" ];
    return json;
}


-(NSString *) lightControlItemJSON:(NSString *) lightId withState:(NSString *) state
{
    NSMutableString *json = [[NSMutableString alloc] init];
    [json appendFormat:@" { \"id\": \"%@\",", lightId];
    [json appendFormat:@"  \"state\": \"%@\"}", state];
    return json;
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
        //[CurrentLabel setText:json[@"pin"]];
    }
    //  NSString *operation = json[@"response"][@"operation"];
    
    
    
}

- (void) connection:(NSURLConnection *) conn didReceiveData:(NSData *)data
{
    NSLog(@"Appending data");
    
    [_httpData appendData:data];
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



-(CAShapeLayer *) NewLineLayer:(CGPoint) p withColor:(UIColor *) c withName:(NSString *) n
{
    
      
    CAShapeLayer *line = [CAShapeLayer layer];
    
    
    
    
    // Make a circular shape
    //line.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius * modifier, 2.0*radius * modifier)
                                   //          cornerRadius:radius  * modifier].CGPath;
    
UIBezierPath *path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(700    , 700)];
    [path closePath];
    // Center the shape in self.view
    line.position = p;
    // Configure the apperence of the circle
    line.fillColor = c.CGColor;
    line.strokeColor =  [UIColor blackColor].CGColor;
    ;
    
    line.lineWidth = 5;
    
    line.name = n;
    line.path = [path CGPath];
    return line;
}



-(CAShapeLayer *) NewCircleLayer:(CGPoint) p withColor:(UIColor *) c withName:(NSString *) n
{
    
    int radius = 15;
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

    return circle;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self view] setMultipleTouchEnabled:YES];
    
    int radius = 75;
    
    for (int i = 0; i < 15; i++)
    {
        float modifier = 1.0;
        float y_offset = 200;
            modifier = 2.0;
            //radius *= modifier;
            y_offset = 330;
        CGPoint p = CGPointMake(CGRectGetMidX(self.view.frame)-radius * modifier + ((i % 2  * 0) * 33 * modifier),
                                CGRectGetMidY(self.view.frame)-radius * modifier + (i * 27  * modifier * 1.14) - y_offset);
        [self.view.layer addSublayer:[self NewCircleLayer:p withColor:[colors objectAtIndex:i % 6] withName: [NSString stringWithFormat: @"%i", i]]];
        
      
    }
    
    //[self.view.layer addSublayer:[self NewLineLayer:CGPointMake(50,50) withColor:[colors objectAtIndex:0] withName:@"blarg"]];

    
    AddressViewController *address = [[AddressViewController alloc] init];
    //_LightsAddress   = @"192.168.1.84";
    _LightsAddress    = [[NSMutableString alloc] initWithString:@"192.168.1.84"];
    [address SetLightsAddress:_LightsAddress];
    
    //UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:address];
    
    //[self presentViewController:navController animated:YES completion:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) tickRacerMethod
{
    NSLog(@"Logging Timer Here");
    
    NSMutableString *lightsJSON = [[NSMutableString alloc] init];
    if (_lightIndex > 0)
    {
        NSString *currentIndex = [NSString stringWithFormat:@"%i", _lightIndex];
        [lightsJSON appendString:[self lightControlItemJSON:currentIndex withState:@"off"]];
        [self toggleLight:NO withIndex:_lightIndex];
    }
    NSString *nextIndex = [NSString stringWithFormat:@"%i", _lightIndex + 1];
    if (_lightIndex + 1 < 16)
    {
        [lightsJSON appendString:@","];
        [lightsJSON appendString:[self lightControlItemJSON:nextIndex withState:@"on"]];
        [self toggleLight:YES withIndex:_lightIndex + 1];

        _lightIndex++;
    }
    else
    {
        [lightsJSON appendString:@","];

        _lightIndex = 1;
        [lightsJSON appendString:[self lightControlItemJSON:@"1 " withState:@"on"]];
          [self toggleLight:YES withIndex:_lightIndex];
    }
    
    
    
    
    
    NSString *postBody = [self lightControlJSON:lightsJSON];
    [self postDataWithUrl:LIGHTS_CONTROL_POST withPostBody:postBody];
    
    
}


-(void) tickRandomMethod
{
    NSLog(@"Logging Timer Here");
    
    NSMutableString *lightsJSON = [[NSMutableString alloc] init];
    
    int randomOn = arc4random() % 15 + 1;
    int randomOff = arc4random() % 15 + 1;
    
    [lightsJSON appendString:[self lightControlItemJSON:[NSString stringWithFormat:@"%i", randomOn] withState:@"on"]];
    [self toggleLight:YES withIndex:randomOn];
    [lightsJSON appendString:[self lightControlItemJSON:[NSString stringWithFormat:@"%i", randomOff] withState:@"off"]];
    [self toggleLight:NO withIndex:randomOff];
    
    NSString *postBody = [self lightControlJSON:lightsJSON];
    [self postDataWithUrl:LIGHTS_CONTROL_POST withPostBody:postBody];

    
}


-(void) toggleLight:(BOOL) isOn withIndex:(int) i
{
    
    float modifier = 2.0;
    int index = 1;
    for (CAShapeLayer *l in self.view.layer.sublayers)
    {
        //TODO: build array of touches, then use that for JSON array in single request.
        
        if ([l isKindOfClass:[CAShapeLayer class]]) {
            
            if (index == i)
            {

                if (!isOn)
                {
                    l.lineWidth = 5;
                    l.strokeColor = [UIColor blackColor].CGColor;
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
              index++;
            }
      
    
    }
    
    
}

- (IBAction)StopButtonClick:(id)sender {
    
    [_timer invalidate];
    _timer = nil;
}

- (IBAction)LoopButtonClick:(id)sender {
    
    _lightIndex = 0;
  _timer =     [NSTimer scheduledTimerWithTimeInterval:0.15
                                     target:self
                                   selector:@selector(tickRacerMethod)
                                   userInfo:nil
                                    repeats:YES];
    //reset all lights to off, for when loop completes.
    for (CAShapeLayer *l in self.view.layer.sublayers)
    {
        if ([l isKindOfClass:[CAShapeLayer class]]) {
            l.lineWidth = 5;
            l.strokeColor = [UIColor blackColor].CGColor;
            l.shadowOpacity = 0.0;
            }
        }
}




- (IBAction)RedButtonClick:(id)sender {
    

    NSMutableString *lightsJSON = [[NSMutableString alloc] init];
    [lightsJSON appendString:[self lightControlItemJSON:@"0" withState:@"on"]];
    [lightsJSON appendString:@","];
    [lightsJSON appendString:[self lightControlItemJSON:@"6" withState:@"on"]];
    [lightsJSON appendString:@","];
    [lightsJSON appendString:[self lightControlItemJSON:@"12" withState:@"on"]];

    NSString *postBody = [self lightControlJSON:lightsJSON];
    [self postDataWithUrl:LIGHTS_CONTROL_POST withPostBody:postBody];
    
}
- (IBAction)RandomButtonClick:(id)sender {
    
    
    _lightIndex = 0;
    _timer =     [NSTimer scheduledTimerWithTimeInterval:0.15
                                                  target:self
                                                selector:@selector(tickRandomMethod)
                                                userInfo:nil
                                                 repeats:YES];
    //reset all lights to off, for when loop completes.
    for (CAShapeLayer *l in self.view.layer.sublayers)
    {
        if ([l isKindOfClass:[CAShapeLayer class]]) {
            l.lineWidth = 5;
            l.strokeColor = [UIColor blackColor].CGColor;
            l.shadowOpacity = 0.0;
        }
    }
    
}
@end
