//
//  LoginViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "LoginViewController.h"
#import "WebContentViewController.h"

#define kToHome @"toHome"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];

#if DEBUG
//  _txtPassword.text = @"password";
//  _txtEmail.text = @"mayur@ascratech.com";
//  _txtPassword.text = @"test";
//  _txtEmail.text = @"rajan.bhayana@gmail.com";
#endif
}
- (IBAction)loginPressed:(id)sender {
  [self.view endEditing:YES];

  if (_txtEmail.text.length == 0) {
    [self showAlertWithMessage:@"Please enter email id!"];
    return;
  }

  if (_txtPassword.text.length == 0) {
    [self showAlertWithMessage:@"Please enter password!"];
    return;
  }

  if (![ValidationsHelper isGivenEmailValid:_txtEmail.text]) {
    [self showAlertWithTitle:@"Error"
                     message:@"Please enter valid email address."];
    return;
  }
  [APPDelegate startLoadingView];
  [ServiceManager
         loginUser:_txtEmail.text
      withPassword:_txtPassword.text
      onCompletion:^(BOOL success) {

        if (!success) {
          [APPDelegate stopLoadingView];
          [APPDelegate showAlertWithMessage:@"Invalid email id or password!"];
        } else {

          [ServiceManager getHoodsOnCompletion:^(BOOL success) {
            if (success) {
              ServiceManager.selctedHood =
                  [LLHood getHood:ServiceManager.loggedUser.hoodId];
              [ServiceManager getSectionsOnCompletion:^(BOOL success) {
                if (success) {
                  [APPDelegate stopLoadingView];
                  if (success) {
                    [self performSegueWithIdentifier:kToHome sender:nil];
                  }
                } else {
                  [APPDelegate stopLoadingView];
                }
              }];
            } else {
              [APPDelegate stopLoadingView];
            }

          }];
        }
      }];
}

- (IBAction)termsPressed:(id)sender {
  [self performSegueWithIdentifier:@"toPrivacyTerms" sender:@"Terms"];
}
- (IBAction)privacyPressed:(id)sender {
  [self performSegueWithIdentifier:@"toPrivacyTerms" sender:@"Privacy"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  if ([sender isEqual:@"Terms"]) {
    WebContentViewController *vc = segue.destinationViewController;
    vc.titleString = @"Terms";
    vc.URLString = @"http://livinglocal.com/Static/terms.html";
  } else if ([sender isEqual:@"Privacy"]) {
    WebContentViewController *vc = segue.destinationViewController;
    vc.titleString = @"Privacy Policy";
    vc.URLString = @"https://www.livinglocal.com/Static/privacy-1.html";
  }
}

@end
