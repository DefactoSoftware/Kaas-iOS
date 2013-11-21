//
//  KAAQuestionViewController.h
//  kaas
//
//  Created by Jurre Stender on 26/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>

@interface KAAQuestionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (weak, nonatomic) MLPAutoCompleteTextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UIButton *askNowButton;

- (IBAction)askNowButtonTapped:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@end
