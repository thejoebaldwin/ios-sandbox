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
    NSString *allStertsURL;
    NSString *postStertURL;
    
    
    __weak IBOutlet UISlider *manaSlider;
   
    __weak IBOutlet UILabel *hitpointLabel;
    __weak IBOutlet UISlider *hitpointSlider;
    __weak IBOutlet UILabel *manaLabel;
}
- (void) fetchEntries:(NSString *) urlString;
- (void) postData:(NSString *) urlString;


- (IBAction)getButton:(id)sender;
- (IBAction)postButton:(id)sender;

- (IBAction) updateHitpointsLabel:(id)sender;
- (IBAction) updateManaLabel:(id)sender;

@end
