//
//  JsonViewController.m
//  sterts
//
//  Created by Joseph on 1/9/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "JsonViewController.h"
#import "openGLViewController.h"
#import "StertItem.h"

@implementation JsonViewController


@synthesize lastUpdatedLabel;

- (id) init
{
    self = [super init];
    allStertsURL =  @"http://sterts.humboldttechgroup.com/web/app_dev.php/json/test";
    postStertURL = @"http://sterts.humboldttechgroup.com/web/app_dev.php/dump";

    
    
    if (self) {
        [self fetchEntries:allStertsURL];
        
        
        UITabBarItem *tbi = [self tabBarItem];
        
        // Give it a label
        [tbi setTitle:@"Main"];
        
        // Crea a UIImage from a file
        // This will use Hypno@2x.png on retina display devices
       // UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        // Put that image on the tab bar item
       // [tbi setImage:i];

        
        
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
  NSLog(@"ReturnedData=%@", json);
  
  if ([json objectForKey:@"stats"]){
      NSLog(@"Sterts JSON");

      NSDateFormatter *df = [[NSDateFormatter alloc] init];
      [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
      
      for (int i = 0; i < [json[@"stats"] count]; i++ )
      {
          StertItem *tempStertItem = [[StertItem alloc] init];
          [tempStertItem setHitpoints:[json[@"stats"][0][@"hitpoints"]  intValue ]];
          [tempStertItem setMana:[json[@"stats"][0][@"mana"]  intValue ]];
          NSString *tempJSONCreated = [NSString stringWithFormat:@"%@", json[@"stats"][0][@"created"] ];
          [tempStertItem setCreated:[df dateFromString: tempJSONCreated ]];
          //use only most recent stert
          if (i == 0) {
              [hitpointSlider setValue:(float)[tempStertItem hitpoints]];
              [hitpointLabel setText: [NSString stringWithFormat:@"%i", [tempStertItem hitpoints]] ];
              
              [hitpointSlider setValue:(float)[tempStertItem mana]];
              [manaLabel setText: [NSString stringWithFormat:@"%i", [tempStertItem mana]] ];
              
              [lastUpdatedLabel setText:[NSString stringWithFormat:@"%@", [tempStertItem created]]];
          }
      }

  } else {
       NSLog(@"Status JSON");
      
      
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                   message:@"Your stats have been updated."
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
      [av show];

      
  }
}

- (void) postData:(NSString *) urlString
{
    // Create a new data container for the stuff that comes back from the service
    jsonData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    int hitpoints = [hitpointSlider value];
    int mana =[manaSlider value];
    
    NSString* newData = [[NSString alloc] initWithFormat: @"{\"stert\":{ \"hitpoints\":\"%d\", \"mana\":\"%d\" }}", hitpoints, mana];
    
    NSData* postData=[newData dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postData];
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:YES];
}


- (void) fetchEntries:(NSString *) urlString
{
    // Create a new data container for the stuff that comes back from the service
    jsonData = [[NSMutableData alloc] init];
    
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
    [self fetchEntries:allStertsURL];
}

- (IBAction)postButton:(id)sender
{
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Are you sure?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Submit"
                                  otherButtonTitles:nil];
    
    

    
    
       
    [actionSheet showInView:self.tabBarController.view];
    
}



- (void) actionSheet:(UIActionSheet *) actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
            [self postData:postStertURL];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cancelled"
                                                     message:@"Submission Cancelled"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];

    }
}


- (IBAction)updateHitpointsLabel:(id)sender
{
    [hitpointLabel setText:[[NSString alloc] initWithFormat:@"%i", (int)[hitpointSlider value ]]];
}

- (IBAction)updateManaLabel:(id)sender
{
     [manaLabel setText:[[NSString alloc] initWithFormat:@"%i", (int)[manaSlider value ]]];
}

- (IBAction)go3DView:(id)sender
{
    
    openGLViewController *ovc = [[openGLViewController alloc] init];
    
    [[self navigationController] pushViewController:ovc animated:YES];

}

@end 
