//
//  StertItem.m
//  sterts
//
//  Created by Joseph Baldwin on 1/22/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "StertItem.h"

@implementation StertItem


@synthesize hitpoints, mana , created, userID;




- (NSString *) description
{
    NSString *descriptionString = [NSString stringWithFormat:@"Hitpoints:%i, Mana:%i, Created:%@",
                                   hitpoints,
                                   mana,
                                   created];
    
    return descriptionString;
}


@end
