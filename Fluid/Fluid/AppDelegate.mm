#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "MainLayer.h"
#import "RootViewController.h"
#import "SynthesizeSingleton.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation AppDelegate

SYNTHESIZE_SINGLETON_FOR_CLASS(AppDelegate);

@synthesize window, viewController;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	CCDirector *director = [CCDirector sharedDirector];
	//	CGSize size = [director winSize];
	//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//	sprite.position = ccp(size.width/2, size.height/2);
	//	sprite.rotation = -90;
	//	[sprite visit];
	//	[[director openGLView] swapBuffers];
	//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGBA8	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	[glView setMultipleTouchEnabled:YES];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
    
    header = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil ] lastObject];;
    
  
    [[self ClearButton] addTarget:self action:@selector(ClearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  
    [[self ToggleButton] setTitle:@"Water" forState:UIControlStateNormal];
    [[self ToggleButton] addTarget:self action:@selector(ToggleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[self DebugButton] addTarget:self action:@selector(DebugButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [glView addSubview:header];
    
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
    
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
    

    s =  [MainLayer scene];

    
    [[self window] setRootViewController:viewController];
    
	[[CCDirector sharedDirector] runWithScene:  s];
}

- (UIButton *) ClearButton
{
    UIButton *tempButton = [[header  subviews] objectAtIndex:0];
    return tempButton;
}

- (UIButton *) DebugButton
{
    UIButton *tempButton = [[header  subviews] objectAtIndex:2];
    return tempButton;

}

- (UIButton *) ToggleButton
{
    UIButton *tempButton = [[header  subviews] objectAtIndex:1];
    return tempButton;
}

- (CALayer *) FluidLayer
{
    CCScene *c = [[CCDirector sharedDirector] runningScene];
    MainLayer *l = (MainLayer *) [[c children] lastObject];
    
    CALayer *f = [[l children] lastObject];
    return f;
}


- (IBAction)ClearButtonClick:(id)sender
{
    [[self FluidLayer] performSelector:@selector(clearAll)];
}


- (IBAction)ToggleButtonClick:(id)sender
{
    
    
    //[[self ToggleButton] setTitle:@"Toggle" forState:UIControlStateNormal];
    if ([[[[self ToggleButton] titleLabel] text] isEqualToString:@"Water"]) {
         [[self ToggleButton] setTitle:@"Brick" forState:UIControlStateNormal];
    }
    else {
         [[self ToggleButton] setTitle:@"Water" forState:UIControlStateNormal];
    }
    
    [[self FluidLayer] performSelector:@selector(toggleMode)];
}

- (IBAction)DebugButtonClick:(id)sender
{
    [[self FluidLayer] performSelector:@selector(toggleDebug)];
}



- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
	
	//Pause the music player if its playing
	if(![[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"]){
		MPMusicPlayerController	*musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
		if(musicPlayer.playbackState == MPMusicPlaybackStatePlaying){
			[musicPlayer pause];
		}
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
/*	
	//Play the music play if its paused
	if(![[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"]){
		MPMusicPlayerController	*musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
		if(musicPlayer.playbackState == MPMusicPlaybackStatePaused){
			[musicPlayer play];
		}
	}
*/
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
