//
//  AppDelegate.m
//
//  Created by Vishal on 13/06/16.
//
//

#import "AppDelegate.h"
#import "DGActivityIndicatorView.h"
#import "MenuViewController.h"
#import <AFNetworking.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate () <CLLocationManagerDelegate> {
  DGActivityIndicatorView *activityIndicatorView;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [application setStatusBarHidden:YES];
  UIStoryboard *storyboard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  MenuViewController *leftVC = [storyboard
      instantiateViewControllerWithIdentifier:@"MenuViewController"];
  UINavigationController *rootVC =
      [storyboard instantiateViewControllerWithIdentifier:@"RootVC"];
  _sideMenu =
      [[REFrostedViewController alloc] initWithContentViewController:rootVC
                                                  menuViewController:leftVC];

  _sideMenu.backgroundFadeAmount = 0.8f;
  _sideMenu.panGestureEnabled = YES;
  self.window.rootViewController = _sideMenu;

  UIButton.appearance.adjustsImageWhenHighlighted = false;
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  UIButton.appearance.adjustsImageWhenHighlighted = false;
  sleep(2);

  activityIndicatorView = [[DGActivityIndicatorView alloc]
      initWithType:DGActivityIndicatorAnimationTypeBallTrianglePath
         tintColor:[UIColor orangeColor]];
  activityIndicatorView.center = self.window.center;
    
  [Fabric with:@[[Crashlytics class]]];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - LOADER
// LOADER
- (void)startLoadingView {
  [self startLoadingViewWithTitle:@"Please Wait.."];
}

- (void)startLoadingViewWithTitle:(NSString *)title {
  [self.window endEditing:YES];
  self.window.userInteractionEnabled = NO;
  [self.window addSubview:activityIndicatorView];
  [activityIndicatorView startAnimating];
}

- (void)stopLoadingView {
  dispatch_async(dispatch_get_main_queue(), ^{
    [activityIndicatorView stopAnimating];
    self.window.userInteractionEnabled = YES;
    [activityIndicatorView removeFromSuperview];
  });
}

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

  if (arrActions.count == 0) {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [alert dismissViewControllerAnimated:YES completion:nil];
        });
  }

  [self.window.rootViewController presentViewController:alert
                                               animated:YES
                                             completion:nil];
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
  [self.window.rootViewController presentViewController:alert
                                               animated:YES
                                             completion:nil];
}
@end
