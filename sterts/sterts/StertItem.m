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

- (NSString *) descriptionQuick
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/YY h:mm a"];
    
       
    NSString* createdString = [formatter stringFromDate:created];
    
    NSString *descriptionString = [NSString stringWithFormat:@"%@ %i/%i",
createdString,
                                   hitpoints,
                                   mana
                                   ];
    
    return descriptionString;
}


@end
