//
//  DLRenderTexture.m
//  RecipeCollection02
//
//  Created by Joseph Baldwin on 1/31/13.
//  Copyright (c) 2013 Nathan Burba. All rights reserved.
//

#import "DLRenderTexture.h"

@implementation DLRenderTexture

/*
- (void)draw{
    // use alpha test to give it hard edges
    glEnable(GL_ALPHA_TEST);
    glAlphaFunc(GL_GREATER, 0.7f);
}
*/



-(void)visit{
//glEnable(GL_ALPHA_TEST);
//    glAlphaFunc(GL_GREATER, 0.2f);
    [super visit];
  //  glDisable(GL_ALPHA_TEST);
}

@end
