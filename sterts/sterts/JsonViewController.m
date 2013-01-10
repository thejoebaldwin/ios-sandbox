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
        [self fetchEntries];
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
   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
  [hitpointSlider setValue:[json[@"stats"][0][@"hitpoints"]  floatValue ]];
  [manaSlider setValue:[json[@"stats"][0][@"mana"]  floatValue ]];
    
  [hitpointLabel setText: json[@"stats"][0][@"hitpoints"]];
  [manaLabel setText:  json[@"stats"][0][@"mana"] ];
     
}

- (void) fetchEntries
{
    // Create a new data container for the stuff that comes back from the service
    jsonData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: @"http://sterts.humboldttechgroup.com/web/app_dev.php/json/test"];
    
    //Put the URL into an NSUrlRequest
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}

@end 
