//
//  KAAUser.h
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KAAUser : NSObject

@property NSString *username;
@property NSString *emailAddress;
@property NSInteger userId;

+ (KAAUser *)userFromDictionary:(NSDictionary *)dictionary;

@end
