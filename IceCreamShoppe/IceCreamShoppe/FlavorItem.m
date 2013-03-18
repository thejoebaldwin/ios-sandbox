//
//  FlavorItem.m
//  IceCreamShoppe
//
//  Created by Joseph on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "FlavorItem.h"

@implementation FlavorItem


@synthesize Name;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super init];
    
    if (self) {
        [self setName:[aDecoder decodeObjectForKey:@"Name"]];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:Name forKey:@"Name"];

}

- (id) initWithName:(NSString *)flavorName
{
    self = [super init];
    if (self) {
    
        [self setName:flavorName];
    }
    return self;
}

@end
