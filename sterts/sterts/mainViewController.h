//
//  JsonViewController.h
//  sterts
//
//  Created by Joseph on 1/9/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class StertItemStore;

@interface mainViewController : UIViewController <UIActionSheetDelegate>

{

    __weak IBOutlet UISlider *manaSlider;
   
    __weak IBOutlet UILabel *hitpointLabel;
    __weak IBOutlet UISlider *hitpointSlider;
    __weak IBOutlet UILabel *manaLabel;
    
    
   
    
}



- (BOOL) saveChanges;

- (IBAction)postButton:(id)sender;

- (IBAction) updateHitpointsLabel:(id)sender;
- (IBAction) updateManaLabel:(id)sender;
- (IBAction) go3DView:(id) sender;

@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;

@end
