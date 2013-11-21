#import "KAAAPIClient.h"
#import "KAAQuestion.h"

static NSString *const KAAPIBaseURLString = @"http://kaas.herokuapp.com/api/v1";
static NSString *const KAAAPIQuestionsEndpoint = @"/questions";
static NSString *const KAAAPIAnswerablesEndpointFormat = @"/users/%d/answerables";
static NSString *const KAAAPIUsersEndpoint = @"/users";
static NSString *const KAAPISessionsEndpoint = @"/sessions";
static NSString *const KAAPICategoriesEndpoint = @"/user_categories";
static NSString *const KAAPIAllCategoriesEndpoint = @"/categories";

@implementation KAAAPIClient

+ (instancetype)sharedClient {
    static KAAAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:KAAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (void)getAnswerablesForUserID:(NSInteger)userID completion:(void (^)(BOOL, NSArray*))completion {
    NSString *answerablesURL = [NSString stringWithFormat:KAAAPIAnswerablesEndpointFormat, userID];
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", KAAPIBaseURLString, answerablesURL];
    
    [self GET:endpoint parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSArray *answerableDicts = responseObject[@"answerables"];
          NSMutableArray *answerables = [[NSMutableArray alloc] init];
          
          for (NSDictionary *dict in answerableDicts) {
              KAAQuestion *question = [[KAAQuestion alloc] init];
              question.question = dict[@"question"];
              question.userID = [dict[@"user_id"] integerValue];
              question.categoryName = dict[@"category_name"];
              question.timeAgoString = dict[@"time_ago_string"];
              question.questionID = [dict[@"id"] integerValue];
              [answerables addObject:question];
          }
          
          completion(YES, answerables);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO, nil);
    }];
}

- (void)getAskedQuestionsForUserID:(NSInteger)userID completion:(void (^)(BOOL, NSArray*))completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%d%@", KAAPIBaseURLString, @"/users/", userID, KAAAPIQuestionsEndpoint];
    
    [self GET:endpoint parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSArray *answerableDicts = responseObject[@"questions"];
          NSMutableArray *answerables = [[NSMutableArray alloc] init];
          
          for (NSDictionary *dict in answerableDicts) {
              KAAQuestion *question = [[KAAQuestion alloc] init];
              question.question = dict[@"question"];
              question.userID = [dict[@"user_id"] integerValue];
              question.categoryName = dict[@"category_name"];
              question.timeAgoString = dict[@"time_ago_string"];
              question.questionID = [dict[@"id"] integerValue];
              question.answer = dict[@"answer"];
              [answerables addObject:question];
          }
          
          completion(YES, answerables);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          completion(NO, nil);
      }];
}

- (void)postAnswer:(NSString *)answer
     forQuestionID:(NSInteger)questionID
            userID:(NSInteger)userID completion:(void (^)(BOOL))completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%d", KAAPIBaseURLString, KAAAPIQuestionsEndpoint, @"/", questionID];
    NSDictionary *params = @{
        @"question": @{
            @"answer": answer,
            @"user_answer_id": @(userID)
        }
     };
    
    [self PATCH:endpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];
}

- (void)postQuestion:(KAAQuestion *)question completion:(void (^)(BOOL))completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", KAAPIBaseURLString, KAAAPIQuestionsEndpoint];
    
    NSDictionary *params = @{
        @"question": @{
            @"user_id": @(question.userID),
            @"question": question.question,
            @"category_name": question.categoryName
        }
    };
    
    [self POST:endpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];
}

- (void)registerUserWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress completion:(void (^)(BOOL, KAAUser *))completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", KAAPIBaseURLString, KAAAPIUsersEndpoint];
    
    NSDictionary *params = @{
        @"user": @{
            @"name": username,
            @"email": emailAddress
        }
    };
    
    [self POST:endpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userDictionary = (NSDictionary *) responseObject;
        KAAUser *user = [KAAUser userFromDictionary:userDictionary];
        
        completion(YES, user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO, nil);
    }];
}

- (void)postSessionsForUser:(KAAUser *)user completion:(void (^)(BOOL, KAAUser *))completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", KAAPIBaseURLString, KAAPISessionsEndpoint];
    
    NSDictionary *params = @{
                             @"user": @{
                                     @"email": user.emailAddress
                                     }
                             };
    
    [self POST:endpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userDictionary = (NSDictionary *) responseObject;
        KAAUser *user = [KAAUser userFromDictionary:userDictionary];
        
        completion(YES, user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO, nil);
    }];
}

- (void)postUserCategoryWithUserId:(NSInteger)userId
                              name:(NSString *)name
                        completion:(void (^)(BOOL))completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", KAAPIBaseURLString, KAAPICategoriesEndpoint];
    
    NSDictionary *params = @{
                             @"user_category": @{
                                     @"user_id": @(userId),
                                    @"name": name
                                }
                            };
    
    [self POST:endpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];
}

- (void)getCategoriesWithCompletion:(void (^)(BOOL, NSArray *))completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", KAAPIBaseURLString, KAAPIAllCategoriesEndpoint];

    [self GET:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSArray *categories = responseObject[@"categories"];
        completion(YES, categories);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO, nil);
    }];

}

@end
