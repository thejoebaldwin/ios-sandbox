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
    CCSpriteBatchNode *leftTriangle;
    CCSpriteBatchNode *rightTriangle;
    
    int touchCounter;
    BOOL touchHappening;
    int circleCount;
    BOOL staticMode;
    BOOL jointsMode;

    BOOL isDebug;
    BOOL touchMode;
    
    BOOL cancelTouch;
    

    NSMutableArray *arrSprites;
    BallContactListener *_contactListener;
  
    
    b2Body *selectedBody;

     enum SPRITE_TYPE : NSInteger {
        WATER,
        BRICK,
        LEFT_TRIANGLE,
        RIGHT_TRIANGLE
    };
    
    

    SPRITE_TYPE currentShape;

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


-(b2Body *) getTopTouchBody:(b2Vec2) location
{
    b2Body *touchObject = NULL;
    int zOrder =0;
    for (b2Body *b = world->GetBodyList(); b; b = b->GetNext())
    {
        b2Fixture *f = b->GetFixtureList();
        BOOL isInSize = f->TestPoint(location);
        CCSprite *sprite = (CCSprite *) b->GetUserData();
        if (isInSize) {
            if (sprite.zOrder >= zOrder && sprite.tag != WATER) {
                zOrder = sprite.zOrder;
                touchObject = b;
            }
        }
    }
    return touchObject;
}


-(void) toggleMode
{
    if (staticMode) {
        staticMode = NO;
    } else
    {
        staticMode = YES;
    }
    currentShape++;
    if (currentShape > 3) {
        currentShape = WATER;
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
    }
    else {
        jointsMode = YES;
    }
}

-(void) toggleTouch
{
    if (touchMode) {
        
        touchMode = NO;
        
       }
    else {
        touchMode = YES;
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
    touchMode = NO;
	//Set gravity
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	
    currentShape = BRICK;
    
    
    cancelTouch = FALSE;
    
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
    blocks = [[CCSpriteBatchNode batchNodeWithFile:@"brick.png"  capacity:300 ] retain];
    leftTriangle = [[CCSpriteBatchNode batchNodeWithFile:@"left_triangle.png"  capacity:300 ] retain];
    rightTriangle = [[CCSpriteBatchNode batchNodeWithFile:@"right_triangle.png"  capacity:300 ] retain];

    
    [self addChild:batch];
    [self addChild:blocks];
    [self addChild:rightTriangle];
    [self addChild:leftTriangle];
	
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
    sprite.tag = WATER;
   
    
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



-(void) addNewStaticWithCoords:(CGPoint)p withVisible:(BOOL) show withSpriteType:(SPRITE_TYPE) type
{
    //this was 64 when square. need to be a power of 2??
    
	CCSprite *sprite;
    b2BodyDef bodyDef;
    switch (type) {
        case WATER: {
            sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0.0, 0.0, 90.0, 90.0)];
            [sprite setScale:1.5];
            [batch addChild:sprite];
            bodyDef.type = b2_dynamicBody;
        }
            break;
        case LEFT_TRIANGLE: {
            sprite = [CCSprite spriteWithBatchNode:leftTriangle rect:CGRectMake(0.0, 0.0, 64, 64)];
            [sprite setScale:1.0];
            [leftTriangle addChild:sprite];
            bodyDef.type = b2_staticBody;
            sprite.anchorPoint  = ccp(0,0);

        }
            break;
        case RIGHT_TRIANGLE: {
            sprite = [CCSprite spriteWithBatchNode:rightTriangle rect:CGRectMake(0.0, 0.0, 64, 64)];
            [sprite setScale:1.0];
            [rightTriangle addChild:sprite];
            bodyDef.type = b2_staticBody;
            sprite.anchorPoint  = ccp(0,0);

        }

            break;
        case BRICK: {
            sprite = [CCSprite spriteWithBatchNode:blocks rect:CGRectMake(0.0, 0.0, 64, 64)];
            [sprite setScale:1.0];
            [blocks addChild:sprite];
            bodyDef.type = b2_staticBody;
        }
        default:
            break;

    }
       
    [arrSprites addObject:sprite];
    sprite.visible = !isDebug;
	sprite.position = ccp( p.x, p.y);
    sprite.tag = type;

    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);

  	b2FixtureDef fixtureDef;
    
    switch (type) {
        case WATER: {
            // Define another box shape for our dynamic body.
            b2CircleShape blob;
            blob.m_radius = (sprite.contentSize.width/8)/PTM_RATIO;
            fixtureDef.shape = &blob;
        }
            break;
        case LEFT_TRIANGLE: {
            b2Vec2 trsVertices[3];
            trsVertices[0].Set(0.0f, 0.0f );
            trsVertices[1].Set(64.0f /PTM_RATIO, 0.0f);
            trsVertices[2].Set(0.0f /PTM_RATIO, 64.0f /PTM_RATIO);
            b2PolygonShape trsShape;
            int32 trsVert = 3;
            trsShape.Set(trsVertices, trsVert);
            fixtureDef.shape = &trsShape;
        }
            break;
        case RIGHT_TRIANGLE: {
            b2Vec2 trsVertices[3];
            trsVertices[0].Set(0.0f, 0.0f );
            trsVertices[1].Set(64.0f /PTM_RATIO, 0.0f);
            trsVertices[2].Set(64.0f /PTM_RATIO, 64.0f /PTM_RATIO);
            b2PolygonShape trsShape;
            int32 trsVert = 3;
            trsShape.Set(trsVertices, trsVert);
            fixtureDef.shape = &trsShape;
        }
            break;
        case BRICK: {
            b2PolygonShape staticBox;
            staticBox.SetAsBox(1.0f, 1.0f);//These are mid points for our 1m box
            fixtureDef.shape = &staticBox;
        }
            
            
        default:
            break;
    }
    
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.0f;
    fixtureDef.restitution = 0.4f;
	body->CreateFixture(&fixtureDef);
}

