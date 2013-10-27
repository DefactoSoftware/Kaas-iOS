//
//  KAAAskedViewController.h
//  kaas
//
//  Created by Jurre Stender on 27/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAAAskedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;

@end
