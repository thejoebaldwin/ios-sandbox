//
//  StertItemStore.m
//  sterts
//
//  Created by Joseph Baldwin on 1/24/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import "StertItemStore.h"
#import "StertItem.h";

@implementation StertItemStore

- (id) init
{
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *) allItems
{
    return allItems;
    
}


-(StertItem *) createItem
{
    StertItem *s = [[StertItem alloc] init];
    [allItems addObject:s];
    return s;
}


- (void) addItems:(StertItem *) addItem
{
    [allItems addObject:addItem];
}

+(StertItemStore *) sharedStore
{
    static StertItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
    
}


+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

@end
