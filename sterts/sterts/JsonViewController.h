//
//  JsonViewController.h
//  sterts
//
//  Created by Joseph on 1/9/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class StertItemStore;

@interface JsonViewController : UIViewController <UIActionSheetDelegate>

{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSString *allStertsURL;
    NSString *postStertURL;
    NSMutableArray *allSterts;
    
    __weak IBOutlet UISlider *manaSlider;
   
    __weak IBOutlet UILabel *hitpointLabel;
    __weak IBOutlet UISlider *hitpointSlider;
    __weak IBOutlet UILabel *manaLabel;
    
    
   
    
}
- (void) fetchEntries:(NSString *) urlString;
- (void) postData:(NSString *) urlString;



- (IBAction)postButton:(id)sender;

- (IBAction) updateHitpointsLabel:(id)sender;
- (IBAction) updateManaLabel:(id)sender;
- (IBAction) go3DView:(id) sender;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;

@end
