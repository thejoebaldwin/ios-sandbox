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
    
     NSLog(@"secret:@%@", secret);
    
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    
   
    
    NSString *resultFromChar = [[NSString alloc] initWithBytes:result length:sizeof(result) encoding:NSASCIIStringEncoding];
    NSLog(@"ResultFromChar:%@", resultFromChar);
    //NSString *base64result =  [self decodeBase64:resultFromChar ];
    
    NSData *resultData = [resultFromChar dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64result = [self Base64Encode:resultData];
    
    NSLog(@"base64result:%@", base64result);
    //NSData *data = [NSData alloc] initWithCont
  
    NSData *theData = [base64result dataUsingEncoding:NSUTF8StringEncoding];    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    NSLog(@"base64EncodedResult:%@", base64result);

    return base64EncodedResult;
}




-(NSString *)Base64Encode:(NSData *)data{
    //Point to start of the data and set buffer sizes
    int inLength = [data length];
    int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
    const char *inputBuffer = [data bytes];
    char *outputBuffer = malloc(outLength);
    outputBuffer[outLength] = 0;
    
    //64 digit code
    static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    //start the count
    int cycle = 0;
    int inpos = 0;
    int outpos = 0;
    char temp;
    
    //Pad the last to bytes, the outbuffer must always be a multiple of 4
    outputBuffer[outLength-1] = '=';
    outputBuffer[outLength-2] = '=';
    
    /* http://en.wikipedia.org/wiki/Base64
     Text content   M           a           n
     ASCII          77          97          110
     8 Bit pattern  01001101    01100001    01101110
     
     6 Bit pattern  010011  010110  000101  101110
     Index          19      22      5       46
     Base64-encoded T       W       F       u
     */
    
    
    while (inpos < inLength){
        switch (cycle) {
            case 0:
                outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
                cycle = 1;
                break;
            case 1:
                temp = (inputBuffer[inpos++]&0x03)<<4;
                outputBuffer[outpos] = Encode[temp];
                cycle = 2;
                break;
            case 2:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
                temp = (inputBuffer[inpos++]&0x0F)<<2;
                outputBuffer[outpos] = Encode[temp];
                cycle = 3;
                break;
            case 3:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
                cycle = 4;
                break;
            case 4:
                outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
                cycle = 0;
                break;                          
            default:
                cycle = 0;
                break;
        }
    }
    NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
    free(outputBuffer); 
    return pictemp;
}


- (NSString *)decodeBase64:(NSString *)input {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-";
    NSString *decoded = @"";
    NSString *encoded = [input stringByPaddingToLength:(ceil([input length] / 4) * 4)
                                            withString:@"A"
                                       startingAtIndex:0];
    
    int i;
    char a, b, c, d;
    UInt32 z;
    
    for(i = 0; i < [encoded length]; i += 4) {
        a = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 0, 1)]].location;
        b = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 1, 1)]].location;
        c = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 2, 1)]].location;
        d = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 3, 1)]].location;
        
        z = ((UInt32)a << 26) + ((UInt32)b << 20) + ((UInt32)c << 14) + ((UInt32)d << 8);
        decoded = [decoded stringByAppendingString:[NSString stringWithCString:(char *)&z]];
    }
    
    
    return decoded;
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
    NSLog(@"%@", response);
}


-(NSString *)getCurrentDateUTC
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
   
    return dateString;
}

- (void) postDataWithUrl:(NSString *) urlString
{
    // Create a new data container for the stuff that comes back from the service
    httpData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    NSString *oauth_timestamp = [self getCurrentDateUTC] ;
    
    NSString *oauth_callback = @"oob";
    NSString *oauth_consumer_key = @"Q40EmGbUkWLW6WJ0mdeqA";
 
    NSMutableString *oauth_nonce = [[NSMutableString alloc] init];
    [oauth_nonce appendString:@"K7ny27zAK5BslRsqyw"];
    [oauth_nonce appendString:oauth_timestamp];
    NSString *oauth_signature_method = @"HMAC-SHA1";
    NSString *oauth_version = @"1.0";


    
    NSString *oauth_signature = [[NSString alloc] initWithFormat:@"oauth_callback=%@&oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_timestamp=%@&oauth_version=%@",
                           oauth_callback,
                                 oauth_consumer_key,
                                 oauth_nonce,
                                 oauth_signature_method,
                                 oauth_timestamp,
                                 oauth_version
                                 ];
    
    oauth_signature = [self urlEncode:oauth_signature];
    
    NSString *oauth_token = @"QZ23iExJAdCjpcvxW7is0FJzyzuD6LH3j9vEpyTg";
    NSString *oauth_consumer_secret = @"WWLNgPQtPujnpz0XmQU3bdMhaGGMCa1wyFg3ABE9Lis";
    NSString *oauth_token_secret = @"3XygpcZRRBAkra3eUW7QPF5jP6davJsig1Jw3NKs";
    NSString *signing_key = [[NSString alloc] initWithFormat:@"%@&%@", oauth_consumer_secret, oauth_token_secret];
    
    //hmacsha1
      NSLog(@"oauth_signature BEFORE encryption:%@", oauth_signature);
    oauth_signature = [self hmacsha1:oauth_signature key:signing_key];
    
       NSLog(@"Signing Key:%@", signing_key);
    NSLog(@"FinalSignature:%@", oauth_signature);
    
    //url encode signature
    //url enco
    //take signature -> POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Frequest_token&<SIGNATURE ENCODED HERE>
    //encrypt consumer secret with signature
    //add signature into header
    
    
    
    
    
    
    //oauth_signature = "POST" + "&" + UrlEncode(oauth_request_token_url) + "&" + UrlEncode(oauth_signature);
    //oauth_signature = Convert.ToBase64String((new HMACSHA1(Encoding.ASCII.GetBytes(UrlEncode(oauth_consumer_secret) + "&"))).ComputeHash(Encoding.ASCII.GetBytes(oauth_signature)));
    
    
  
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:oauth_nonce forHTTPHeaderField:@"oauth_nonce"];
    [request setValue:oauth_callback forHTTPHeaderField:@"oauth_callback"];
    [request setValue:oauth_signature_method forHTTPHeaderField:@"oauth_signature_method"];
    [request setValue:oauth_timestamp forHTTPHeaderField:@"oauth_timestamp"];
    [request setValue:oauth_consumer_key forHTTPHeaderField:@"oauth_consumer_key"];
    [request setValue:oauth_version forHTTPHeaderField:@"oauth_version"];
    [request setValue:oauth_signature forHTTPHeaderField:@"oauth_signature"];
    
    // Create a connection that will exchange this request for data from the URL
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
    NSLog(@"Encoded String before:%@ after:%@",strURL, encodedString);
    
    return encodedString;
}
- (IBAction)PostButtonClick:(id)sender {
    
    [self postDataWithUrl:@"https://api.twitter.com/oauth/request_token"];
    
}


- (NSString *)urlencode:(NSString *) url {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[url UTF8String];
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

@end
