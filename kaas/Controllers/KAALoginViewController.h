//
//  KAALoginViewController.h
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAALoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)loginButtonPressed:(id)sender;
@end