-(void) addNewStaticWithCoords:(CGPoint)p withVisible:(BOOL) show;
{
    
    
    //this was 64 when square. need to be a power of 2??
    
	CCSprite *sprite = [CCSprite spriteWithBatchNode:blocks rect:CGRectMake(0.0, 0.0, 64, 64)];

    [sprite setScale:1.0];
    //[sprite setScale:1.5];
	[blocks addChild:sprite];
    
    [arrSprites addObject:sprite];

    sprite.visible = !isDebug;
	sprite.position = ccp( p.x, p.y);
    sprite.tag = 1;
    //not needed for square
    sprite.anchorPoint  = ccp(0,0);

    
	// Define the static body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_staticBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
 
    b2Vec2 trsVertices[3];
    
 
    trsVertices[0].Set(0.0f, 0.0f );
    trsVertices[1].Set(64.0f /PTM_RATIO, 0.0f);
    trsVertices[2].Set(64.0f /PTM_RATIO, 64.0f /PTM_RATIO);
   
   
    
    
    
    b2PolygonShape trsShape;

    int32 trsVert = 3;
    trsShape.Set(trsVertices, trsVert);

    
    b2PolygonShape staticBox;
	staticBox.SetAsBox(1.0f, 1.0f);//These are mid points for our 1m box
    
    
	// Define the static body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &trsShape;
    
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
    
    for (int i = [[leftTriangle children] count] - 1; i >= 0; i--) {
        [leftTriangle removeChildAtIndex:i cleanup:YES];
    }
    
    for (int i = [[rightTriangle children] count] - 1; i >= 0; i--) {
        [rightTriangle removeChildAtIndex:i cleanup:YES];
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
    
    if (touchHappening) {
        
        touchCounter++;
        if (touchCounter > 30) {
            
                       touchCounter = 0;
            if (selectedBody != NULL) {
            //NSLog(@"Something was touched-->%i", sprite.tag );
                CCSprite *sprite = (CCSprite *) selectedBody->GetUserData() ;
            [sprite setVisible:NO];
            world->DestroyBody(selectedBody);
            [arrSprites removeObjectIdenticalTo:sprite];
                selectedBody = NULL;
                cancelTouch = TRUE;
            }

            
        }
        
    }
    
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

    //destroy if jointed objects are too far from each other
    for (b2Joint *b = world->GetJointList(); b; b=b->GetNext()) {
        b2Body *bodyA = b->GetBodyA();
        b2Body *bodyB = b->GetBodyB();
        
        if (b2Distance(bodyA->GetPosition(), bodyB->GetPosition()) > 2.5f)
        {
            world->DestroyJoint(b);
        }
    }
    
    //if joints turned on
    if (jointsMode) {
        
        
        //listen for collision, then attach rope joint
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



/* Tap to add a block */
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
    if ( cancelTouch) {
        touchHappening = FALSE;
        touchCounter = 0;
        cancelTouch = FALSE;
    }
    else
    {
        touchHappening = FALSE;
        touchCounter = 0;

    
    if (touchMode) {
        
            for( UITouch *touch in touches ) {
                CGPoint location = [touch locationInView: [touch view]];

                
                location = [[CCDirector sharedDirector] convertToGL: location];
                b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
                
                b2Body *touchObject = [self getTopTouchBody:(locationWorld)];
                if (touchObject != NULL)
                {
                    CCSprite *sprite = (CCSprite *) touchObject->GetUserData();
                    if (sprite != NULL)
                    {
                        NSLog(@"Something was touched-->%i", sprite.tag );
                        [sprite setVisible:NO];
                        world->DestroyBody(touchObject);
                        [arrSprites removeObjectIdenticalTo:sprite];
                        [blockTexture clear:0.0 g:0.0 b:0.0 a:0.0];

                    }
                    
                
                }
            }
    }
    
    else
    {
        
        
        if (circleCount < 100) {
            
            for( UITouch *touch in touches ) {
                CGPoint location = [touch locationInView: [touch view]];
                location = [[CCDirector sharedDirector] convertToGL: location];
                //if (staticMode) {
                    [self addNewStaticWithCoords:location withVisible:YES withSpriteType:currentShape];
                //} else {
                   // [self addNewSpriteWithCoords: location];
                //}
                circleCount++;
            }
        }

    }
    }
       
    
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchHappening = YES;
    touchCounter = 0;
    for( UITouch *touch in touches ) {
        CGPoint location = [touch locationInView: [touch view]];
        
        
        location = [[CCDirector sharedDirector] convertToGL: location];
        b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        
        b2Body *touchObject = [self getTopTouchBody:(locationWorld)];
        if (touchObject != NULL)
        {
            CCSprite *sprite = (CCSprite *) touchObject->GetUserData();
            if (sprite != NULL)
            {
                if (sprite.tag != WATER) {
                    selectedBody = touchObject;
                }
                
                /*
                NSLog(@"Something was touched-->%i", sprite.tag );
                [sprite setVisible:NO];
                world->DestroyBody(touchObject);
                [arrSprites removeObjectIdenticalTo:sprite];
                [blockTexture clear:0.0 g:0.0 b:0.0 a:0.0];
                */
            }
            
            
        }
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
