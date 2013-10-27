//
//  KAAAnswerViewController.h
//  kaas
//
//  Created by Jurre Stender on 27/10/13.
//  Copyright (c) 2013 Jurre Stender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAAQuestion.h"

@interface KAAAnswerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (strong, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet UIView *answerBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (nonatomic, strong) KAAQuestion *question;

- (IBAction)answerButtonTapped:(id)sender;

@end
