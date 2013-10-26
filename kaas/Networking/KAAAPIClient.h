#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "KAAQuestion.h"

@interface KAAAPIClient : AFHTTPRequestOperationManager

+ (KAAAPIClient *)sharedClient;

- (void)postQuestion:(KAAQuestion *)question completion:(void (^)(BOOL))completion;

@end
