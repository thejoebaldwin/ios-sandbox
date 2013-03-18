//
//  FlavorItemStore.h
//  IceCreamShoppe
//
//  Created by Joseph on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlavorItemStore : NSObject
{
    NSMutableArray *_AllItems;

}


+ (FlavorItemStore *) sharedStore;
- (NSMutableArray *) AllItems;
- (void) Load;
- (BOOL) Save;

@end
