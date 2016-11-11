//
//  UIViewController+LLViewController.m
//  FeedApp
//
//  Created by TechLoverr on 24/09/16.
//
//

#import "UIViewController+LLViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIViewController (LLViewController)
#pragma mark - Alert

- (void)showAlertWithMessage:(NSString *)message {
  [self alertControllerWithTitle:APP_NAME
                         message:message
                         buttons:@[]
               completionHandler:^(UIAlertController *alert, NSInteger index){

               }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
  [self alertControllerWithTitle:title
                         message:message
                         buttons:@[]
               completionHandler:^(UIAlertController *alert, NSInteger index){

               }];
}

- (void)alertControllerWithTitle:(NSString *)title
                         message:(NSString *)message
                         buttons:(NSArray *)arrActions
               completionHandler:
                   (void (^)(UIAlertController *, NSInteger))completionHandler {

  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:title
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];

  for (NSString *title in arrActions) {
    UIAlertAction *action = [UIAlertAction
        actionWithTitle:title
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                  if (completionHandler) {
                    completionHandler(alert, [arrActions indexOfObject:title]);
                  }
                }];

    [alert addAction:action];
  }

  [self presentViewController:alert animated:YES completion:nil];

  if (arrActions.count == 0) {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [alert dismissViewControllerAnimated:YES completion:nil];
        });
  }
}

- (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                     buttons:(NSArray *)arrActions
                    fromView:(UIView *)view
           completionHandler:
               (void (^)(UIAlertController *, NSInteger))completionHandler {

  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:title
                       message:message
                preferredStyle:UIAlertControllerStyleActionSheet];

  for (NSString *title in arrActions) {
    UIAlertAction *action = [UIAlertAction
        actionWithTitle:title
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                  if (completionHandler) {
                    completionHandler(alert, [arrActions indexOfObject:title]);
                  }
                }];

    [alert addAction:action];
  }

  [alert addAction:[UIAlertAction
                       actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *_Nonnull action){

                               }]];

  if (IS_IPAD) {
    [alert setModalPresentationStyle:UIModalPresentationPopover];

    UIPopoverPresentationController *popPresenter =
        [alert popoverPresentationController];
    popPresenter.sourceView = view;
    popPresenter.sourceRect = view.bounds;
  }
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)pickImageWithTitle:(NSString *)title
              OnCompletion:(void (^)(UIImage *image))completionHandler {
  [self
      actionSheetWithTitle:@""
                   message:@""
                   buttons:@[ @"Choose from gallery", @"Take from camera" ]
                  fromView:self.view
         completionHandler:^(UIAlertController *alert, NSInteger index) {
           if (index > 1) {
             return;
           }

           if (index == 0) {
             AVAuthorizationStatus status = [AVCaptureDevice
                 authorizationStatusForMediaType:AVMediaTypeVideo];
             if (status == AVAuthorizationStatusAuthorized) {
               // authorized
             } else if (status == AVAuthorizationStatusDenied) {
               // denied
               [self showAlertWithTitle:@"Camera Access Disabled"
                                message:@"To re-enable, please go to Settings "
                                        @"and turn on "
                                        @"Camera access for this app."];
               return;
             }
           } else {

             switch ([ALAssetsLibrary authorizationStatus]) {
             case ALAuthorizationStatusDenied: {
               [self showAlertWithTitle:@"Gallery Access Disabled"
                                message:@"To re-enable, please go to Settings "
                                        @"and turn on "
                                        @"Camera access for this app."];

               return;
               break;
             }

             default: { break; }
             }
           }

           UIImagePickerController *imagePicker =
               [[UIImagePickerController alloc] init];
           imagePicker.delegate = self;

           imagePicker.sourceType =
               (index == 1) ? UIImagePickerControllerSourceTypeCamera
                            : UIImagePickerControllerSourceTypePhotoLibrary;
           imagePicker.mediaTypes = @[ (NSString *)kUTTypeImage ];
           imagePicker.allowsEditing = YES;
           [self presentViewController:imagePicker
                              animated:YES
                            completion:^{
                              if (title) {
                                [imagePicker topViewController].title = title;
                              }
                            }];

           self.imageSelectionHandler = ^(UIImage *image) {
             completionHandler(image);
           };
         }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {

  [picker
      dismissViewControllerAnimated:YES
                         completion:^{
                           dispatch_async(dispatch_get_main_queue(), ^{
                             // SET THE SELECTED IMAGE IN THE USER PROFILE PIC
                             // BUTTON
                             UIImage *imageUser;
                             if ([info objectForKey:
                                           UIImagePickerControllerEditedImage])
                               imageUser = [info
                                   valueForKey:
                                       UIImagePickerControllerEditedImage];
                             else
                               imageUser = [info
                                   valueForKey:
                                       UIImagePickerControllerOriginalImage];

                             self.imageSelectionHandler(imageUser);
                           });
                         }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
