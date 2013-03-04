//
//  IceCreamStore.h
//  Blah2
//
//  Created by Joseph on 3/4/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IceCreamStore.h"


@interface IceCreamStore : NSObject


+ (IceCreamStore *) sharedStore;
+ (id) allocWithZone:(NSZone *)zone;

@end
