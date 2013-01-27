//
//  StertItemStore.m
//  sterts
//
//  Created by Joseph Baldwin on 1/24/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "StertItemStore.h"
#import "StertItem.h"
#include <CommonCrypto/CommonDigest.h>

@implementation StertItemStore




- (id) init
{
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
        allStertsURL =  @"http://sterts.humboldttechgroup.com/web/app_dev.php/v1/get/sterts";
        postStertURL = @"http://sterts.humboldttechgroup.com/web/app_dev.php/v1/post";
        removeStertURL = @"http://sterts.humboldttechgroup.com/web/app_dev.php/v1/remove";
        authURL = @"http://sterts.humboldttechgroup.com/web/app_dev.php/v1/auth";
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

- (void) insertItem:(StertItem *) insertItem
{
    [allItems insertObject:insertItem atIndex:0];
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
            [tempStertItem setID:[json[@"sterts"][i][@"id"]  intValue ]];
            //display the most recent stert
            if (i == 0) {
                
                NSLog(@"%@", tempStertItem);
                
            }
            
            [[StertItemStore sharedStore] addItems:tempStertItem];
            

            
        }
        [owner performSelector:NSSelectorFromString(loadCompleteSelector)];

    } else if ([json objectForKey:@"auth"]){
        
        NSLog(@"%@", json[@"auth"][0][@"token"]);
        
    }else {
        //this is returned on item create
        NSLog(@"response JSON");
        
        
        NSLog(@"%@", json[@"response"][@"operation"] );
        
        if (   [json[@"response"][@"operation"]  isEqualToString: @"add"] ) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            StertItem *tempStertItem = [[StertItem alloc] init];
            [tempStertItem setHitpoints:[json[@"response"][@"hitpoints"]  intValue ]];
            [tempStertItem setMana:[json[@"response"][@"mana"]  intValue ]];
            [tempStertItem setCreated:[dateFormatter dateFromString: [NSString stringWithFormat:@"%@", json[@"response"][@"created"] ] ]];
            [tempStertItem setID:[json[@"response"][@"id"]  intValue ]];
            //display the most recent stert
            [[StertItemStore sharedStore] insertItem:tempStertItem];
            
            
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                         message:@"Your stats have been updated."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            
            
            [av show];
        }
        else if (  [json[@"response"][@"operation"]  isEqualToString: @"delete"]  ) {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                         message:@"Your stats have been deleted."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            
            
            [av show];

        }
        
        

    }
    
       
   //  [owner performSelector:@selector(loadCall)];
}



- (void) addItemWithHitpoints:(int) hitpoints withMana:(int) mana
{
    NSString* JSON = [[NSString alloc] initWithFormat: @"{\"stert\":{ \"hitpoints\":\"%d\", \"mana\":\"%d\" }}", hitpoints, mana];
    [self postDataWithUrl:postStertURL withJSON:JSON];
}

- (void) removeItem:(StertItem *)s
{
    
    NSString* JSON = [[NSString alloc] initWithFormat: @"{\"stert\":{ \"hitpoints\":\"%d\", \"mana\":\"%d\", \"id\":\"%i\" }}", [s hitpoints], [s mana], [s ID]];
    NSLog(@"%@", JSON);
    [allItems  removeObjectIdenticalTo:s];
    [self postDataWithUrl:removeStertURL withJSON:JSON];
    NSLog(@"This FAR");

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


- (NSString *) getAuthToken:(NSString *) username withPassword:(NSString *) password
{
    
    //ADD THE PASSWORD TO THE CURENT DATE STRING AND ENCRYPT
    NSData *data = [username dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    NSString* JSON = [[NSString alloc] initWithFormat: @"{\"auth\":{ \"username\":\"%@\", \"hash\":\"%@\"}}", username, output];
    NSLog(@"%@", JSON);
    [self postDataWithUrl:authURL withJSON:JSON];
    return @"nothing yet";
    
}


@end
