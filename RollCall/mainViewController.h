//
//  mainViewController.h
//  RollCall
//
//  Created by Joseph on 1/23/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController
{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSString *allDataURL;
    NSString *postDataURL;

}
- (IBAction)goButtonClick:(id)sender;
- (IBAction)postButtonClick:(id)sender;

@end
