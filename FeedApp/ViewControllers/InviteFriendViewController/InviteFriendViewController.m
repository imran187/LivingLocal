//
//  InviteFriendViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "InviteFriendViewController.h"

@interface InviteFriendViewController ()
@property(weak, nonatomic) IBOutlet UITextField *txtEmail;

@end

@implementation InviteFriendViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _txtEmail.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:_txtEmail.placeholder
          attributes:@{
            NSFontAttributeName : [UIFont systemFontOfSize:13],
            NSForegroundColorAttributeName : [UIColor whiteColor]
          }];
  _txtEmail.layer.borderColor =
      [UIColor colorWithRed:0.380 green:0.384 blue:0.388 alpha:1.00].CGColor;
  _txtEmail.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
  _txtEmail.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewWillAppear:(BOOL)animated {
  APPDelegate.tabBarController.customTabbar.hidden = YES;
}

- (IBAction)backPressed:(id)sender {
  APPDelegate.tabBarController.customTabbar.hidden = NO;
  [self.navigationController popViewControllerAnimated:YES];
}

@end
