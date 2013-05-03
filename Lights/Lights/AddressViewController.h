//
//  AddressViewController.h
//  Stoplight
//
//  Created by Joseph Baldwin on 3/24/13.
//
//

#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController
{

    NSMutableString *_LightsAddress;
    
}


@property (retain, nonatomic) IBOutlet UITextField *AddressField;
- (IBAction)CancelButtonClick:(id)sender;
- (IBAction)UpdateButtonClick:(id)sender;

- (void) SetLightsAddress:(NSMutableString *) url;
- (NSString *) LightsAddress;
@end
