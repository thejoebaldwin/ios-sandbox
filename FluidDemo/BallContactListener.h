//
//  BallContactListener.h
//  Fluid
//
//  Created by Joseph Baldwin on 2/2/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import <vector>
#import <algorithm>


struct MyContact {
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
    bool operator==(const MyContact& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
    
};

class BallContactListener : public b2ContactListener
{
public:
    
    std::vector<MyContact> _contacts;
    BallContactListener();
    
    virtual void BeginContact(b2Contact *contact);
    virtual void EndContact(b2Contact *contact);
    virtual void PreSolve(b2Contact* contact, const b2Manifold *oldManifold);
    virtual void PostSolve(b2Contact *contact, const b2ContactImpulse *impulse);
    
};
