//
//  GLView.h
//  Test3
//
//  Created by Joseph on 6/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


typedef struct
{
    GLfloat x;
    GLfloat y;
    GLfloat z;
} pnt;

typedef struct
{
    pnt a;
    pnt b;
    pnt c;
    pnt d;
    GLfloat x;
    GLfloat y;
    GLfloat z;
    GLfloat height;
    GLfloat width;
    GLfloat vertices[12];
    GLfloat color[4];
    GLfloat left;
    GLfloat right;
    GLfloat top;
    GLfloat bottom;
    Boolean isVisible;
    GLfloat move_x;
    GLfloat move_y;
    GLfloat velocity_x;
    GLfloat velocity_y;
    
    Boolean is_selected;
} quad;
@protocol GLViewDelegate
- (void)drawView:(UIView *)theView;
- (void)setupView:(UIView *)theView;
- (void) initVertices;
- (void) drawSquare: (quad*) theQuad;
- (void) initQuad: (quad*) theQuad;
- (void) updateQuad: (quad*) theQuad;
- (void) checkEdgeCollision: (quad*) theQuad;
- (Boolean) isCollision: (quad*) theQuad;
- (void) loadTextures: (NSString*) path andIndex: (int) index;
- (void) update;
@end

@interface GLView : UIView 
{
    

@private

    GLint backingWidth;
    GLint backingHeight;
        
    EAGLContext *context;    
    GLuint viewRenderbuffer, viewFramebuffer;
    GLuint depthRenderbuffer;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
    
    id <GLViewDelegate>     delegate;
}
@property NSTimeInterval animationInterval;
@property (assign) /* weak ref */ id <GLViewDelegate> delegate;
- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;
@end
