//
//  StertItemStore.h
//  sterts
//
//  Created by Joseph Baldwin on 1/24/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StertItem;

@interface StertItemStore : NSObject
{
    NSMutableArray *allItems;
}

-(NSMutableArray *) allItems;
-(StertItem *) createItem;
-(void) addItems:(StertItem * ) addItem;

+ (StertItemStore *) sharedStore;


@end
