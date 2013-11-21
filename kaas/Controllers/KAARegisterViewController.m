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
#import "KAAXingOAuthViewController.h"

static NSString *const KAAImportSkillsSegueIdentifier = @"KAASegueIdentifierToImportSkills";

@interface KAARegisterViewController()
@property (nonatomic, strong) KAAUser *loggedInUser;
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
            self.loggedInUser = user;
            [self performSegueWithIdentifier:KAAImportSkillsSegueIdentifier sender:self];
        } else {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"Something went wrong :("];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:KAAImportSkillsSegueIdentifier]) {
        KAAXingOAuthViewController *destinationController = (KAAXingOAuthViewController *) segue.destinationViewController;
        destinationController.loggedInUser = self.loggedInUser;
    } else {
        [super performSegueWithIdentifier:segue.identifier sender:sender];
    }
}

@end
