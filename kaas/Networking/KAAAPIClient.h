#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "KAAQuestion.h"
#import "KAAUser.h" 

@interface KAAAPIClient : AFHTTPRequestOperationManager
@property (nonatomic, strong) KAAUser *loggedInUser;

+ (KAAAPIClient *)sharedClient;

- (void)postQuestion:(KAAQuestion *)question completion:(void (^)(BOOL))completion;

- (void)getAnswerablesForUserID:(NSInteger)userID
                     completion:(void (^)(BOOL, NSArray*))completion;

- (void)postAnswer:(NSString *)answer
     forQuestionID:(NSInteger)questionID
            userID:(NSInteger)userID completion:(void (^)(BOOL))completion;

- (void)getAskedQuestionsForUserID:(NSInteger)userID
                        completion:(void (^)(BOOL, NSArray*))completion;

- (void)registerUserWithUsername:(NSString *)username
                    emailAddress:(NSString *)emailAddress
                      completion:(void (^)(BOOL, KAAUser *))completion;

- (void)postSessionsForUser:(KAAUser *)user
                 completion:(void (^)(BOOL, KAAUser *))completion;

- (void)postUserCategoryWithUserId:(NSInteger)userId
                              name:(NSString *)name
                        completion:(void (^)(BOOL))completion;

@end
