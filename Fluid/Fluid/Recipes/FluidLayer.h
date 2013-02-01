#import "Recipe.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "DLRenderTexture.h"
#import <Foundation/Foundation.h>

//32 pixels = 1 Box2D unit of measure
#define PTM_RATIO 32

@interface FluidLayer : Recipe
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    DLRenderTexture *renderTextureB;
    CCSpriteBatchNode *batch;
    int touchCounter;
    BOOL touchHappening;
    int circleCount;
    BOOL staticMode;
}

-(CCLayer*) runRecipe;
-(void) addLevelBoundaries;
-(void) step: (ccTime) dt;
-(void) draw;
-(void) addNewSpriteWithCoords:(CGPoint)p;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@implementation FluidLayer

-(CCLayer*) runRecipe {
	[super runRecipe];
	touchCounter = 0;
    touchHappening = NO;
	//Enable touches
	self.isTouchEnabled = YES;
    staticMode = YES;
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
	[self schedule:@selector(tick:)];
			
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
    //[sprite setScale:0.7];
    [sprite setScale:1.5];
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
    blob.m_radius = (sprite.contentSize.width/50)/PTM_RATIO;
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &blob;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.0f;
    fixtureDef.restitution = 0.4f;
	body->CreateFixture(&fixtureDef);
}


-(void) addNewStaticWithCoords:(CGPoint)p
{
    
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0.0, 0.0, 90.0, 90.0)];
    //[sprite setScale:0.7];
    [sprite setScale:1.5];
	[batch addChild:sprite];
    
	sprite.position = ccp( p.x, p.y);
    
	// Define the static body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
    
	// Define another box shape for our dynamic body.
	b2CircleShape blob;
    blob.m_radius = (sprite.contentSize.width/50)/PTM_RATIO;
    
    
    b2PolygonShape staticBox;
	staticBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box

    
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &staticBox;
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
    
    if ( [[batch children] count] > 0 ) {
    
    [renderTextureB clear:0.0 g:0.0 b:0.0 a:0.0];
    [renderTextureB begin];
    [batch visit];
    [renderTextureB end];
    }
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



-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
    
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
    if (touchHappening) {
        touchCounter++;
        if (touchCounter > 100)
        {
            
            staticMode = NO;
            /*
            
            
            //[batch removeAllChildrenWithCleanup:NO];
            
            
            for (int i = [[batch children] count] - 1; i >= 0; i--) {
                [batch removeChildAtIndex:i cleanup:YES];
                
                


                
            }
            
            int bodyCount = 0;
                            for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
                            {
                                //if (bodyCount > 0)
                                //{
                                    world->DestroyBody(b);
                                //}
                                bodyCount++;
            
                            
                        
                            }
            circleCount = 0;
            
            [self addLevelBoundaries];
             touchCounter = 0;
            touchHappening = NO;
            NSLog(@"REmoving all");
             */
        }
    }
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
    if (circleCount < 100) {
    
        for( UITouch *touch in touches ) {
            CGPoint location = [touch locationInView: [touch view]];
            location = [[CCDirector sharedDirector] convertToGL: location];
            if (staticMode) {
                [self addNewStaticWithCoords:location];
            } else {
            [self addNewSpriteWithCoords: location];
            }
            circleCount++;
        }
    }
    touchHappening = NO;
    touchCounter = 0;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchHappening = YES;
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
