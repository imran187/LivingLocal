//
//  MobileNumberViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "LLLabel.h"
#import "MobileNumberViewController.h"
#import "OTPViewController.h"

#define kVerify @"toVerify"

@interface MobileNumberViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet LLLabel *lblMobileInstruction;
@property(weak, nonatomic) IBOutlet LLTextField *txtCountryCode;
@property(weak, nonatomic) IBOutlet LLTextField *txtMobileNumber;

@end

@implementation MobileNumberViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _txtMobileNumber.delegate = self;
  _txtCountryCode.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  _lblMobileInstruction.text = @"Edit Mobile Number";

  OTPViewController *vc = segue.destinationViewController;
  vc.code = sender;
  vc.user = _user;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                           withString:string];

  if (textField == _txtCountryCode) {
    if (text.length > 4) {
      return NO;
    }

    return text.length == 0 || [[text substringToIndex:1] isEqual:@"+"];
  }

  if (text.length > 10) {
    return NO;
  }

  return ![text containsString:@"+"] && ![text containsString:@"#"];
}

- (IBAction)nextPressed:(id)sender {
  [self.view endEditing:YES];
  
  if (_txtCountryCode.text.length == 0) {
    [self showAlertWithMessage:@"Please enter country code"];
    return;
  }

  if (_txtMobileNumber.text.length != 10) {
    [self showAlertWithMessage:@"Please enter valid mobile number"];
    return;
  }

  _user.mobileNumber = _txtMobileNumber.text;
  _user.countryCode = _txtCountryCode.text;

  [APPDelegate startLoadingView];
  [ServiceManager
      getVerificationCodeFor:_user
                onCompletion:^(BOOL success, NSString *code) {
    [APPDelegate stopLoadingView];
    if (success) {
      [self performSegueWithIdentifier:kVerify sender:code];
    }
                }];
}

@end
