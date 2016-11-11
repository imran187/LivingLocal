//
//  OTPViewController.m
//  FeedApp
//
//  Created by TechLoverr on 12/09/16.
//
//

#import "OTPViewController.h"

@interface OTPViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *txtFirst;
@property(weak, nonatomic) IBOutlet UITextField *txtSecond;
@property(weak, nonatomic) IBOutlet UITextField *txtThird;
@property(weak, nonatomic) IBOutlet UITextField *txtFourth;
@property(weak, nonatomic) IBOutlet UITextField *txtFifth;
@property(weak, nonatomic) IBOutlet UITextField *txtSixth;

@end

@implementation OTPViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _txtFirst.delegate = self;
  _txtSecond.delegate = self;
  _txtThird.delegate = self;
  _txtFourth.delegate = self;
  _txtFifth.delegate = self;
  _txtSixth.delegate = self;

  [_txtFirst addTarget:self
                action:@selector(textFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
  [_txtSecond addTarget:self
                 action:@selector(textFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
  [_txtThird addTarget:self
                action:@selector(textFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
  [_txtFourth addTarget:self
                 action:@selector(textFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
  [_txtFifth addTarget:self
                action:@selector(textFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
  [_txtSixth addTarget:self
                action:@selector(textFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField {

  if (textField.text.length == 1) {
    switch (textField.tag) {
    case 0:
      [_txtSecond becomeFirstResponder];
      break;
    case 1:
      [_txtThird becomeFirstResponder];
      break;
    case 2:
      [_txtFourth becomeFirstResponder];
      break;
    case 3:
      [_txtFifth becomeFirstResponder];
      break;
    case 4:
      [_txtSixth becomeFirstResponder];
      break;
    case 5:
      [_txtSixth resignFirstResponder];
      break;

    default:
      break;
    }
  }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  textField.text = @"";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)editMobilePressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)createAccountPressed:(id)sender {
  [self.view endEditing:YES];
  if (![ValidationsHelper textFieldEmptyValidationsForTextFields:@[
        _txtFirst,
        _txtSecond,
        _txtThird,
        _txtFourth,
        _txtFifth,
        _txtSixth
      ]]) {
    [self showAlertWithMessage:@"Please fill appropriate data"];
    return;
  }

  NSString *enteredCode = [NSString
      stringWithFormat:@"%@%@%@%@%@%@", _txtFirst.text, _txtSecond.text,
                       _txtThird.text, _txtFourth.text, _txtFifth.text,
                       _txtSixth.text];

  if ([enteredCode isEqualToString:_code]) {
    [self showAlertWithMessage:@"OTP Verified"];
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [APPDelegate startLoadingView];
          [ServiceManager
                 loginUser:_user.email
              withPassword:_user.password
              onCompletion:^(BOOL success) {

                if (!success) {
                  [APPDelegate stopLoadingView];
                  [APPDelegate
                      showAlertWithMessage:@"Invalid email id or password!"];
                } else {

                  [ServiceManager getHoodsOnCompletion:^(BOOL success) {
                    if (success) {
                      ServiceManager.selctedHood =
                          [LLHood getHood:ServiceManager.loggedUser.hoodId];
                      [ServiceManager getSectionsOnCompletion:^(BOOL success) {
                        if (success) {
                          [APPDelegate stopLoadingView];
                          if (success) {
                            [self performSegueWithIdentifier:@"toHome"
                                                      sender:nil];
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
        });
  } else {
    [self showAlertWithMessage:@"Please enter valid OTP"];
  }
}
- (IBAction)resendSMSPressed:(id)sender {
  [ServiceManager getVerificationCodeFor:_user
                            onCompletion:^(BOOL success, NSString *code) {
                              if (success) {
                                _code = code;
                              }
                            }];
}

@end
