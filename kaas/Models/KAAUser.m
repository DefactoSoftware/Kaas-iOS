//
//  KAAUser.m
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAAUser.h"

@implementation KAAUser

+ (KAAUser *)userFromDictionary:(NSDictionary *)dictionary {
    KAAUser *user = [[KAAUser alloc] init];
    
    NSDictionary *userDictionary = dictionary[@"user"];
    
    user.username = userDictionary[@"name"];
    user.emailAddress = userDictionary[@"email"];
    user.userId = [userDictionary[@"id"] integerValue];
    
    return user;
}

@end
