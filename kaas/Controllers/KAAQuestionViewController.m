//
//  KAAQuestionViewController.m
//  kaas
//
//  Created by Jurre Stender on 26/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAAQuestionViewController.h"
#import "KAAAPIClient.h"
#import "KAAQuestion.h"
#import <CSNotificationView/CSNotificationView.h>

@interface KAAQuestionViewController () <UITextViewDelegate, MLPAutoCompleteTextFieldDataSource> {
    BOOL _textViewIsShrunk;
}

@property NSArray *categories;

@end

@implementation KAAQuestionViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.categories = @[@"Network", @"Umami", @"Hackathon", @"Programming", @"Berlin", @"China", @"Lufthansa"];
	
    self.questionTextView.textContainerInset = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
    self.questionTextView.delegate = self;
    self.categoryTextField.autoCompleteDataSource = self;
    self.categoryTextField.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    self.categoryTextField.autoCompleteTableBorderColor = [UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1];
    self.categoryTextField.autoCompleteTableCellTextColor = [UIColor blackColor];
    self.categoryTextField.autoCompleteTableCornerRadius = 0;
    self.categoryTextField.autoCompleteFontSize = 16;
}

- (IBAction)askNowButtonTapped:(id)sender {
    self.askNowButton.enabled = NO;
    KAAQuestion *question = [[KAAQuestion alloc] init];
    question.question = self.questionTextView.text;
    question.categoryName = self.categoryTextField.text;
    question.userID = 1;
    [[KAAAPIClient sharedClient] postQuestion:question completion:^(BOOL success) {
        if (success) {
            self.questionTextView.text = @"";
            self.categoryTextField.text = @"";
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"Your Question was sent!"];
        } else {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Something went wrong :("];
        }
        self.askNowButton.enabled = YES;
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    static const NSInteger TextViewShrinkSize = 50;
    if (!_textViewIsShrunk) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = textView.frame;
            frame.size.height -= TextViewShrinkSize;
            textView.frame = frame;
            
            CGRect buttonFrame = self.askNowButton.frame;
            buttonFrame.origin.y -= TextViewShrinkSize;
            self.askNowButton.frame = buttonFrame;
        }];
        _textViewIsShrunk = YES;
    }
}

#pragma mark - MLPAutoCompleteTextFieldDataSource

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[c] %@", [string stringByAppendingString:@"*"]];
    NSArray *filteredArray = [self.categories filteredArrayUsingPredicate:predicate];
    handler(filteredArray);
}

@end
