//
//  CreateHoodViewController.m
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "CreateHoodViewController.h"
#import "LLFormTextField.h"
#import <AVFoundation/AVFoundation.h>
#import <ActionSheetPicker.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CreateHoodViewController () <UITextFieldDelegate> {
  LLSection *section;
}
@property(weak, nonatomic) IBOutlet LLFormTextField *txtCategory;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtGroupName;
@property(weak, nonatomic) IBOutlet LLFormTextField *txtGroupDesc;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(weak, nonatomic) IBOutlet UIImageView *imgGroup;

@end

@implementation CreateHoodViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _txtCategory.delegate = self;
  if (self.tabBarController) {
    APPDelegate.tabBarController.customTabbar.hidden = YES;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSNotificationCenter *notificationCenter =
      [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self
                         selector:@selector(keyBoardFrameWillUpdate:)
                             name:UIKeyboardWillChangeFrameNotification
                           object:nil];

  [notificationCenter addObserver:self
                         selector:@selector(keyBoardFrameWillUpdate:)
                             name:UIKeyboardWillHideNotification
                           object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  [self.view endEditing:YES];

  [ActionSheetStringPicker showPickerWithTitle:@"Select Category"
      rows:[ServiceManager.sections valueForKey:@"name"]
      initialSelection:section ? [ServiceManager.sections indexOfObject:section]
                               : 0
      doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex,
                  id selectedValue) {
        _txtCategory.text = selectedValue;
        section = ServiceManager.sections[selectedIndex];
      }
      cancelBlock:^(ActionSheetStringPicker *picker) {

      }
      origin:textField];

  return NO;
}

- (void)keyBoardFrameWillUpdate:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSTimeInterval animationDuration;
  UIViewAnimationCurve animationCurve;

  [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
  [userInfo[UIKeyboardAnimationDurationUserInfoKey]
      getValue:&animationDuration];

  UIViewAnimationOptions animationOptions =
      (animationCurve
       << 16); // convert from UIViewAnimationCurve to UIViewAnimationOptions

  CGRect keyboardRect = [[[notification userInfo]
      objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

  _bottomConstraint.constant =
      [UIScreen mainScreen].bounds.size.height - keyboardRect.origin.y;

  [UIView animateWithDuration:animationDuration
                        delay:0
                      options:animationOptions
                   animations:^{

                     [self.view layoutIfNeeded];
                   }
                   completion:nil];
}

- (IBAction)closePressed:(id)sender {
  APPDelegate.tabBarController.customTabbar.hidden = NO;
  [self dismissViewControllerAnimated:YES
                           completion:^{

                           }];
}
- (IBAction)imgPickPressed:(id)sender {
  [self pickImageWithTitle:@"Select Group Photo"
              OnCompletion:^(UIImage *image) {
                _imgGroup.image = image;
              }];
}
- (IBAction)createGroupPressed:(id)sender {

  if (section == nil) {
    [self showAlertWithMessage:@"Select category!"];
    return;
  }

  if (_txtGroupName.text.length == 0) {
    [self showAlertWithMessage:@"Enter group name"];
    return;
  }

  if (_txtGroupDesc.text.length == 0) {
    [self showAlertWithMessage:@"Enter group descriptione"];
    return;
  }

  [APPDelegate startLoadingView];

  [ServiceManager
      uploadBlobToContainer:_imgGroup.image
               onCompletion:^(BOOL success, NSString *path) {
                 if (success) {
                   [ServiceManager
                        createGroupFor:ServiceManager.loggedUser
                           description:_txtGroupDesc.text
                             groupName:_txtGroupName.text
                               section:section
                       groupCoverPhoto:path
                          onCompletion:^(BOOL success) {
                            if (success) {
                              [self
                                  dismissViewControllerAnimated:YES
                                                     completion:^{
                                                       APPDelegate
                                                           .tabBarController
                                                           .customTabbar
                                                           .hidden = NO;
                                                       dispatch_after(
                                                           dispatch_time(
                                                               DISPATCH_TIME_NOW,
                                                               (int64_t)(
                                                                   1 *
                                                                   NSEC_PER_SEC)),
                                                           dispatch_get_main_queue(),
                                                           ^{
                                                             [APPDelegate
                                                                 showAlertWithMessage:
                                                                     @"Group "
                                                                     @"created"
                                                                     @" succes"
                                                                     @"sfully"
                                                                     @"."];
                                                           });
                                                     }];
                            }
                          }];
                 }
               }];
}

@end
