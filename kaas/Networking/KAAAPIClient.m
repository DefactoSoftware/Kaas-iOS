#import "KAAAPIClient.h"

static NSString *const KAAPIBaseURLString = @"http://kaas.herokuapp.com/api/v1";
static NSString *const KAAAPIQuestionsEndpoint = @"/questions";

@implementation KAAAPIClient

+ (instancetype)sharedClient {
    static KAAAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:KAAPIBaseURLString]];
    });
    
    return _sharedClient;
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

@end
