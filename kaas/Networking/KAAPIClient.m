#import "KAAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString *const KAAPIBaseURLString = @"kaas.herokuapp.com/api/v1";

@implementation KAAPIClient

+ (instancetype)sharedClient {
    static KAAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:KAAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    return self;
}

@end
