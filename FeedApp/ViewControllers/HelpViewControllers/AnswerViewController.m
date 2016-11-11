//
//  AnswerViewController.m
//  FeedApp
//
//  Created by TechLoverr on 12/09/16.
//
//

#import "AnswerViewController.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _lblTitle.text = _titleString;
  _lblAnswer.text = _answer;
  _lblQuestion.text = _question;
}
- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
@end
