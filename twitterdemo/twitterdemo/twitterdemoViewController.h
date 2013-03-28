//
//  twitterdemoViewController.h
//  twitterdemo
//
//  Created by student on 3/25/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface twitterdemoViewController : UIViewController
{
    
    NSURLConnection *_connection;
    NSMutableData *_httpData;
    NSString *_oauth_token_secret;
    NSString *_oauth_request_token;
    NSString *_pin;
    
    NSString *_oauth_consumer_secret;
    NSString *_oauth_consumer_key;
    NSString *_oauth_token;
     
    enum  AuthenticationMode : NSUInteger {
        GetRequestToken = 1,
        GetPin = 2,
        GetAccessToken = 3,
        StatusUpdateOk = 4
    };
    enum AuthenticationMode _Mode;
    
}

@property (weak, nonatomic) IBOutlet UITextField *PinField;
@property (weak, nonatomic) IBOutlet UITextField *StatusField;

- (IBAction)PostButtonClick:(id)sender;
- (IBAction)TweetButtonClick:(id)sender;
- (IBAction)AccessButtonClick:(id)sender;

-(void) SetPin:(NSString*) pin;
-(NSString *) Pin;
-(void) SetOAuthTokenSecret:(NSString *) tokenSecret;
-(NSString *) OAuthTokenSecret;
-(void) SetOAuthToken:(NSString *) token;
-(NSString *) OAuthToken;



@end
