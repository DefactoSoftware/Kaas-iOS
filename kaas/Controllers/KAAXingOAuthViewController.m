//
//  KAAXingOAuthViewController.m
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAAXingOAuthViewController.h"
#import <gtm-oauth/GTMOAuthAuthentication.h>
#import <gtm-oauth/GTMOAuthViewControllerTouch.h>
#import <gtm-oauth/GTMHTTPFetcher.h>
#import "KAAAPIClient.h"

static NSString *const KAAXingConsumerKey = @"6a875450a5af3a3ce6a9";
static NSString *const KAAXingConsumerSecret = @"9a3057d7b93b7fed0520022f4ee8217391be4c72";
static NSString *const KAAXingAPIBaseUrl = @"https://api.xing.com/v1/";
static NSString *const KAAXingRequestEndpoint = @"request_token";
static NSString *const KAAXingAccessEndpoint = @"access_token";
static NSString *const KAAXingAuthorizeEndpoint = @"authorize";
static NSString *const KAAXingMeEndpoint = @"users/me";
static NSString *const KAAOAuthCallbackUrl = @"http://kaas.defacto.nl/success";
static NSString *const KAAXingKeychainItemName = @"xing";


@implementation KAAXingOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)fetchSkillsWithAuthentication:(GTMOAuthAuthentication *)authentication {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@", KAAXingAPIBaseUrl, KAAXingMeEndpoint];
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [authentication authorizeRequest:request];
    
    NSURLResponse *response;
    NSError *error;
    NSData *userResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* user = [NSJSONSerialization
                          JSONObjectWithData:userResponseData
                          
                          options:kNilOptions
                          error:&error];
}


#pragma mark - Xing authentication

- (GTMOAuthAuthentication *)xingAuthentication {
    GTMOAuthAuthentication *authentication = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                                               consumerKey:KAAXingConsumerKey
                                                                                privateKey:KAAXingConsumerSecret];
    
    [authentication setServiceProvider:@"XING"];
    
    return authentication;
}

- (void)signInToXing {
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", KAAXingAPIBaseUrl, KAAXingRequestEndpoint];
    NSString *accessUrl = [NSString stringWithFormat:@"%@%@", KAAXingAPIBaseUrl, KAAXingAccessEndpoint];
    NSString *authorizeUrl = [NSString stringWithFormat:@"%@%@", KAAXingAPIBaseUrl, KAAXingAuthorizeEndpoint];
    NSString *scope = @"";
    
    GTMOAuthAuthentication *authentication = [self xingAuthentication];

    [authentication setCallback:KAAOAuthCallbackUrl];

    GTMOAuthViewControllerTouch *viewController;
    viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                                                               language:nil
                                                        requestTokenURL:[NSURL URLWithString:requestUrl]
                                                      authorizeTokenURL:[NSURL URLWithString:authorizeUrl]
                                                         accessTokenURL:[NSURL URLWithString:accessUrl]
                                                         authentication:authentication
                                                         appServiceName:KAAXingKeychainItemName
                                                               delegate:self
                                                       finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

#pragma mark - OAuth response callback

// Gets called after XING connect
- (void)viewController:(UIViewController *)viewController
        finishedWithAuth:(GTMOAuthAuthentication *)authentication
                   error:(NSError *)error {
    if (error != nil) {
        // sign in failed
    } else {
        [self fetchSkillsWithAuthentication:authentication];
    }
}

#pragma mark - Connect button

- (IBAction)connectButtonPressed:(id)sender {
    [self signInToXing];
}
@end
