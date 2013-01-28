//
//  User.h
//  Sterts
//
//  Created by Joseph on 1/28/13.
//  Copyright (c) 2013 Humboldt Technology Group, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>
{
    
}

@property (nonatomic, retain) NSString* username;

@property (nonatomic, retain) NSString* password;

@property (nonatomic, retain) NSString* firstName;

@property (nonatomic, retain) NSString* lastName;

@property (nonatomic, retain) NSString* email;

@property (nonatomic, retain) NSString* authToken;

@property (nonatomic, retain) NSDate* authTokenExpires;

@end
