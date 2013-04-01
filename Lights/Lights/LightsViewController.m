//
//  LightsViewController.m
//  Lights
//
//  Created by Joseph Baldwin on 4/1/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "LightsViewController.h"

#import <CommonCrypto/CommonHMAC.h>

@interface LightsViewController ()

@end

@implementation LightsViewController

@synthesize OnSLider, OnSwitch, SliderLabel;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _key = @"0d2c1fbc6feba8293955c34213448326";
        _secret = @"d7ed7e8dfb3dd6619fcb7dcdd096cd89";
        
    }
    
    return self;
}

- (NSString*)MD5:(NSString *) text
{
    // Create pointer to the string as UTF8
    const char *ptr = [text UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

-(NSString *)getUTCTrim
{
    float seconds = [[NSDate date] timeIntervalSince1970];
    int FloorSeconds = (int) floor(seconds);
    FloorSeconds = FloorSeconds / 1000;
    NSString *t =  [NSString stringWithFormat:@"%i", FloorSeconds ];
    return t;
}

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

    //secret + timestamp / 100 --> MD5s
    
    NSString *TimeStamp = [self getUTCTrim];
    NSLog(@"Timestamp:%@", TimeStamp);
    NSString *signature = [NSString stringWithFormat:@"%@&%@&%@", _key, _secret,  TimeStamp];
    
    
    
    signature = [self MD5:signature];
    
      NSLog(@"Signature:%@", signature);
    
    NSString *postJSON =  [NSString stringWithFormat: @"{\"light\":   { \"id\": \"%i\", \"state\":\"%i\", \"signature\":\"%@\", \"key\":\"%@\", \"timestamp\":\"%@\" } }", value, onValue, signature, _key, TimeStamp];
    //postJSON = @"";
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
    
    [self postDataWithUrl:@"http://192.168.1.101/json.php"];

    
}

- (IBAction)ClearButtonClick:(id)sender {
    
 
    
}

- (IBAction)SliderChanged:(id)sender {
    
    
    int value = [OnSLider value];
    
    
    [SliderLabel setText: [NSString stringWithFormat:@"%i", value]];
    
    BOOL isOn = [OnSwitch isOn];
    
    
    
    
}
@end
