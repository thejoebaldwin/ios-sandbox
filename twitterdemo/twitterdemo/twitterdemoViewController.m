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
#import "Base64Transcoder.h"

#import "PinViewController.h"

@interface twitterdemoViewController ()

@end

@implementation twitterdemoViewController


@synthesize PinField;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        _oauth_token = @"";
        _oauth_token_secret = @"";
        _oauth_consumer_secret = @"CONSUMER SECRET HERE";
        _oauth_consumer_key = @"CONSUMER KEY HERE";
        _okToTweet = NO;
        _Mode = GetRequestToken;
        

    }
    return self;
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [PinField resignFirstResponder];
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
    [_httpData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSString *response = [[NSString alloc] initWithData:_httpData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", response);
    
    NSMutableDictionary *arguments = [self ParseQueryString:response];
    if ([arguments objectForKey:@"oauth_token"] != nil) {
    _oauth_token = [arguments objectForKey:@"oauth_token"];
    }
     if ([arguments objectForKey:@"oauth_token_secret"] != nil) {
        _oauth_token_secret = [arguments objectForKey:@"oauth_token_secret"];
     }
   
    
    
    NSLog(@"_oauth_token:%@", _oauth_token);
    NSLog(@"_oauth_token_secret:%@", _oauth_token_secret);
    //use the token to connect to
    //https://api.twitter.com/oauth/authorize?oauth_token=_oauth_token
    
    //get pin. here is current pin
    //6189849
    
   
    
    NSString *urlAddress = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", _oauth_token];
    
    
    PinViewController *web = [[PinViewController alloc] init];
    [web SetAuthorizationURL:urlAddress];
    
    
    UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:web];
    [self presentViewController:navController animated:YES completion:nil];

    //do popover?
    
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
    
        NSString *word = @"&";
    if ([queryString rangeOfString:word].location != NSNotFound) {
        NSArray *urlComponents = [queryString componentsSeparatedByString:@"&"];
        //Then populate the dictionary :
        
        for (NSString *keyValuePair in urlComponents)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [pairComponents objectAtIndex:1];
            
            [queryStringDictionary setObject:value forKey:key];
        }

        
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

-(NSString *) getAuthorizationHeader:(NSString *) postURL withSigningKey:(NSString *) key withStatus:(NSString *) status withUser:(NSString *) user withPass:(NSString *) pass
{
    
    //get seconds since the linux epoch
    NSString *oauth_timestamp = [self getCurrentDateUTC] ;
  
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
    NSMutableString *base_signature = [[NSMutableString alloc] init];
    if (_Mode == GetRequestToken) {
        [base_signature appendFormat:@"oauth_callback=%@&", @"oob"];
    }
    
    [base_signature appendFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@",
     _oauth_consumer_key,
     oauth_nonce,
     oauth_signature_method,
     oauth_timestamp
     ];

    if (_Mode == GetAccessToken)
    {
        [base_signature appendFormat:@"&oauth_token=%@&oauth_verifier=%@", _oauth_token, _pin];
    }

    [base_signature appendFormat:@"&oauth_version=%@", oauth_version];
    
    
    if (_Mode == StatusUpdateOk) {
           [base_signature appendFormat:@"&status=%@", status];
    }
    
    /*
    base_signature = [[NSMutableString alloc] initWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@",
                      _oauth_consumer_key,
                      oauth_nonce,
                      oauth_signature_method,
                      oauth_timestamp,
                      oauth_version
                      ];

    */
    /*
    base_signature = [[NSString alloc] initWithFormat:@"oauth_callback=%@&oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@",
                             @"oob",
                              _oauth_consumer_key,
                              oauth_nonce,
                              oauth_signature_method,
                              oauth_timestamp,
                              oauth_version
                            ];
    }
    else {
        base_signature = [[NSString alloc] initWithFormat:@"oauth_callback=%@&oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_token=%@&oauth_verifier=%@&oauth_version=%@",
                          @"oob",
                          _oauth_consumer_key,
                          oauth_nonce,
                          oauth_signature_method,
                          oauth_timestamp,
                          _oauth_token,
                          _pin,
                          oauth_version
                          ];

    }
    */
    /*
    if (user != nil && pass != nil)
    {
        base_signature = [NSString stringWithFormat:@"%@&x_auth_mode=%@&x_auth_password=%@&x_auth_username=%@", base_signature, @"client_auth", pass, user];
    }
    if (status != nil)
    {
         base_signature = [NSString stringWithFormat:@"%@&status=%@", base_signature, status];
    }
    */
    //url encode the base signature
    base_signature =  [NSMutableString stringWithString: [self urlEncode: [NSString stringWithString:base_signature]]];
    //add POST& and url encoded destination url in front of existing base signature
    base_signature = [NSMutableString stringWithFormat:@"POST&%@&%@", [self urlEncode:postURL], base_signature];
    
    NSLog(@"Base Signature:%@", base_signature);
    NSLog(@"-----------------------------");
    //sign the base signature with hmac-sha1 encryption and partial key
    NSString *oauth_signature = [self hmacsha1:base_signature key:key];
    
    //build the authorization header, separating out with commas instead of &
    //      and escaping quotation marks around values
    NSMutableString *authorization = [[NSMutableString alloc] init];
    
    
    [authorization appendFormat:@"OAuth "];
            
        
       
    if (_Mode == GetRequestToken)
    {
        [authorization appendFormat:@"oauth_callback=\"%@\", ",
         [self urlEncode:@"oob"]
         ];
    }
    
    [authorization appendFormat:@"oauth_consumer_key=\"%@\", oauth_nonce=\"%@\", oauth_signature=\"%@\", oauth_signature_method=\"%@\", oauth_timestamp=\"%@\", ",
     [self urlEncode:_oauth_consumer_key],
     [self urlEncode:oauth_nonce],
     [self urlEncode:oauth_signature],
     [self urlEncode:oauth_signature_method],
     [self urlEncode:oauth_timestamp]
     ];

    
    
    if (_Mode == GetAccessToken)
    {
        [authorization appendFormat:@"oauth_token=\"%@\", oauth_verifier=\"%@\", ",
         [self urlEncode:_oauth_token],
         [self urlEncode:_pin]
         ];

        
    }
    
    [authorization appendFormat:@"oauth_version=\"%@\"",
        [self urlEncode:oauth_version]
     ];

    
    if (_Mode == StatusUpdateOk)
    {
        //?
        
    }



    
    NSLog(@"Authorization:%@", authorization);


    
    return authorization;
}

- (void) postDataWithUrl:(NSString *) urlString withAuthorization:(NSString *) authorization
{
    // Create a new data container for the stuff that comes back from the service
    _httpData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    /*
    
     NSString *postBody  = [NSString stringWithFormat:@"x_auth_mode=%@&x_auth_password=%@&x_auth_username=%@",
                     
                     @"client_auth",
                   [self urlEncode: @"ickthorn"],
                                      [self urlEncode: @"htgbot"]
                     ];
  NSData* postData=[postBody dataUsingEncoding:NSUTF8StringEncoding];

     [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
     [request setHTTPBody: postData];

     
     */
   // postBody = [self urlEncode:postBody];
    
     if (_okToTweet)
     {
         NSString *postBody  = [NSString stringWithFormat:@"status=%@", [self urlEncode:@"Testing ios client" ]];
         NSData* postData=[postBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: postData];
     }
  
    
      [request setHTTPMethod:@"POST"];
     

    
    
      [request setValue:authorization forHTTPHeaderField:@"Authorization"];
      [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //start the http request
    _connection = [[NSURLConnection alloc] initWithRequest:request
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
    NSLog(@"*****REQUEST TOKEN REQUEST*********");

    
    
       
    //check if status us nil then build
    NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&", _oauth_consumer_secret];
    
    NSString *request_token_url = @"https://api.twitter.com/oauth/request_token";
    
    NSString *authorization = [self getAuthorizationHeader:request_token_url withSigningKey:signing_key withStatus:nil withUser:nil withPass:nil];
    
    [self postDataWithUrl:request_token_url withAuthorization:authorization];
}

- (IBAction)TweetButtonClick:(id)sender {
    
    NSLog(@"*****STATUS UPDATE REQUEST*********");
    _okToTweet = true;
    _pin = [PinField text];
    //check if status us nil then build
    NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&%@", _oauth_consumer_secret, _oauth_token_secret];
    
    NSString *status_update_url = @"https://api.twitter.com/1.1/statuses/update.json";
    
    NSString *authorization = [self getAuthorizationHeader:status_update_url withSigningKey:signing_key withStatus:@"Testing iOS client" withUser:nil withPass:nil];
    
    [self postDataWithUrl:status_update_url withAuthorization:authorization];

    
    
}





- (IBAction)AccessButtonClick:(id)sender {
    
    //THIS IS NEXT!!!
    
    
}
@end
