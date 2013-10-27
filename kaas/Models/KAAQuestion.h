//
//  KAAQuestion.h
//  kaas
//
//  Created by Jurre Stender on 26/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KAAQuestion : NSObject

@property NSInteger questionID;
@property NSInteger userID;
@property NSString *categoryName;
@property NSString *question;
@property NSString *timeAgoString;
@property NSString *answer;

@end
