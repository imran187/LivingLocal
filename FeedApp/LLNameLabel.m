//
//  LLNameLabel.m
//  FeedApp
//
//  Created by TechLoverr on 25/10/16.
//
//

#import "LLNameLabel.h"
#import "ProfileViewController.h"

@interface UIWindow (PazLabs)

- (UIViewController *)visibleViewController;

@end

@implementation UIWindow (PazLabs)

- (UIViewController *)visibleViewController {
  UIViewController *rootViewController = self.rootViewController;
  return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
  if ([vc isKindOfClass:[UINavigationController class]]) {
    return
        [UIWindow getVisibleViewControllerFrom:[((UINavigationController *)vc)
                                                   visibleViewController]];
  } else if ([vc isKindOfClass:[UITabBarController class]]) {
    return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *)vc)
                                                      selectedViewController]];
  } else {
    if (vc.presentedViewController) {
      return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
    } else {
      return vc;
    }
  }
}

@end

@implementation LLNameLabel
- (void)awakeFromNib {
  [super awakeFromNib];
  self.userInteractionEnabled = YES;
  self.layer.borderColor = [UIColor clearColor].CGColor;

  UITapGestureRecognizer *tap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(imagePressed)];

  [self addGestureRecognizer:tap];
}

- (void)imagePressed {

  if (_userID) {
    [ServiceManager
        getProfileFor:_userID
         onCompletion:^(BOOL success, LLUser *user) {
           if (success) {
             UIStoryboard *storyboard =
                 [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             ProfileViewController *profileVC =
                 [storyboard instantiateViewControllerWithIdentifier:
                                 @"ProfileViewController"];
             profileVC.user = user;
             UINavigationController *navVC = [[UINavigationController alloc]
                 initWithRootViewController:profileVC];
             profileVC.isFriendProfile = YES;
             navVC.navigationBarHidden = YES;
             [[APPDelegate.window visibleViewController]
                 showViewController:navVC
                             sender:nil];
           }
         }];
  }
}

@end