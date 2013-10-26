#import "AFHTTPClient.h"

@interface KAAPIClient : AFHTTPRequestOperationManager

+ (KAAPIClient *)sharedClient;

@end
