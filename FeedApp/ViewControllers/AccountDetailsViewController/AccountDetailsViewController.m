//
//  AccountDetailsViewController.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "AccountDetailsViewController.h"
#import "ActionSheetPicker.h"

@interface AccountDetailsViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property(weak, nonatomic) IBOutlet UITextField *txtLastName;
@property(weak, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property(weak, nonatomic) IBOutlet UIButton *btnMale;
@property(weak, nonatomic) IBOutlet UIButton *btnFemale;
@property(weak, nonatomic) IBOutlet UITextField *txtDOB;
@property(weak, nonatomic) IBOutlet UITextField *txtHood;

@end

@implementation AccountDetailsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _txtDOB.delegate = self;
  _txtHood.delegate = self;

  _txtFirstName.delegate = self;
  _txtLastName.delegate = self;

  _txtEmailAddress.userInteractionEnabled = NO;
  _txtFirstName.text = ServiceManager.loggedUser.firstName;
  _txtLastName.text = ServiceManager.loggedUser.lastName;
  _txtEmailAddress.text = ServiceManager.loggedUser.email;
  _txtHood.text = ServiceManager.loggedUser.hoodName;

  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"dd/ MM/ YYYY";

  _txtDOB.text = [df stringFromDate:ServiceManager.loggedUser.birthDate];
  _btnFemale.imageView.contentMode = UIViewContentModeScaleAspectFit;
  _btnMale.imageView.contentMode = UIViewContentModeScaleAspectFit;

  _btnFemale.selected = NO;
  _btnMale.selected = NO;
  if (ServiceManager.loggedUser.sex == GenderMale) {
    _btnMale.selected = YES;
  } else if (ServiceManager.loggedUser.sex == GenderFemale) {
    _btnFemale.selected = YES;
  }
}

#pragma mark - UITextFieldDelegate implementations

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  [self.view endEditing:YES];
  if ([textField isEqual:_txtDOB]) {
    [ActionSheetDatePicker showPickerWithTitle:@"Select Date of Birth"
        datePickerMode:UIDatePickerModeDate
        selectedDate:[NSDate date]
        minimumDate:nil
        maximumDate:[NSDate date]
        doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
          NSDateFormatter *df = [NSDateFormatter new];
          df.dateFormat = @"dd/ MM/ YYYY";

          _txtDOB.text = [df stringFromDate:selectedDate];
        }
        cancelBlock:^(ActionSheetDatePicker *picker) {

        }
        origin:textField];
  }
  if (textField == _txtLastName || textField == _txtFirstName) {
    return YES;
  }
  return NO;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  if (textField == _txtLastName || textField == _txtFirstName) {
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

  return YES;
}

#pragma mark - button methods

- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)donePressed:(id)sender {
  [self.view endEditing:YES];
  NSString *firstName = ServiceManager.loggedUser.firstName;
  NSString *lastName = ServiceManager.loggedUser.lastName;
  NSString *email = ServiceManager.loggedUser.email;
  Gender gender = ServiceManager.loggedUser.sex;
  NSDate *birthDate = ServiceManager.loggedUser.birthDate;
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"dd/ MM/ YYYY";
  Gender selectedGender = GenderNone;

  if (_btnMale.selected) {
    selectedGender = GenderMale;
  } else if (_btnFemale.selected) {
    selectedGender = GenderFemale;
  }

  if (firstName == _txtFirstName.text && lastName == _txtLastName.text && gender == selectedGender &&
      [[df stringFromDate:birthDate] isEqualToString: _txtDOB.text]) {
    return;
  }

  if (_txtFirstName.text.length == 0) {
    [self showAlertWithMessage:@"Please enter first name"];
    return;
  }

  if (_txtLastName.text.length == 0) {
    [self showAlertWithMessage:@"Please enter last name"];
    return;
  }

  if (_txtDOB.text.length == 0) {
    [self showAlertWithMessage:@"Please select date of birth"];
    return;
  }

  if (![ValidationsHelper isGivenEmailValid:_txtEmailAddress.text]) {
    [self showAlertWithMessage:@"Please enter valid email address."];
    return;
  }

  ServiceManager.loggedUser.firstName = _txtFirstName.text;
  ServiceManager.loggedUser.lastName = _txtLastName.text;
  ServiceManager.loggedUser.email = _txtEmailAddress.text;
  ServiceManager.loggedUser.sex = selectedGender;
  ServiceManager.loggedUser.birthDate = [df dateFromString:_txtDOB.text];

  [APPDelegate startLoadingView];
  [ServiceManager
      updateUserFor:ServiceManager.loggedUser
       onCompletion:^(BOOL success) {
         [APPDelegate stopLoadingView];
         if (success) {
           [self.navigationController popViewControllerAnimated:YES];
         } else {
           ServiceManager.loggedUser.firstName = firstName;
           ServiceManager.loggedUser.lastName = lastName;
           ServiceManager.loggedUser.email = email;
           ServiceManager.loggedUser.sex = gender;
           ServiceManager.loggedUser.birthDate = birthDate;
           [self showAlertWithMessage:@"Something went wrong!"];
         }
       }];
}
- (IBAction)btnGenderPressed:(UIButton *)sender {
  sender.selected = YES;
  if ([sender isEqual:_btnMale]) {
    _btnFemale.selected = NO;
  } else {
    _btnMale.selected = NO;
  }
}

@end
