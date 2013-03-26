//
//  twitterdemoViewController.m
//  twitterdemo
//
//  Created by student on 3/25/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "twitterdemoViewController.h"
//#import "NSData+Base64.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Base64Transcoder.h";

@interface twitterdemoViewController ()

@end

@implementation twitterdemoViewController

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



- (void) connection: (NSURLConnection *) conn
   didFailWithError:(NSError *)error
{
    // Release the connection object, we're done with it
    httpData = nil;
    
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


- (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret {
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    
    return base64EncodedResult;
}







// This method will be called several times as the data arrives
- (void) connection:(NSURLConnection *) conn didReceiveData:(NSData *)data
{
    // Add the incoming chunk of data to the container we are keeping
    // the data always comes int he correct order
    [httpData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSString *response = [[NSString alloc] initWithData:httpData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *arguments = [self ParseQueryString:response];
    oauth_token = [arguments objectForKey:@"oauth_token"];
    oauth_token_secret = [arguments objectForKey:@"oauth_token_secret"];
    NSLog(@"%@", response);
    
    
    NSLog(@"oauth_token:%@", oauth_token);
    NSLog(@"oauth_token_secret:%@", oauth_token_secret);
    
}


-(NSString *)getCurrentDateUTC
{
    float seconds = [[NSDate date] timeIntervalSince1970];
    NSString *t =  [NSString stringWithFormat:@"%i", (int) floor(seconds)];
    return t;
}

-(NSMutableDictionary *) ParseQueryString:(NSString *) queryString
{
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
    //Then populate the dictionary :
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = [pairComponents objectAtIndex:1];
        
        [queryStringDictionary setObject:value forKey:key];
    }
    
    return queryStringDictionary;
    
}

- (NSString *)encodeSHA1:(NSString *)text key:(NSString *)secret {
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    return base64EncodedResult;
}

- (void) postDataWithUrl:(NSString *) urlString
{
    // Create a new data container for the stuff that comes back from the service
    httpData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    //get seconds since the linux epoch
    NSString *oauth_timestamp = [self getCurrentDateUTC] ;
    NSString *oauth_callback = @"oob";
    NSString *oauth_consumer_key = @"Q40EmGbUkWLW6WJ0mdeqA";
    NSMutableString *oauth_nonce = [[NSMutableString alloc] init];
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    //generate 32 random characters for "nonce" which tells twitter this is a new request
    for (NSUInteger i = 0U; i < 32; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [oauth_nonce appendFormat:@"%C", c];
    }
    
      
   NSString *oauth_signature_method = @"HMAC-SHA1";
   NSString *oauth_version = @"1.0";
   NSString *oauth_token = @"19618155-QZ23iExJAdCjpcvxW7is0FJzyzuD6LH3j9vEpyTg";
   NSString *base_signature = [[NSString alloc] initWithFormat:@"oauth_callback=%@&oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_token=%@&oauth_version=%@",
                               
                                 oauth_callback,
                                 oauth_consumer_key,
                                 oauth_nonce,
                                 oauth_signature_method,
                                 oauth_timestamp,
                                 oauth_token,
                                 oauth_version
                                 ];
    //url encode the base signature
    base_signature = [self urlEncode:base_signature];
    //add POST& and url encoded destination url in front of existing base signature
    base_signature = [[NSString alloc] initWithFormat:@"POST&%@&%@", [self urlEncode:urlString], base_signature];
    
    NSString *oauth_consumer_secret = @"WWLNgPQtPujnpz0XmQU3bdMhaGGMCa1wyFg3ABE9Lis";
    NSString *oauth_token_secret = @"3XygpcZRRBAkra3eUW7QPF5jP6davJsig1Jw3NKs";
    //NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&%@", oauth_consumer_secret, oauth_token_secret];
    //using only partial key because we are retrieving request token.
    NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&", oauth_consumer_secret];
    NSLog(@"Base Signature:@%@", base_signature);
    NSLog(@"-----------------------------@");
    //sign the base signature with hmac-sha1 encryption and partial key
    NSString *oauth_signature = [self hmacsha1:base_signature key:signing_key];
    
    //build the authorization header, separating out with commas instead of &
    //      and escaping quotation marks around values
    NSString *authorization = [[NSString alloc] initWithFormat:@"OAuth oauth_callback=\"%@\", oauth_consumer_key=\"%@\", oauth_nonce=\"%@\", oauth_signature=\"%@\", oauth_signature_method=\"%@\", oauth_timestamp=\"%@\",oauth_token=\"%@\", oauth_version=\"%@\"",
                                [self urlEncode:oauth_callback],
                                [self urlEncode:oauth_consumer_key],
                                [self urlEncode:oauth_nonce],
                                [self urlEncode:oauth_signature],
                                [self urlEncode:oauth_signature_method],
                                [self urlEncode:oauth_timestamp],
                                [self urlEncode:oauth_token],
                                [self urlEncode:oauth_version]
                               ];

    //add the authorization httpheader to the httprequest
    NSLog(@"Authorization:%@", authorization);
    [request setHTTPMethod:@"POST"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    //[request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //start the http request
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:YES];
}

- (NSString *) urlEncode:(NSString *) strURL
{
   NSString *encodedString = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                 NULL,
                                                                                                 (__bridge CFStringRef)encodedString,
                                                                                                 NULL, 
                                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", 
                                                                                                 kCFStringEncodingUTF8);
    return encodedString;
}


- (IBAction)PostButtonClick:(id)sender {
    [self postDataWithUrl:@"https://api.twitter.com/oauth/request_token"];
}


@end
