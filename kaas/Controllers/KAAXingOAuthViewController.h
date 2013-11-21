//
//  KAAXingOAuthViewController.h
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAAXingOAuthViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UITableView *skillsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importButton;

- (IBAction)connectButtonPressed:(id)sender;
- (IBAction)skipButtonPressed:(id)sender;
- (IBAction)importButtonPressed:(id)sender;
@end
