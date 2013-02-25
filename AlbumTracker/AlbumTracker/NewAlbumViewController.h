//
//  NewAlbumViewController.h
//  AlbumTracker
//
//  Created by Joseph on 2/25/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAlbumViewController : UIViewController
{
    NSMutableArray *albumItems;
    
}

- (NSMutableArray *) AlbumItems;
- (void) SetAlbumItems:(NSMutableArray *) items;

- (IBAction)CancelButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *ArtistField;
@property (weak, nonatomic) IBOutlet UITextField *NameField;

- (IBAction)AddButtonClick:(id)sender;
@end
