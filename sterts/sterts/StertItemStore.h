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
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSString *allStertsURL;
    NSString *postStertURL;
    NSString *removeStertURL;

    UIViewController *owner;
    NSString *loadCompleteSelector;
}

- (NSMutableArray *) allItems;
- (StertItem *) createItem;
- (void) addItems:(StertItem * ) addItem;
- (void) addItemWithHitpoints:(int) hitpoints withMana:(int) mana;
- (void) loadWithOwner:(UIViewController *) withOwner withSelector:(NSString*) withSelector;
- (void) removeItem:(StertItem *) s;
+ (StertItemStore *) sharedStore;


@end
