//
//  KAAAnswerableViewController.m
//  kaas
//
//  Created by Jurre Stender on 27/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAAAnswerableViewController.h"
#import "KAAAnswerableCell.h"

static NSString *const KAAAnswerableCellIdentifier = @"KAAAnswerableCellIdentifier";

@interface KAAAnswerableViewController ()

@property NSArray *questions;

@end

@implementation KAAAnswerableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.cancelBarButton.target = self;
    self.cancelBarButton.action = @selector(dismissViewController);
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KAAAnswerableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:KAAAnswerableCellIdentifier];
    cell.title.text = @"Just now";
    cell.body.text = @"Retro Bushwick McSweeney's, put a bird on it dreamcatcher skateboard cliche hoodie Helvetica bespoke iPhone.";
    return cell;
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:NO];
}

@end
