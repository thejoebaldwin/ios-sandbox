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
    
      NSURLConnection *connection;
    NSMutableData *httpData;
  
    void (^completion)(void);
    
    
}
- (IBAction)PostButtonClick:(id)sender;
@end
