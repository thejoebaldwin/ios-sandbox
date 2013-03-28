//
//  PinViewController.h
//  twitterdemo
//
//  Created by Joseph Baldwin on 3/27/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinViewController : UIViewController
{
    NSString *_AuthorizationURL;
    
}
-(void) SetAuthorizationURL:(NSString *) url;

@property (weak, nonatomic) IBOutlet UIWebView *PinWebView;
- (IBAction)BackButtonClick:(id)sender;

@end
