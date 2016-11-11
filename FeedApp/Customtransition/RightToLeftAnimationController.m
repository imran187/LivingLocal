//
//  RightToLeftAnimationController.m
//  FeedApp
//
//  Created by TechLoverr on 23/09/16.
//
//

#import "RightToLeftAnimationController.h"

@implementation RightToLeftAnimationController

- (NSTimeInterval)transitionDuration:
    (id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.5;
}

- (void)animateTransition:
    (id<UIViewControllerContextTransitioning>)transitionContext {
  // Grab the from and to view controllers from the context
  UIViewController *fromViewController = [transitionContext
      viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [transitionContext
      viewControllerForKey:UITransitionContextToViewControllerKey];

  // Set our ending frame. We'll modify this later if we have to
  CGRect endFrame = [[UIScreen mainScreen] bounds];

  if (!self.presenting) {
    fromViewController.view.userInteractionEnabled = NO;

    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];

    CGRect startFrame = endFrame;
    startFrame.origin.x += SCREEN_WIDTH;

    CGRect fromFrame = endFrame;
    fromFrame.origin.x -= SCREEN_WIDTH;

    toViewController.view.frame = startFrame;
    fromViewController.view.frame = endFrame;

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
        animations:^{
          fromViewController.view.tintAdjustmentMode =
              UIViewTintAdjustmentModeDimmed;
          toViewController.view.frame = endFrame;
          fromViewController.view.frame = fromFrame;
        }
        completion:^(BOOL finished) {
          [transitionContext completeTransition:YES];
        }];
  } else {
    toViewController.view.userInteractionEnabled = YES;

    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext.containerView addSubview:fromViewController.view];

    endFrame.origin.x += SCREEN_WIDTH;
    CGRect toFrame = [[UIScreen mainScreen] bounds];
    toFrame.origin.x -= SCREEN_WIDTH;
    toViewController.view.frame = toFrame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
        animations:^{
          toViewController.view.tintAdjustmentMode =
              UIViewTintAdjustmentModeAutomatic;
          fromViewController.view.frame = endFrame;
          toViewController.view.frame = [[UIScreen mainScreen] bounds];
        }
        completion:^(BOOL finished) {
          [transitionContext completeTransition:YES];
        }];
  }
}

@end
