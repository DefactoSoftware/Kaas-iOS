//
//  KAARegisterViewController.m
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAARegisterViewController.h"
#import "KAAAPIClient.h"
#import <CSNotificationView/CSNotificationView.h>

@interface KAARegisterViewController ()

@end

@implementation KAARegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.emailAddressTextField resignFirstResponder];
}

- (IBAction)registerButtonPressed:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *emailAddress = self.emailAddressTextField.text;
    
    [[KAAAPIClient sharedClient] registerUserWithUsername:username emailAddress:emailAddress completion:^(BOOL success, KAAUser *user) {
        if (success) {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleSuccess
                                             message:@"You have successfully been registered"];
        } else {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"Something went wrong :("];
        }
    }];
}

@end
