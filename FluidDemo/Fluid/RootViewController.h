#import <UIKit/UIKit.h>
#import "MainLayer.h"

@interface RootViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

{
    IBOutlet UIView *headerView;
    NSArray *arrStatus;
    int counter;
    NSTimer *gravityTimer;
}

- (UIView *) headerView;

@property (nonatomic, retain) MainLayer *main;
@property (retain, nonatomic) IBOutlet UIButton *stickyButton;
@property (retain, nonatomic) IBOutlet UIButton *debugButton;
//@property (retain, nonatomic) IBOutlet UIButton *toggleButton;
@property (retain, nonatomic) IBOutlet UIPickerView *pickerView;


- (IBAction)clearButtonClick:(id)sender;
- (IBAction)debugButtonClick:(id)sender;
- (IBAction)stickyButtonClick:(id)sender;
//- (IBAction)toggleButtonClick:(id)sender;

@end
