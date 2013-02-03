#import "Recipe.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "DLRenderTexture.h"
#import <Foundation/Foundation.h>
#import "BallContactListener.h"

//32 pixels = 1 Box2D unit of measure
#define PTM_RATIO 32

@interface FluidLayer : Recipe
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    DLRenderTexture *renderTextureB;
    
    CCRenderTexture *blockTexture;
    
    CCSpriteBatchNode *batch;
    CCSpriteBatchNode *blocks;
    int touchCounter;
    BOOL touchHappening;
    int circleCount;
    BOOL staticMode;
    BOOL jointsMode;

    BOOL isDebug;


    NSMutableArray *arrSprites;
    BallContactListener *_contactListener;
}

-(CCLayer*) runRecipe;
-(void) addLevelBoundaries;
-(void) step: (ccTime) dt;
-(void) draw;
-(void) addNewSpriteWithCoords:(CGPoint)p;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) clearAll;
- (void) toggleMode;
- (void) toggleDebug;

@end

@implementation FluidLayer


-(void) toggleMode
{
    if (staticMode) {
        staticMode = NO;
    } else
    {
        staticMode = YES;
    }
}

-(void) clearJoints:(b2JointEdge *) edge
{
    while (edge != NULL) {
        world->DestroyJoint(edge->joint);
        if (edge->prev != NULL) {
            world->DestroyJoint(edge->prev->joint);
        }
        edge = edge->next;
    }

}


-(void) toggleJoints{
    if (jointsMode) {
        jointsMode = NO;
        
        for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
        {
            [self clearJoints:b->GetJointList()];
            [self clearJoints:b->GetJointList()];
        }

        
    } else
    {
        jointsMode = YES;
    }
}

-(void) toggleDebug
{
if (isDebug) {
        isDebug = NO;
        for (int i = 0; i < [arrSprites count]; i++) {
            //[ [arrSprites objectAtIndex:i] setVisible:YES];
                        
            CCAction *fadeIn = [CCFadeIn actionWithDuration:0.5];
          
            [[arrSprites objectAtIndex:i] setVisible:YES];
            [[arrSprites objectAtIndex:i] runAction: fadeIn];
            }
        }
        else {
            isDebug = YES;
            for (int i = 0; i < [arrSprites count]; i++) {
                // [ [arrSprites objectAtIndex:i] setVisible:NO];
                //this works, but rotate in tick method overrides it.
                //CCAction *rotate  = [CCRotateBy actionWithDuration:0.5 angle:90];
                CCAction *fadeOut = [CCFadeOut  actionWithDuration:0.5];
                [[arrSprites objectAtIndex:i] runAction: fadeOut];
            }
    }
    
    [renderTextureB clear:0.0 g:0.0 b:0.0 a:0.0];
    [blockTexture clear:0.0 g:0.0 b:0.0 a:0.0];
}

-(CCLayer*) runRecipe {
	[super runRecipe];
	touchCounter = 0;
    touchHappening = NO;
	//Enable touches
	self.isTouchEnabled = YES;
    jointsMode = NO;
    staticMode = NO;
    self.isAccelerometerEnabled = YES;
	/* Box2D Initialization */
	isDebug = NO;
	//Set gravity
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	
	//Initialize world
	bool doSleep = YES;
	world = new b2World(gravity, doSleep);
	world->SetContinuousPhysics(YES);
	
    _contactListener = new BallContactListener();
    world->SetContactListener(_contactListener);
    
    arrSprites = [[NSMutableArray alloc] init];
    
	//Initialize debug drawing
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
    flags += b2DebugDraw::e_jointBit;
	m_debugDraw->SetFlags(flags);	
	
	//Create level boundaries
	[self addLevelBoundaries];
		
	//Add batch node for circle creation
	batch = [[CCSpriteBatchNode batchNodeWithFile:@"BlurryBlob.png" capacity:300] retain];
    blocks = [[CCSpriteBatchNode batchNodeWithFile:@"brick.png" capacity:300] retain];
    
    [self addChild:batch];
    [self addChild:blocks];
	
	//Add a new block
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	//[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];

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
    sprite.visible = !isDebug;
    sprite.tag = 0;
    

    
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
    [arrSprites addObject:sprite];

    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
    
	// Define another box shape for our dynamic body.
	b2CircleShape blob;
    blob.m_radius = (sprite.contentSize.width/8)/PTM_RATIO;
    
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;

	fixtureDef.shape = &blob;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.0f;
    fixtureDef.restitution = 0.3f;
	body->CreateFixture(&fixtureDef);
}


