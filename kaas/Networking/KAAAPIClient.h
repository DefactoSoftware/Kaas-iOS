#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface KAAPIClient : AFHTTPRequestOperationManager

+ (KAAPIClient *)sharedClient;

@end
