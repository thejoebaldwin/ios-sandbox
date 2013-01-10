//
//  JsonViewController.h
//  sterts
//
//  Created by Joseph on 1/9/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JsonViewController : UIViewController
{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    __weak IBOutlet UISlider *manaSlider;
   
    __weak IBOutlet UILabel *hitpointLabel;
    __weak IBOutlet UISlider *hitpointSlider;
    __weak IBOutlet UILabel *manaLabel;
}
- (void) fetchEntries;
@end
