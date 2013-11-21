//
//  KAARegisterViewController.m
//  kaas
//
//  Created by Girgis on 21/11/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import "KAARegisterViewController.h"

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

@end
