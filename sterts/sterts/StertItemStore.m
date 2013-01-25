//
//  StertItemStore.m
//  sterts
//
//  Created by Joseph Baldwin on 1/24/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "StertItemStore.h"
#import "StertItem.h"

@implementation StertItemStore




- (id) init
{
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
        allStertsURL =  @"http://sterts.humboldttechgroup.com/web/app_dev.php/json/test";
        postStertURL = @"http://sterts.humboldttechgroup.com/web/app_dev.php/dump";

    }
    return self;
}

- (NSMutableArray *) allItems
{
    return allItems;
    
}


-(StertItem *) createItem
{
    StertItem *s = [[StertItem alloc] init];
    [allItems addObject:s];
    return s;
}


- (void) addItems:(StertItem *) addItem
{
    [allItems addObject:addItem];
}

+(StertItemStore *) sharedStore
{
    static StertItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
    
}


+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
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
    
    if ([json objectForKey:@"sterts"]){
        [allItems removeAllObjects];
        
        NSLog(@"Sterts JSON");
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        for (int i = 0; i < [json[@"sterts"] count]; i++ )
        {
            StertItem *tempStertItem = [[StertItem alloc] init];
            [tempStertItem setHitpoints:[json[@"sterts"][i][@"hitpoints"]  intValue ]];
            [tempStertItem setMana:[json[@"sterts"][i][@"mana"]  intValue ]];
            [tempStertItem setCreated:[dateFormatter dateFromString: [NSString stringWithFormat:@"%@", json[@"sterts"][i][@"created"] ] ]];
            //display the most recent stert
            if (i == 0) {
                
                NSLog(@"%@", tempStertItem);
                
            }
            [allItems addObject:tempStertItem];
            
            [[StertItemStore sharedStore] addItems:tempStertItem];
            
        }
        [owner performSelector:NSSelectorFromString(loadCompleteSelector)];

    } else {
        NSLog(@"Status JSON");
        
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                     message:@"Your stats have been updated."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
    
       
   //  [owner performSelector:@selector(loadCall)];
}

- (void) addItemWithHitpoints:(int) hitpoints withMana:(int) mana
{
    NSString* JSON = [[NSString alloc] initWithFormat: @"{\"stert\":{ \"hitpoints\":\"%d\", \"mana\":\"%d\" }}", hitpoints, mana];
    [self postDataWithUrl:postStertURL withJSON:JSON];
}

-(void) loadWithOwner:(UIViewController *) withOwner withSelector:(NSString *) withSelector;
{
    owner = withOwner;
    loadCompleteSelector = withSelector;
    [self fetchEntries:allStertsURL];
}


- (void) postDataWithUrl:(NSString *) urlString withJSON: (NSString *) JSON;
{
    // Create a new data container for the stuff that comes back from the service
    jsonData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    //NSString* newData = [[NSString alloc] initWithFormat: @"{\"stert\":{ \"hitpoints\":\"%d\", \"mana\":\"%d\" }}", hitpoints, mana];
    
    NSData* postData=[JSON dataUsingEncoding:NSUTF8StringEncoding];
    
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




@end
