//
//  KAALoginViewController.m
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAALoginViewController.h"
#import "KAAAPIClient.h"
#import "KAAAppDelegate.h"
#import "KAAUser.h"
#import <CSNotificationView/CSNotificationView.h>

static NSString *const KAAQuestionsNavigationControllerIdentifier = @"KAANavigationControllerQuestions";

@implementation KAALoginViewController


- (IBAction)loginButtonPressed:(id)sender {
    NSString *emailAddress = self.emailTextField.text;
    KAAUser *user = [[KAAUser alloc] init];
    
    user.emailAddress = emailAddress;
    
    [[KAAAPIClient sharedClient] postSessionsForUser:user completion:^(BOOL success, KAAUser *user) {
        if (success) {
            [KAAAPIClient sharedClient].loggedInUser = user;
            // Push to app
            KAAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:KAAQuestionsNavigationControllerIdentifier];
        } else {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"Something went wrong :("];
        }
    }];
}
@end
