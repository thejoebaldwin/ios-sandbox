//
//  JsonViewController.m
//  sterts
//
//  Created by Joseph on 1/9/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "JsonViewController.h"

@implementation JsonViewController

- (id) init
{
    self = [super init];
    
    if (self) {
        //[self fetchEntries];
    }
    return self;
}

- (void) connection: (NSURLConnection *) conn
   didFailWithError:(NSError *)error
{
    // Release the connection object, we're done with it
    jsonData = nil;
    
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

// This method will be called several times as the data arrives
- (void) connection:(NSURLConnection *) conn didReceiveData:(NSData *)data
{
    // Add the incoming chunk of data to the container we are keeping
    // the data always comes int he correct order
    [jsonData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    
    
    NSLog(@"ReturnedData=%@", jsonData);
    
   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
  [hitpointSlider setValue:[json[@"stats"][0][@"hitpoints"]  floatValue ]];
  [manaSlider setValue:[json[@"stats"][0][@"mana"]  floatValue ]];
    
  [hitpointLabel setText: json[@"stats"][0][@"hitpoints"]];
  [manaLabel setText:  json[@"stats"][0][@"mana"] ];
    NSLog(@"ReturnedData=%@", json);

}

- (void) postData:(NSString *) urlString
{
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString* string= @"Some String";
    NSData* data=[string dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: data];
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:YES];
}


- (void) fetchEntries:(NSString *) urlString
{
    // Create a new data container for the stuff that comes back from the service
    jsonData = [[NSMutableData alloc] init];
    
    //NSURL *url = [NSURL URLWithString: @"http://sterts.humboldttechgroup.com/web/app_dev.php/json/test"];
    
    NSURL *url = [NSURL URLWithString: urlString];
    
    
    //Put the URL into an NSUrlRequest
    NSURLRequest *req = [NSURLRequest requestWithURL:url];

    
    
    
     
    
    
    
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}




- (IBAction)getButton:(id)sender
{
    [self fetchEntries:@"http://sterts.humboldttechgroup.com/web/app_dev.php/json/test"];
    
}

- (IBAction)postButton:(id)sender
{
    
    
    [self postData:@"http://sterts.humboldttechgroup.com/web/app_dev.php/dump"];

    
}


@end 
