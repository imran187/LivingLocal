//
//  AppDelegate.h
//
//  Created by Vishal on 13/06/16.
//
//

#import "LLTabbarController.h"
#import <REFrostedViewController/REFrostedViewController.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) LLTabBarController *tabBarController;
@property(strong, nonatomic) REFrostedViewController *sideMenu;

// LOADER
- (void)startLoadingView;
- (void)startLoadingViewWithTitle:(NSString *)title;
- (void)stopLoadingView;

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

@end