-(void) addNewStaticWithCoords:(CGPoint)p withVisible:(BOOL) show;
{
    
	CCSprite *sprite = [CCSprite spriteWithBatchNode:blocks rect:CGRectMake(0.0, 0.0, 64.0, 64.0)];
    [sprite setScale:1.0];
    //[sprite setScale:1.5];
	[blocks addChild:sprite];
    
    [arrSprites addObject:sprite];

    sprite.visible = !isDebug;
	sprite.position = ccp( p.x, p.y);
    sprite.tag = 1;
    
    
	// Define the static body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
 
    
    b2PolygonShape staticBox;
	staticBox.SetAsBox(1.0f, 1.0f);//These are mid points for our 1m box
    
	// Define the static body fixture.
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
    
    
    if(blockTexture==nil){
        blockTexture = [CCRenderTexture renderTextureWithWidth:screenSize.width height:screenSize.height];
        blockTexture.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:blockTexture];
    }
    
    
    glDisable(GL_ALPHA_TEST);
    
    if ( [[batch children] count] > 0 ) {
        [renderTextureB clear:0.0 g:0.0 b:0.0 a:0.0];
        [renderTextureB begin];
        [batch visit];
        [renderTextureB end];
    }
    

    
    [blockTexture clear:0.0 g:0.0 b:0.0 a:0.0];
    [blockTexture begin];
    [blocks visit];
    [blockTexture end];
  
    
}

-(void) draw
{
    if (isDebug){
     
        glDisable(GL_TEXTURE_2D);
//        glDisable(GL_TEXTURE);
        glDisableClientState(GL_COLOR_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
     
        world->DrawDebugData();


        glEnable(GL_TEXTURE_2D);
        glEnableClientState(GL_COLOR_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    else {
        [self drawLiquid];
    }
}


- (void) clearAll
{
    int bodyCount = 0;
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        [self clearJoints:b->GetJointList()];
        [self clearJoints:b->GetJointList()];

        world->DestroyBody(b);
        bodyCount++;
    }
    
    for (int i = [[batch children] count] - 1; i >= 0; i--) {
        [batch removeChildAtIndex:i cleanup:YES];
    }
    
    for (int i = [[blocks children] count] - 1; i >= 0; i--) {
        [blocks removeChildAtIndex:i cleanup:YES];
    }
    
    
    [arrSprites removeAllObjects];
    
    
     circleCount = 0;
    
    [self addLevelBoundaries];
    touchCounter = 0;
    touchHappening = NO;

    
    [renderTextureB clear:0.0 g:0.0 b:0.0 a:0.0];
    [blockTexture clear:0.0 g:0.0 b:0.0 a:0.0];
    
    NSLog(@"Removed all shapes");
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
    
	//Iterate over the bodies in the physics world and update
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}

    
    for (b2Joint *b = world->GetJointList(); b; b=b->GetNext()) {
        b2Body *bodyA = b->GetBodyA();
        b2Body *bodyB = b->GetBodyB();
        
        if (b2Distance(bodyA->GetPosition(), bodyB->GetPosition()) > 2.5f)
        {
            world->DestroyJoint(b);
        }
      
        
    }
    
    if (jointsMode) {
        std::vector<MyContact>::iterator pos;
        for (pos = _contactListener->_contacts.begin(); pos != _contactListener->_contacts.end(); ++pos) {
            MyContact contact = *pos;
        
            b2Fixture *tempB = contact.fixtureB;
            b2Fixture *tempA = contact.fixtureA;
        
            CCSprite *tempSpriteB = (CCSprite *) tempB->GetBody()->GetUserData();
            CCSprite *tempSpriteA = (CCSprite *) tempA->GetBody()->GetUserData();
        
            if (tempSpriteA != NULL && tempSpriteB != NULL)
            {
                //if both are circles
                if (tempSpriteA.tag == 0 && tempSpriteB.tag == 0)
                {
                    //NSLog(@"%@", tempSpriteA);
                    //distance joint
                    //b2DistanceJointDef *tempJoint = new b2DistanceJointDef();
                    //tempJoint->Initialize(tempA->GetBody(), tempB->GetBody(), tempA->GetBody()->GetWorldCenter(), tempB->GetBody()->GetWorldCenter());
                    //world->CreateJoint(tempJoint);
                
                    //rope joint
                    b2JointEdge *edge =    tempA->GetBody()->GetJointList();
                    //only allow two joints per body
                    BOOL okToAdd = FALSE;
                    if (edge == NULL) {
                        okToAdd = TRUE;
                    }
                    else {
                        if (edge->next == NULL && edge->prev == NULL) {
                            okToAdd = TRUE;
                        }
                    }

                    if (okToAdd) {
                        b2RopeJointDef *tempJoint = new b2RopeJointDef();
                        tempJoint->bodyA = tempA->GetBody();
                        tempJoint->bodyB = tempB->GetBody();
                        tempJoint->maxLength = 0.05f;
                        tempJoint->collideConnected = FALSE;
                        world->CreateJoint(tempJoint);
                    }
                }
            }
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
                [self addNewStaticWithCoords:location withVisible:YES];
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
    //touchHappening = YES;
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
