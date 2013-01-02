//
//  GLViewController.m
//  Test3
//
//  Created by Joseph on 6/15/11.
//  Copyright Humboldt Technology Group, LLC 2011. All rights reserved.
//

#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"
#import "Test3AppDelegate.h"
@implementation GLViewController

-(void) updateQuad: (quad*) theQuad
{   
    //if there is a velocity, this will update the movement on the quad
    theQuad->move_x = theQuad->move_x + MOVE_INCREMENT * theQuad->velocity_x;
    theQuad->move_y = theQuad->move_y + MOVE_INCREMENT * theQuad->velocity_y;
}

-(void) initQuad: (quad*) theQuad
{
    GLfloat z = theQuad->z;
    GLfloat square_vertex[] = {
        // FRONT
        0.0 + theQuad->x,  0.0 + theQuad->y, z,
        theQuad->x + theQuad->width, 0.0 + theQuad->y, z,
        0.0 + theQuad->x,  theQuad->y + theQuad->height, z,
        theQuad->x + theQuad->width, theQuad->y + theQuad->height, z
    };

    theQuad->left = theQuad->x;
    theQuad->right = theQuad->x + theQuad->width;
    theQuad->top = theQuad->y + theQuad->height;
    theQuad->bottom = theQuad->y;
    theQuad->isVisible = true;
    for (int i =0; i < 12;i++)
    {
        theQuad->vertices[i] = square_vertex[i];    
    }
    //the following sets initial, random velocities
    int negative_x = 1;
    int negative_y = 1;
    if (arc4random() % 2 == 0) negative_x = -1;    
    if (arc4random() % 2 == 0) negative_y = -1;    
    theQuad->velocity_x =  (arc4random() % 100) / 50.0 * negative_x;
    theQuad->velocity_y =  (arc4random() % 100) / 50.0 * negative_y;
}


-(Boolean) isCollision:(quad *)theQuad
{
    //screen dimension from touch is 320 x 480
    Boolean wasCollision = false;
    GLfloat temp_x = touch_x;
    GLfloat temp_y = touch_y;
    if ((temp_x >= theQuad->left + theQuad->move_x) && (temp_x <= theQuad->right +theQuad->move_x))
     {
         if (-temp_y <= theQuad->top - theQuad->move_y && -temp_y >= theQuad->bottom - theQuad->move_y)
         {
             if (theQuad->is_selected)
             {
                 theQuad->is_selected = false;
             }
             else
             {
                 theQuad->is_selected = true;
             }
        }
     }
           
    //check if it hit border, if so reverse velocity
    return wasCollision;
}


-(void) checkEdgeCollision:(quad *) theQuad
{
    GLfloat x_bound = 13.0;
    GLfloat y_bound = 18.0;
      if (theQuad->x + theQuad->move_x >= x_bound || theQuad->x + theQuad->move_x <= -x_bound)
    {
        theQuad->velocity_x = theQuad->velocity_x * -1.0;
        
    }
    
    if (theQuad->y + theQuad->move_y >= y_bound || theQuad->y + theQuad->move_y <= -y_bound)
    {
        theQuad->velocity_y = theQuad->velocity_y * -1.0;
    }

}

-(void) drawSquare:(quad*) theQuad
{       
    Boolean tempBool = false;
    if (theQuad->move_x != 0 && theQuad->move_y != 0)
    {
            glTranslatef(theQuad->move_x, -(theQuad->move_y), 0.0);
            tempBool = true;
    }
    if (theQuad->is_selected)
    {
     glBindTexture(GL_TEXTURE_2D, texture[1]);
    }   
    else
    {
     glBindTexture(GL_TEXTURE_2D, texture[0]);
    }  
    glColor4f(theQuad->color[0], theQuad->color[1], theQuad->color[2], theQuad->color[3]);

    glVertexPointer(3, GL_FLOAT, 0, &(theQuad->vertices));
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    if (tempBool)
    {
     glTranslatef(-(theQuad->move_x), (theQuad->move_y), 0.0);
    }
}
 
-(void) initVertices
{
    int x = 0;
    int y = 0;
    for (int i =0; i < arrLen ;i++)
    {
        quad tempQuad;
        int dimension = arc4random() % 6; 
        tempQuad.color[0] = ((arc4random() % 100) / 100.0);
        tempQuad.color[1] = ((arc4random() % 100) / 100.0);
        tempQuad.color[2] = ((arc4random() % 100) / 100.0);
        tempQuad.color[3] = 1.0;
        tempQuad.x = x;
        tempQuad.y = y;
        tempQuad.z = i / arrLen;
        tempQuad.width = dimension;
        tempQuad.height = dimension;
        tempQuad.move_x = 0;
        tempQuad.move_y = 0;
        tempQuad.is_selected = false;
        [self initQuad: &tempQuad];
        myQuads[i] = tempQuad;     
    }
    initialized = true;
 }

