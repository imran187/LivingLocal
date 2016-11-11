//
//  SignupViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "SelectHoodViewController.h"
#import "SignupViewController.h"
#import "WebContentViewController.h"

#define kToHood @"toHood"

@interface SignupViewController () <UITextFieldDelegate>

@end

@implementation SignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _txtFirstName.delegate = self;
  _txtLastName.delegate = self;
  // Do any additional setup after loading the view.
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                           withString:string];

  if (text.length > 18) {
    return NO;
  }

  NSString *emailRegex = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
  NSPredicate *emailTest =
      [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  BOOL isValid = [emailTest evaluateWithObject:text];
  return isValid || text.length == 0;
}

- (IBAction)signUpPressed:(id)sender {

  //  if (![ValidationsHelper textFieldEmptyValidationsForTextFields:@[
  //        _txtEmail,
  //        _txtLastName,
  //        _txtFirstName,
  //        _txtPassword,
  //        _txtConfirmPassword
  //      ]]) {
  //    [self showAlertWithMessage:@"Please fill appropriate data"];
  //    return;
  //  }

  if (_txtFirstName.text.length == 0) {
    [self showAlertWithMessage:@"Please enter first name"];
    return;
  }

  if (_txtLastName.text.length == 0) {
    [self showAlertWithMessage:@"Please enter last name"];
    return;
  }

  if (_txtConfirmPassword.text.length == 0) {
    [self showAlertWithMessage:@"Please confirm your password"];
    return;
  }

  if (_txtEmail.text.length == 0) {
    [self showAlertWithMessage:@"Please enter email"];
    return;
  }

  if (![ValidationsHelper isGivenEmailValid:_txtEmail.text]) {
    [self showAlertWithMessage:@"Please enter valid email"];
    return;
  }

  if (![ValidationsHelper isGivenPairOfPasswordsValid:@[
        _txtPassword.text,
        _txtConfirmPassword.text
      ]]) {

    return;
  }

  if (_txtPassword.text.length < 6) {
    [self showAlertWithMessage:@"Please enter minimum six characters."];
    return;
  }

  LLUser *user = [LLUser new];
  user.firstName = _txtFirstName.text;
  user.lastName = _txtLastName.text;
  user.password = _txtPassword.text;
  user.email = _txtEmail.text;
  user.merchantCode = _txtCode.text;

  [APPDelegate startLoadingView];
  [ServiceManager
      checkEmailFor:user
       onCompletion:^(BOOL success) {
         if (success) {
           [ServiceManager getHoodsOnCompletion:^(BOOL success) {
             [APPDelegate stopLoadingView];
             if (success) {
               [self performSegueWithIdentifier:kToHood sender:user];
             }

           }];
         } else {
           [APPDelegate stopLoadingView];
           [self showAlertWithMessage:
                     @"This email id is already registered with us!"];
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
  if ([segue.identifier isEqualToString:kToHood]) {
    SelectHoodViewController *vc = segue.destinationViewController;
    vc.user = sender;
  }

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
