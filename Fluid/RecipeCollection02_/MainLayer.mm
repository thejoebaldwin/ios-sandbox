#import "MainLayer.h"
#import "Helpers.h"
#import "FluidLayer.h"

enum {
	TAG_RECIPE = 0,
	TAG_RECIPE_NAME = 1,
	TAG_NEXT_BUTTON = 2,
	TAG_PREV_BUTTON = 3,
	TAG_BG = 4
};

enum {
	Z_BG = 0,
	Z_RECIPE = 1,
	Z_HUD = 2
};

@implementation MainLayer

+(id) scene{
	CCScene *scene = [CCScene node];
	
	MainLayer *layer = [MainLayer node];
	
	[scene addChild:layer];

	return scene;
}

-(id) init
{
	if( (self=[super init] )) {

        CCLayer *theLayer = [[[FluidLayer alloc] init ] runRecipe ];
        [self addChild: theLayer];
	
	}
	return self;
}

- (void) dealloc {
	
	[super dealloc];
}





-(void) addBackground {
	CGSize size = [[CCDirector sharedDirector] winSize];
	CCSprite *bg = [CCSprite spriteWithFile:@"blank.png"];
	bg.position = ccp(size.width/2,size.height/2);
	[bg setTextureRect:CGRectMake(0, 0, size.width, size.height)];
	bg.color = ccc3(0,0,0);
	[self addChild:bg z:Z_BG tag:TAG_BG];
}

@end

