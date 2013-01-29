//
//  StertItemStore.h
//  sterts
//
//  Created by Joseph Baldwin on 1/24/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class StertItem;

@interface StertItemStore : NSObject
{
    
    NSMutableArray *allItems;
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSString *allStertsURL;
    NSString *postStertURL;
    NSString *removeStertURL;
    NSString *authURL;
    NSString *authToken;
    UIViewController *owner;
    NSString *loadCompleteSelector;
 
}

- (void) loadSterts;
- (void) loadUserFromArchive;
- (BOOL) isLoggedIn;
- (NSMutableArray *) allItems;
- (StertItem *) createItem;
- (NSString *) authToken;
- (void) addItems:(StertItem * ) addItem;
- (void) insertItem:(StertItem * ) insertItem;
- (void) addItemWithHitpoints:(int) hitpoints withMana:(int) mana;
- (void) loadWithOwner:(UIViewController *) withOwner completionSelector:(NSString*) withSelector;
- (void) removeItem:(StertItem *) s;
- (void) getAuthToken:(NSString *) username withPassword:(NSString *) password withOwner:(UIViewController *) thisOwner completionSelector:(NSString*) withSelector;
- (NSString *) itemArchivePath;
+ (StertItemStore *) sharedStore;
- (BOOL) saveChanges;
@property (nonatomic, retain) User *CurrentUser;

@end