- (void) update
{
    //do all updates here
     Test3AppDelegate *appDelegate = (Test3AppDelegate *) [[UIApplication sharedApplication] delegate];
        for (int i =0; i < arrLen ;i++)
    {
        [self updateQuad: &(myQuads[i])];  
        [self checkEdgeCollision: &(myQuads[i])];
        if (wasTouched)
        {
        if ([self isCollision:&(myQuads[i])])
        {
                }
        }
    }
    
    angle = angle + 0.1f;
    if (angle > 360)
    {
        angle=1;
    }
    
    if (wasTouched && org_touch_y > 440.0)
    {
        toggleControls = true;
        if (appDelegate.sliderScale.hidden == YES)
        {
        appDelegate.sliderScale.hidden = NO;
        appDelegate.lblPoints.hidden = NO;
        appDelegate.lblSliderValue.hidden = NO;
        }
        else
        {
            appDelegate.sliderScale.hidden = YES;
            appDelegate.lblPoints.hidden = YES;
            appDelegate.lblSliderValue.hidden = YES;
        }
    }
    
    wasTouched = false;
    
}

- (void)drawView:(UIView *)theView
{
    Test3AppDelegate *appDelegate = (Test3AppDelegate *) [[UIApplication sharedApplication] delegate];
    sliderVal = appDelegate.sliderScale.value;
       NSString *scale = [[NSString alloc] initWithFormat:@"%f", sliderVal];
    appDelegate.lblSliderValue.Text = scale;

    //start GL
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    //background color
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glTranslatef(0, 0, sliderVal - 30);
    
    for (int i =0; i < arrLen ;i++)
    {
        [self drawSquare: &(myQuads[i])];  
    }
    
    //stop gl
    glDisableClientState(GL_VERTEX_ARRAY);    
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);    
    
    //cleanup
    [self update];    
    
}


//********** VIEW DID UNLOAD **********
- (void)viewDidUnload
{
	[super viewDidUnload];
    
	[_lblPoints release];
	_lblPoints = nil;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    wasTouched = true;
    UITouch *theTouch = [touches anyObject];
    Test3AppDelegate *appDelegate = (Test3AppDelegate *) [[UIApplication sharedApplication] delegate];
    sliderVal = appDelegate.sliderScale.value;
     CGPoint currentTouchPosition = [theTouch locationInView: self.view ];
    touch_x = (GLfloat) currentTouchPosition.x;
    touch_y = (GLfloat) currentTouchPosition.y;
    org_touch_x = touch_x;
    org_touch_y = touch_y;
    CGRect rect = self.view.bounds; 
   if (sliderVal > 0)
    {
        //center the coordinates
        GLfloat scale = (rect.size.width / rect.size.height) * size * (30 - sliderVal);
        touch_x = touch_x - (rect.size.width / 2);
        touch_y = touch_y - (rect.size.height / 2);
        touch_x = touch_x * scale;
        touch_y = touch_y * scale;
    }
    else if (sliderVal < 0)
    {
        GLfloat scale = (rect.size.width / rect.size.height) * size * (30 - sliderVal);
        touch_x = touch_x - (rect.size.width / 2);
        touch_y = touch_y - (rect.size.height / 2);
        touch_x = touch_x * scale;
        touch_y = touch_y * scale;
    }
    else
    {
        GLfloat scale = (rect.size.width / rect.size.height) * size * (30 - sliderVal);
        touch_x = touch_x - (rect.size.width / 2);
        touch_y = touch_y - (rect.size.height / 2);
        touch_x = touch_x * scale;
        touch_y = touch_y * scale;        
    }
    
    //debug
    NSString *s = [[NSString alloc] initWithFormat:@"%f,%f", touch_x, touch_y];
    appDelegate.lblPoints.Text = s;
    wasTouched = true;   
  }

-(void)setupView:(GLView*)view
{
	//const GLfloat zNear = 0.01, zFar = 1000.0;//, fieldOfView = 45.0; 
	//GLfloat size; 
	//glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glMatrixMode(GL_PROJECTION); 
    //movement speed
	MOVE_INCREMENT = 0.03;
    CGRect rect = view.bounds; 
     size = .01 * tanf(DEGREES_TO_RADIANS(45.0) / 2.0); 
    
    glFrustumf(-size,                                           // Left
               size,                                           // Right
               -size / (rect.size.width / rect.size.height),    // Bottom
               size / (rect.size.width / rect.size.height),    // Top
               .01,                                          // Near
               1000.0);         
    touch_x = -1000;
    touch_y = -1000;
       glViewport(0, 0, rect.size.width, rect.size.height);
    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity(); 
    
    //initialize all shapes
    arrLen = (sizeof myQuads / sizeof myQuads[0]);

    [self initVertices];

    //load textures
    [self loadTextures:[[NSBundle mainBundle  ] pathForResource:@"circle_sharp" ofType:@"png"] andIndex:0];
    [self loadTextures:[[NSBundle mainBundle  ] pathForResource:@"circle_blur" ofType:@"png"] andIndex: 1];

    
    texCoords[0] =     0.0;
    texCoords[1] =  1.0;
    texCoords[2] =  1.0;
    texCoords[3] = 1.0;
    texCoords[4] = 0.0;
    texCoords[5] =  0.0;
    texCoords[6] = 1.0;
    texCoords[7] = 0.0;
    }

- (void) loadTextures: (NSString*) path andIndex: (int) index {
    
    glGenTextures(1, &texture[index]);
    glBindTexture(GL_TEXTURE_2D, texture[index]);
    
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    
       NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
//    if (image == nil)
  //      return NULL;	
    
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    CGContextTranslateCTM( context, 0, height - height );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    CGContextRelease(context);
    
    free(imageData);
    [image release];
    [texData release];
    
        
}

- (void)dealloc 
{
    
	[_lblPoints release];
    [super dealloc];
}
@end
