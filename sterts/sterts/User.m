//
//  User.m
//  Sterts
//
//  Created by Joseph on 1/28/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username,password,firstName,lastName,email,authToken,authTokenExpires;

- (id) init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
    
}


- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:username forKey:@"username"];
    //[aCoder encodeObject:password forKey:@"password"];
    //[aCoder encodeObject:firstName forKey:@"firstName"];
    //[aCoder encodeObject:lastName forKey:@"lastName"];
    //[aCoder encodeObject:email forKey:@"email"];
    [aCoder encodeObject:authToken forKey:@"authToken"];
    //[aCoder encodeObject:authTokenExpires forKey:@"authTokenExpires"];
    NSLog(@"user getting encoded");
    
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
       NSLog(@"init with coder called");
    self = [super init];
 
    if (self) {
        [self setUsername:[aDecoder decodeObjectForKey:@"username"]];
        //[self setPassword:[aDecoder decodeObjectForKey:@"password"]];
        //[self setFirstName:[aDecoder decodeObjectForKey:@"firstName"]];
        //[self setLastName:[aDecoder decodeObjectForKey:@"lastName"]];
       // [self setEmail:[aDecoder decodeObjectForKey:@"email"]];
        [self setAuthToken:[aDecoder decodeObjectForKey:@"authToken"]];
        //[self setAuthTokenExpires:[aDecoder decodeObjectForKey:@"authTokenExpires"]];
        NSLog(@"user getting decoded");
    }
    return self;
}


- (NSString *) description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Username:%@ AuthToken:%@",
                                   username,
                                   authToken];
    
    return descriptionString;
}

@end
