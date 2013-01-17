//
//  testViewController.h
//  testOpenGL
//
//  Created by Joseph on 1/15/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface testViewController : GLKViewController
{

    __weak IBOutlet UIWebView *content;
}

@property (nonatomic) float scaleSize;
@property (nonatomic) float speed;

@end
