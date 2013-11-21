//
//  KAAAskedViewController.m
//  kaas
//
//  Created by Jurre Stender on 27/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAAAskedViewController.h"
#import "KAAQuestion.h"
#import "KAAAPIClient.h"
#import <CSNotificationView/CSNotificationView.h>
#import "KAAAnswerableCell.h"
#import "KAAAnswerViewController.h"

static NSString *const KAAAnswerableCellIdentifier = @"KAAAnswerableCellIdentifier";

@interface KAAAskedViewController ()

@property NSArray *questions;

@end

@implementation KAAAskedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.cancelBarButton.target = self;
    self.cancelBarButton.action = @selector(dismissViewController);
    
    [self loadData];
}

- (void)loadData {
    [[KAAAPIClient sharedClient] getAskedQuestionsForUserID:[KAAAPIClient sharedClient].loggedInUser.userId completion:^(BOOL success, NSArray *answerables) {
        if (success) {
            self.questions = answerables;
            [self.tableView reloadData];
        } else {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"Something went wrong :("];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"KAASegueIdentifierToAnswer"]) {
        KAAQuestion *question = self.questions[self.tableView.indexPathForSelectedRow.row];
        ((KAAAnswerViewController *)segue.destinationViewController).question = question;
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KAAAnswerableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:KAAAnswerableCellIdentifier];
    KAAQuestion *question = self.questions[indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"%@ ago", question.timeAgoString];
    cell.body.text = question.question;
    return cell;
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:NO];
}

@end
