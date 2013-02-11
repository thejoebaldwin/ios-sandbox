//
//  testviewViewController.h
//  PickerTest
//
//  Created by Joseph on 2/11/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testviewViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
       NSArray *arrNumbers;
    
    int count;
    
}
- (IBAction)AddButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end
