#import "Recipe.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "DLRenderTexture.h"

//32 pixels = 1 Box2D unit of measure
#define PTM_RATIO 32

@interface Ch4_BasicSetup : Recipe
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    DLRenderTexture *renderTextureB;
CCSpriteBatchNode *batch;
}

-(CCLayer*) runRecipe;
-(void) addLevelBoundaries;
-(void) step: (ccTime) dt;
-(void) draw;
-(void) addNewSpriteWithCoords:(CGPoint)p;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@implementation Ch4_BasicSetup

-(CCLayer*) runRecipe {
	[super runRecipe];
	
	//Enable touches
	self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;
	/* Box2D Initialization */
	
	//Set gravity
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	
	//Initialize world
	bool doSleep = YES;
	world = new b2World(gravity, doSleep);
	world->SetContinuousPhysics(YES);
	
	//Initialize debug drawing
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	m_debugDraw->SetFlags(flags);	
	
	//Create level boundaries
	[self addLevelBoundaries];
		
	//Add batch node for block creation
	batch = [[CCSpriteBatchNode batchNodeWithFile:@"BlurryBlob.png" capacity:300] retain];
	
    [self addChild:batch];
	
	//Add a new block
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];

	//Schedule step method
	[self schedule:@selector(step:)];
			
	return self;
}

/* Adds a polygonal box around the screen */
-(void) addLevelBoundaries {
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0);
	b2Body *body = world->CreateBody(&groundBodyDef);

	b2PolygonShape groundBox;		
		
	groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
	body->CreateFixture(&groundBox,0);
		
	groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
	body->CreateFixture(&groundBox,0);
		
	groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
	body->CreateFixture(&groundBox,0);
		
	groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
	body->CreateFixture(&groundBox,0);
}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
    
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0.0, 0.0, 90.0, 90.0)];
    [sprite setScale:0.7];
	[batch addChild:sprite];
    
	sprite.position = ccp( p.x, p.y);
    
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
    
	// Define another box shape for our dynamic body.
	b2CircleShape blob;
    blob.m_radius = (sprite.contentSize.width/20)/PTM_RATIO;
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &blob;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.0f;
    fixtureDef.restitution = 0.4f;
	body->CreateFixture(&fixtureDef);
}



- (void)drawLiquid{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    if(renderTextureB==nil){
        renderTextureB = [DLRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
        renderTextureB.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:renderTextureB];
    }
    glDisable(GL_ALPHA_TEST);
    
    [renderTextureB clear:0.0 g:0.0 b:0.0 a:0.0];
    [renderTextureB begin];
    [batch visit];
    [renderTextureB end];
}


/* Draw debug data */
-(void) draw
{
	
    /*
    glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
    
    
    
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
     */
[self drawLiquid];
}

/* Update graphical positions using physical positions */
-(void) step: (ccTime) dt
{	
	int32 velocityIterations = 8;
	int32 positionIterations = 3;
	
	world->Step(dt, velocityIterations, positionIterations);
	
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			CCSprite *obj = (CCSprite*)b->GetUserData();
			obj.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			obj.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}

/* Tap to add a block */
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
		[self addNewSpriteWithCoords: location];
        
        
        
        
	}
}



- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	static float prevX=0, prevY=0;
    
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
    
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
    
	prevX = accelX;
	prevY = accelY;
    
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 15
	b2Vec2 gravity( accelX * 15, accelY * 15);
    
	world->SetGravity( gravity );
}

@end
