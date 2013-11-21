//
//  KAAXingOAuthViewController.h
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAAXingOAuthViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

- (IBAction)connectButtonPressed:(id)sender;
@end
