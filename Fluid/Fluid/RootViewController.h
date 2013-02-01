#import <UIKit/UIKit.h>
#import "MainLayer.h"

@interface RootViewController : UIViewController {

    
    IBOutlet UIView *headerView;
    
}
- (IBAction)ClearButtonClick:(id)sender;




- (UIView *) headerView;

@property (nonatomic, retain) MainLayer *main;

@end
