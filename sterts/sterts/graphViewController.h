//
//  graphViewController.h
//  sterts
//
//  Created by Joseph Baldwin on 1/21/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface graphViewController : UIViewController
{
    
    NSString *urlAddress;
    __weak IBOutlet UIWebView *graphWebView;
}
- (IBAction)refreshButtonClick:(id)sender;
@end
