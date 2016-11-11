//
//  SetPasswordViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "SetPasswordViewController.h"

@interface SetPasswordViewController ()
@property(weak, nonatomic) IBOutlet UITextField *txtPassword;
@property(weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}
- (IBAction)donePressed:(id)sender {

  if (_txtPassword.text.length < 6) {
    [self showAlertWithMessage:@"Password should at least 6 charaters!"];
    return;
  }

  if (_txtConfirmPassword.text.length == 0) {
    [self showAlertWithMessage:@"Please confirm your password"];
    return;
  }

  if (![ValidationsHelper isGivenPairOfPasswordsValid:@[
        _txtPassword.text,
        _txtConfirmPassword.text
      ]]) {

    return;
  }

  [APPDelegate startLoadingView];
  NSString *oldPassword = ServiceManager.loggedUser.password;
  ServiceManager.loggedUser.password = _txtPassword.text;
  [ServiceManager
      updatePasswordFor:ServiceManager.loggedUser
           onCompletion:^(BOOL success) {
             [APPDelegate stopLoadingView];
             if (success) {
               dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(2.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                     [APPDelegate
                         showAlertWithMessage:@"Password updated successfully"];
                   });

               [self backPressed:nil];
             } else {
               ServiceManager.loggedUser.password = oldPassword;
             }
           }];
}

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
