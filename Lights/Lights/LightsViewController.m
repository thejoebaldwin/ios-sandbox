//
//  LightsViewController.m
//  Lights
//
//  Created by Joseph Baldwin on 4/1/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "LightsViewController.h"

@interface LightsViewController ()

@end

@implementation LightsViewController

@synthesize OnSLider, OnSwitch, SliderLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method will be called several times as the data arrives
- (void) connection:(NSURLConnection *) conn didReceiveData:(NSData *)data
{
    // Add the incoming chunk of data to the container we are keeping
    // the data always comes int he correct order
    [_httpData appendData:data];
}


- (void) connection: (NSURLConnection *) conn
   didFailWithError:(NSError *)error
{
    // Release the connection object, we're done with it
    _httpData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}


- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSString *response = [[NSString alloc] initWithData:_httpData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", response);
    
}

- (void) postDataWithUrl:(NSString *) urlString
{
    // Create a new data container for the stuff that comes back from the service
    _httpData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    int value = [OnSLider value];
    
    
       
    BOOL isOn = [OnSwitch isOn];

    int onValue = 0;
    if (isOn) onValue = 1;

    
    NSString *postJSON =  [NSString stringWithFormat: @"{\"lights\":   { \"id\": \"%i\", \"state\":\"%i\" } }", value, onValue];
    
     //  NSString *postBody  = [NSString stringWithFormat:@"status=%@", [Helper bodyEncode:status]];
    
    NSData* postData=[postJSON dataUsingEncoding:NSUTF8StringEncoding];
        
   [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
   [request setHTTPBody: postData];
    
    //add the authorization header
   // [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    
    //start the http request
    _connection = [[NSURLConnection alloc] initWithRequest:request
                                                  delegate:self
                                          startImmediately:YES];
}








- (IBAction)PostButtonClick:(id)sender {
    
    [self postDataWithUrl:@"http://192.168.1.84/json.php"];

    
}

- (IBAction)ClearButtonClick:(id)sender {
    
 
    
}

- (IBAction)SliderChanged:(id)sender {
    
    
    int value = [OnSLider value];
    
    
    [SliderLabel setText: [NSString stringWithFormat:@"%i", value]];
    
    BOOL isOn = [OnSwitch isOn];
    
    
    
    
}
@end
