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


@synthesize PinField, StatusField;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        //TODO: get from storage once post is working
        
        _oauth_token = [ self OAuthToken];
        _oauth_token_secret = [self OAuthTokenSecret];
        _oauth_consumer_secret = @"CONSUMER SECRET";
        _oauth_consumer_key = @"CONSUMER KEY";
        _okToTweet = NO;
        _Mode = GetRequestToken;
        

    }
    return self;
}




- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [PinField resignFirstResponder];
    [StatusField resignFirstResponder];
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

    
    
    if (_Mode == GetRequestToken || _Mode == GetAccessToken)
    {
        if ([arguments objectForKey:@"oauth_token"] != nil) {
            _oauth_token = [arguments objectForKey:@"oauth_token"];
        }
        if ([arguments objectForKey:@"oauth_token_secret"] != nil) {
            _oauth_token_secret = [arguments objectForKey:@"oauth_token_secret"];
        }

        if (_Mode == GetAccessToken)
        {
            [self SetOAuthTokenSecret:_oauth_token_secret];
            [self SetOAuthToken:_oauth_token];
        }
        
        NSLog(@"_oauth_token:%@", _oauth_token);
        NSLog(@"_oauth_token_secret:%@", _oauth_token_secret);
    }
   
       
   
    
 
     
    
    if (_Mode == GetRequestToken)
    {
        _Mode = GetPin;
        NSString *urlAddress = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", _oauth_token];
    
        PinViewController *web = [[PinViewController alloc] init];
        [web SetAuthorizationURL:urlAddress];
    
        UINavigationController *navController  = [[UINavigationController alloc] initWithRootViewController:web];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else if (_Mode == GetAccessToken)
    {
       // _Mode = StatusUpdateOk;
    }
    
 
   
    
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



-(NSString *) getAuthorizationHeader:(NSString *) postURL withSigningKey:(NSString *) key withStatus:(NSString *) status
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

    
    if (_Mode == GetAccessToken || _Mode == StatusUpdateOk)
    {
        [base_signature appendFormat:@"&oauth_token=%@", _oauth_token];
    }
    
    if (_Mode == GetAccessToken)
    {
        [base_signature appendFormat:@"oauth_verifier=%@", _pin];
    }

    [base_signature appendFormat:@"&oauth_version=%@", oauth_version];
    
    
    if (_Mode == StatusUpdateOk) {
                    [base_signature appendFormat:@"&status=%@",[NSString stringWithUTF8String:[status UTF8String]]];
    }
    
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
    
    if (_Mode == GetAccessToken || _Mode == StatusUpdateOk)
    {
        [authorization appendFormat:@"oauth_token=\"%@\", ",
         [self urlEncode:_oauth_token]
         ];
    }
    
    if (_Mode == GetAccessToken)
    {
        [authorization appendFormat:@"oauth_verifier=\"%@\", ",
        [self urlEncode:_pin]
         ];
    }
    
    [authorization appendFormat:@"oauth_version=\"%@\"",
        [self urlEncode:oauth_version]
     ];
    //NSLog(@"Authorization:%@", authorization);
    return authorization;
}

- (void) postDataWithUrl:(NSString *) urlString withAuthorization:(NSString *) authorization withStatus:(NSString *) status
{
    // Create a new data container for the stuff that comes back from the service
    _httpData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
     [request setHTTPMethod:@"POST"];
       
     if (_Mode == StatusUpdateOk)
     {
         //standard url encoding was escaping the percentage signs, which is needed for the base signature encoding
         // if used on the post body, the signature won't match. so using bodyencode.
         
         NSString *postBody  = [NSString stringWithFormat:@"status=%@", [self bodyEncode:status]];
         NSLog(@"Status:%@\nPost Body:%@",status, postBody);
        // postBody = [self urlEncode:postBody];
         
         NSData* postData=[postBody dataUsingEncoding:NSUTF8StringEncoding];
         
        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: postData];
         NSLog(@"Posting Body");
     }
  
    
      //add the authorization header
     [request setValue:authorization forHTTPHeaderField:@"Authorization"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //start the http request
    _connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:YES];
}


- (NSString *)bodyEncode:(NSString *) contents {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[contents UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
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

    NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&", _oauth_consumer_secret];
    
    NSString *request_token_url = @"https://api.twitter.com/oauth/request_token";
    
    NSString *authorization = [self getAuthorizationHeader:request_token_url withSigningKey:signing_key withStatus:nil ];
    
    [self postDataWithUrl:request_token_url withAuthorization:authorization withStatus:nil];
}

- (IBAction)TweetButtonClick:(id)sender {
    
    NSLog(@"*****STATUS UPDATE REQUEST*********");
  
    _Mode = StatusUpdateOk;

    
    _pin = [PinField text];
    
    NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&%@", _oauth_consumer_secret, _oauth_token_secret];
    
    NSString *status_update_url = @"https://api.twitter.com/1.1/statuses/update.json";
    
    NSString *authorization = [self getAuthorizationHeader:status_update_url withSigningKey:signing_key withStatus:[StatusField text]];
    
    [self postDataWithUrl:status_update_url withAuthorization:authorization withStatus:[StatusField text]];
   
    
}


- (IBAction)AccessButtonClick:(id)sender {
    
    
    NSLog(@"*****ACCESS TOKEN REQUEST*********");
    
    _Mode = GetAccessToken;

   NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&%@", _oauth_consumer_secret, _oauth_token_secret];
    
    
      //  NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&", _oauth_consumer_secret];
    
    NSString *access_token_url = @"https://api.twitter.com/oauth/access_token";
    
    NSString *authorization = [self getAuthorizationHeader:access_token_url withSigningKey:signing_key withStatus:nil];
    
    [self postDataWithUrl:access_token_url withAuthorization:authorization withStatus:nil];
}





-(void) SetPin:(NSString*) pin
{
    _pin = pin;
   
    [[NSUserDefaults standardUserDefaults] setObject:_pin forKey:@"pin"];
    
    
    
    [PinField setText:pin];
}

-(NSString *) Pin
{
    _pin= [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"pin"];
    
 

    
    return _pin;
}
-(void) SetOAuthTokenSecret:(NSString *) tokenSecret
{
    _oauth_token_secret = tokenSecret;
    [[NSUserDefaults standardUserDefaults] setObject:_oauth_token_secret forKey:@"oauth_token_secret"];
}

-(NSString *) OAuthTokenSecret
{
    _oauth_token_secret= [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"oauth_token_secret"];
    
    return _oauth_token_secret;
}

-(void) SetOAuthToken:(NSString *) token{
    _oauth_token = token;
     [[NSUserDefaults standardUserDefaults] setObject:_oauth_token forKey:@"oauth_token"];
}

-(NSString *) OAuthToken{
    
    _oauth_token= [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"oauth_token"];
    
   
    
    return _oauth_token;
}



@end
