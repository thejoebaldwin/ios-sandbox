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

@synthesize CurrentUser;
- (id) init
{
    self = [super init];
    if (self) {
        allStertsURL =  @"http://sterts.humboldttechgroup.com/web/app_dev.php/v1/get/sterts";
        postStertURL = @"http://sterts.humboldttechgroup.com/web/app_dev.php/v1/post";
        removeStertURL = @"http://sterts.humboldttechgroup.com/web/app_dev.php/v1/remove";
        authURL = @"http://sterts.humboldttechgroup.com/web/app_dev.php/v1/auth";
          allItems = [[NSMutableArray alloc] init];
       // [self loadUserFromArchive];
        
    }
    return self;
}



- (BOOL) isLoggedIn
{
    if (!CurrentUser) {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSMutableArray *) allItems
{
    return allItems;
    
}

- (void) loadSterts:(UIViewController *) withOwner withSelector:(NSString *) completionSelector;
{
    owner = withOwner;
    loadCompleteSelector = completionSelector;
    
    //if (CurrentUser) {
    
   [self fetchEntries:allStertsURL];
        
    //} else
        
    //{
        //[owner performSelector:NSSelectorFromString(loadCompleteSelector)];

    //}
    
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
    //NSLog(@"ReturnedData=%@", json);
    
    if ([json objectForKey:@"response"]){
       
        //this is returned on item create
        //NSLog(@"response JSON");
        NSString *operation = json[@"response"][@"operation"];
        NSLog(@"Operation:%@", operation);
        //NSLog(@"%@", json);
        
        if (  [operation isEqualToString: @"addstert"] ) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            StertItem *tempStertItem = [[StertItem alloc] init];
            [tempStertItem setHitpoints:[json[@"response"][@"sterts"][0][@"hitpoints"]  intValue ]];
            [tempStertItem setMana:[json[@"response"][@"sterts"][0][@"mana"]  intValue ]];
            [tempStertItem setCreated:[dateFormatter dateFromString: [NSString stringWithFormat:@"%@", json[@"response"][@"sterts"][0][@"created"] ] ]];
            [tempStertItem setID:[json[@"response"][@"sterts"][0][@"id"]  intValue ]];
            //display the most recent stert
            [[StertItemStore sharedStore] insertItem:tempStertItem];
            
            
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                         message:@"Your stats have been updated."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            
            
            [av show];
        }
        else if (  [operation isEqualToString: @"liststerts"]  ) {
            
            [allItems removeAllObjects];
            
                        
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            for (int i = 0; i < [json[@"response"][@"sterts"] count]; i++ )
            {
                StertItem *tempStertItem = [[StertItem alloc] init];
                [tempStertItem setHitpoints:[json[@"response"][@"sterts"][i][@"hitpoints"]  intValue ]];
                [tempStertItem setMana:[json[@"response"][@"sterts"][i][@"mana"]  intValue ]];
                [tempStertItem setCreated:[dateFormatter dateFromString: [NSString stringWithFormat:@"%@", json[@"response"][@"sterts"][i][@"created"] ] ]];
                [tempStertItem setID:[json[@"response"][@"sterts"][i][@"id"]  intValue ]];
                //display the most recent stert
                if (i == 0) {
                    
                    NSLog(@"%@", tempStertItem);
                    
                }
                
                [[StertItemStore sharedStore] addItems:tempStertItem];
                
                
                
            }
            [owner performSelector:NSSelectorFromString(loadCompleteSelector)];

            
        }
        else if (  [operation isEqualToString: @"deletestert"]  ) {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                         message:@"Your stats have been deleted."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            
            
          //  [av show];

        }
           else if (  [operation isEqualToString: @"authuser"]  ) {
               
               
               
               
               
               authToken =  json[@"response"][@"user"][@"token"];
               if (!CurrentUser)
               {
                   CurrentUser = [[User alloc] init];
               }
               [CurrentUser setAuthToken:json[@"response"][@"user"][@"token"]];
               [CurrentUser setUsername:json[@"response"][@"user"][@"username"]];
               NSLog(@"AuthToken:%@", authToken);

             [owner performSelector:NSSelectorFromString(loadCompleteSelector)];
           
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

-(void) loadWithOwner:(UIViewController *) withOwner completionSelector:(NSString *) withSelector;
{
    owner = withOwner;
    loadCompleteSelector = withSelector;
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



- (NSString *) getAuthHash:(NSString *) password
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString* today = [formatter stringFromDate:[NSDate date]];
    
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02x", digest[i]];
    }
    
    //add the date at the end
    [hash appendString:today];
    
    
    //hash it again!
    
    NSData *data2 = [hash dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest2[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data2.bytes, data2.length, digest2);
    NSMutableString *hash2 = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [hash2 appendFormat:@"%02x", digest2[i]];
    }
    return hash2;

}

- (void) getAuthToken:(NSString *) username withPassword:(NSString *) password withOwner:(UIViewController *) thisOwner completionSelector:(NSString*) withSelector
{
    owner = thisOwner;
    loadCompleteSelector = withSelector;
    NSString *hash = [self getAuthHash:password];
    NSString* JSON = [[NSString alloc] initWithFormat: @"{\"auth\":{ \"username\":\"%@\", \"hash\":\"%@\"}}", username, hash];
    [self postDataWithUrl:authURL withJSON:JSON];
}
@end
