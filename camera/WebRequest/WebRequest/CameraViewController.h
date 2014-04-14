//
//  CameraViewController.h
//  WebRequest
//
//  Created by student on 4/14/14.
//  Copyright (c) 2014 FVTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)TakePictureButtonClick:(id)sender;
- (IBAction)SelectPictureButtonClick:(id)sender;
- (IBAction)UploadPictureButtonClick:(id)sender;

@end
