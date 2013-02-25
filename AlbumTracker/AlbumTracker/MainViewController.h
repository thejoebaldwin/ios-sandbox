//
//  MainViewController.h
//  AlbumTracker
//
//  Created by Joseph on 2/25/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate>

{
    NSMutableArray *albumItems;
    
}
- (IBAction)AddButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)DeleteButtonClick:(id)sender;


@end
