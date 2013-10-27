//
//  KAAAnswerViewController.m
//  kaas
//
//  Created by Jurre Stender on 27/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAAAnswerViewController.h"
#import "KAAAPIClient.h"
#import <CSNotificationView/CSNotificationView.h>

@interface KAAAnswerViewController ()

@end

@implementation KAAAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.questionTextView.text = self.question.question;
    if (!(self.question.answer == (id)[NSNull null])) {
        self.answerTextView.text = self.question.answer;
        self.titleLabel.text = @"ANSWERED!";
    } else {
        self.titleLabel.text = @"YOU AKSED";
        self.answerTextView.text = @"No one answered yet..";
    }
}

- (IBAction)answerButtonTapped:(id)sender {
    [[KAAAPIClient sharedClient] postAnswer:self.answerTextView.text forQuestionID:self.question.questionID userID:2 completion:^(BOOL success) {
        if (success) {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"Thanks for answering!"];
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
               [self dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Something went wrong :("];
        }
    }];
}

@end
