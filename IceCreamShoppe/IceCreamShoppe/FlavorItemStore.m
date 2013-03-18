//
//  FlavorItemStore.m
//  IceCreamShoppe
//
//  Created by Joseph on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "FlavorItemStore.h"
#import "FlavorItem.h"

@implementation FlavorItemStore


+(FlavorItemStore *) sharedStore
{
    static FlavorItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
        
        
            
    }
    return sharedStore;
}


- (BOOL) Save
{
    NSString *path = [self itemArchivePath];
    BOOL success = [NSKeyedArchiver archiveRootObject:_AllItems toFile:path];
    if (success) {
        NSLog(@"Saved Items:%@", _AllItems);
    } else {
        NSLog(@"Could not save Items");
    }
    return success;
}

- (void) Load
{
    NSString *path = [self itemArchivePath];
    _AllItems =  [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (NSString *) itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //get one and only documemnt directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"flavoritemstore.archive"];
    NSLog(@"Archive Path: %@", path);
    return path;
    
}

-(NSMutableArray *) AllItems
{
    if (_AllItems == nil)
    {
        _AllItems = [[NSMutableArray alloc] init];
    
    }
    
    return _AllItems;
}

@end
