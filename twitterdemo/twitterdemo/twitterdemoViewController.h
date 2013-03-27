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
    NSString *_oauth_token;
    void (^completion)(void);
}
- (IBAction)PostButtonClick:(id)sender;

- (IBAction)AccessTokenButtonClick:(id)sender;

@end
