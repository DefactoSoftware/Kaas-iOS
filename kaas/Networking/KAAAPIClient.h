#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "KAAQuestion.h"

@interface KAAAPIClient : AFHTTPRequestOperationManager

+ (KAAAPIClient *)sharedClient;

- (void)postQuestion:(KAAQuestion *)question completion:(void (^)(BOOL))completion;
- (void)getAnswerablesForUserID:(NSInteger)userID completion:(void (^)(BOOL, NSArray*))completion;
- (void)postAnswer:(NSString *)answer
     forQuestionID:(NSInteger)questionID
            userID:(NSInteger)userID completion:(void (^)(BOOL))completion;

@end
