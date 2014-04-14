//
//  CameraViewController.h
//  WebRequest
//
//  Created by student on 4/14/14.
//  Copyright (c) 2014 FVTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)TakePhotoButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)SelectPhoto:(id)sender;
- (IBAction)UpdatePhoto:(id)sender;




@end
