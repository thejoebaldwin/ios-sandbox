//
//  FlavorItem.h
//  IceCreamShoppe
//
//  Created by Joseph on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlavorItem : NSObject <NSCoding>

@property (nonatomic, retain) NSString *Name;

-(id) initWithName: (NSString *) flavorName;

@end
