//
//  IceCreamStore.m
//  Blah2
//
//  Created by Joseph on 3/4/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import "IceCreamStore.h"
#import "IceCreamFlavor.h"

@implementation IceCreamStore

+ (IceCreamStore *) sharedStore
{
    static IceCreamStore * sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

@end
