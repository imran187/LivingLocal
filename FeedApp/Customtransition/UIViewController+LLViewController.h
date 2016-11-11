//
//  UIViewController+LLViewController.h
//  FeedApp
//
//  Created by TechLoverr on 24/09/16.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (LLViewController) <UIImagePickerControllerDelegate,
                                                UINavigationControllerDelegate>
@property(nonatomic, strong) void (^imageSelectionHandler)(UIImage *);

- (void)showAlertWithMessage:(NSString *)message;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

- (void)actionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                     buttons:(NSArray *)arrActions
                    fromView:(UIView *)view
           completionHandler:
               (void (^)(UIAlertController *, NSInteger))completionHandler;

- (void)alertControllerWithTitle:(NSString *)title
                         message:(NSString *)message
                         buttons:(NSArray *)arrActions
               completionHandler:
                   (void (^)(UIAlertController *, NSInteger))completionHandler;

- (void)pickImageWithTitle:(NSString *)title
              OnCompletion:(void (^)(UIImage *image))completionHandler;
@end
