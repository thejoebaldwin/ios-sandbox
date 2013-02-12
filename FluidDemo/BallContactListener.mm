//
//  BallContactListener.m
//  Fluid
//
//  Created by Joseph Baldwin on 2/2/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//



#import "BallContactListener.h"



BallContactListener::BallContactListener() : _contacts()
{
    
}


void BallContactListener::BeginContact(b2Contact *contact) {
    
    
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
}


void BallContactListener::EndContact(b2Contact *contact) {
    MyContact myContact = {contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContact>::iterator pos;
    
    pos =  std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void BallContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold)
{
    
}

void BallContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse)
{
    
}