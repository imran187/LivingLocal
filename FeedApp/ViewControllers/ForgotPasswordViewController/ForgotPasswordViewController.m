//
//  ForgotPasswordViewController.m
//  FeedApp
//
//  Created by TechLoverr on 12/09/16.
//
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()
@property(weak, nonatomic) IBOutlet LLTextField *txtEmail;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}
- (IBAction)forgotPasswordPressed:(id)sender {

  if (_txtEmail.text.length == 0) {
    [self showAlertWithMessage:@"Please fill email address"];
    return;
  }

  if (![ValidationsHelper isGivenEmailValid:_txtEmail.text]) {
    [self showAlertWithTitle:@"Error"
                     message:@"Please enter valid email address."];
    return;
  }
  [APPDelegate startLoadingView];
  [ServiceManager
      forgotPasswordFor:_txtEmail.text
           onCompletion:^(BOOL success) {
             [APPDelegate stopLoadingView];
             if (success) {
               _txtEmail.text = @"";
               [self showAlertWithMessage:@"Please check your email account"];
             } else {
               [self showAlertWithMessage:
                         @"Your email address is not registered with us"];
             }
           }];
}

- (IBAction)cancelPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
