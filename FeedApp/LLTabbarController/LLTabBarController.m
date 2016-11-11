//
//  LLTabBarController.m
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "HelpViewController.h"
#import "LLTabBarController.h"
#import "SearchViewController.h"
#import "WebContentViewController.h"
#import <PureLayout/PureLayout.h>

@interface LLTabBarController () <LLTabBarDelegate>

@end

@implementation LLTabBarController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tabBar.hidden = YES;
  APPDelegate.tabBarController = self;
  _customTabbar =
      [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LLTabBar class])
                                     owner:nil
                                   options:nil] firstObject];

  [self.view addSubview:_customTabbar];

  [_customTabbar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                          excludingEdge:ALEdgeTop];
  [_customTabbar autoSetDimension:ALDimensionHeight toSize:44];
  [_customTabbar selectItemAtIndex:TabBarItemTypeHome];
  _customTabbar.delegate = self;

  self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - LLTabBarDelegate methods
- (void)tabBarItemDidSelectAtIndex:(TabBarItemType)index {

  switch (index) {
  case TabBarItemTypeHome:
    [self selectViewControllerAtIndex:HOME];
    break;
  case TabBarItemTypePost:
    [self selectViewControllerAtIndex:CREATE_POST];
    break;
  case TabBarItemTypeRecommendation:
    [self selectViewControllerAtIndex:RECOMMENDATIONS];
    break;
  case TabBarItemTypeGroups:
    [self selectViewControllerAtIndex:GROUPS];
    break;
  case TabBarItemTypeEvents:
    [self selectViewControllerAtIndex:EVENTS];
    break;

  default:
    break;
  }
}

- (void)selectViewControllerAtIndex:(NSInteger)index {

  if (self.selectedIndex != index) {

    UIView *fromView = ((UINavigationController *)self.selectedViewController)
                           .topViewController.view;
    NSInteger controllerIndex = index;
    UIView *toView = [((UINavigationController *)self.viewControllers[index])
                          .topViewController view];

    // Get the size of the view area.
    CGRect viewSize = fromView.frame;

    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];

    if (self.selectedIndex == CREATE_POST) {
      [fromView.superview sendSubviewToBack:toView];
    } else {
      if (index == CREATE_POST) {
        toView.frame =
            CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, viewSize.size.height);
      } else {

        // Position it off screen.
        toView.frame = CGRectMake(0, viewSize.origin.y, SCREEN_WIDTH,
                                  viewSize.size.height);
      }
    }

    [UIView animateWithDuration:0.3
        animations:^{
          if (self.selectedIndex == CREATE_POST) {
            fromView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,
                                        viewSize.size.height);

          } else if (index == CREATE_POST) {
            toView.frame = CGRectMake(0, viewSize.origin.y, SCREEN_WIDTH,
                                      viewSize.size.height);
          } else {
            // Animate the views on and off the screen. This will appear to
            // slide.
            fromView.frame = CGRectMake((0), viewSize.origin.y, SCREEN_WIDTH,
                                        viewSize.size.height);
            toView.frame = CGRectMake(0, viewSize.origin.y, SCREEN_WIDTH,
                                      viewSize.size.height);
          }
        }

        completion:^(BOOL finished) {

          // Remove the old view from the tabbar view.
          [fromView removeFromSuperview];

          if (self.selectedIndex != index) {
            self.selectedIndex = index;

            switch (index) {
            case HOME:
              [self.customTabbar selectItemAtIndex:TabBarItemTypeHome];
              break;
            case CREATE_POST:
              [self.customTabbar selectItemAtIndex:TabBarItemTypePost];
              break;
            case RECOMMENDATIONS:
              [self.customTabbar
                  selectItemAtIndex:TabBarItemTypeRecommendation];
              break;
            case GROUPS:
              [self.customTabbar selectItemAtIndex:TabBarItemTypeGroups];
              break;
            case EVENTS:
              [self.customTabbar selectItemAtIndex:TabBarItemTypeEvents];
              break;

            default:
              break;
            }
          }
        }];
  } else {
    [(UINavigationController *)self.viewControllers[index]
        popToRootViewControllerAnimated:YES];

    for (UITableView *tbl in
         [[(UINavigationController *)self.viewControllers[index]
              topViewController]
                 .view.subviews
             filteredArrayUsingPredicate:
                 [NSPredicate
                     predicateWithBlock:^BOOL(
                         UIView *_Nonnull evaluatedObject,
                         NSDictionary<NSString *, id> *_Nullable bindings) {
                       return
                           [evaluatedObject isKindOfClass:[UITableView class]];
                     }]]) {
      [UIView animateWithDuration:0.25
                       animations:^{
                         tbl.contentOffset = CGPointZero;
                       }];
    }
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([sender isEqualToString:@"ContactUs"]) {
    HelpViewController *helpVC = segue.destinationViewController;
    helpVC.shouldHideLogo = YES;
    helpVC.arrData = @[
      @"Report a technical issue",
      @"Spam or abuse",
      @"Make a suggestion",
      @"Partner with us"
    ];
    helpVC.cellBGColor = [UIColor whiteColor];
    helpVC.titleString = @"Contact Us";
    helpVC.cellSelectionColor = [UIColor clearColor];
    helpVC.shouldNotNavigate = YES;
    helpVC.textColor =
        [UIColor colorWithRed:0.000 green:0.004 blue:0.008 alpha:1.00];
    helpVC.separatorColor =
        [UIColor colorWithRed:0.953 green:0.957 blue:0.961 alpha:1.00];
  } else if ([sender isEqualToString:@"Terms"]) {
    WebContentViewController *vc = segue.destinationViewController;
    vc.titleString = @"Terms";
    vc.URLString = @"http://livinglocal.com/Static/terms.html";
  } else if ([sender isEqualToString:@"Privacy"]) {
    WebContentViewController *vc = segue.destinationViewController;
    vc.titleString = @"Privacy Policy";
    vc.URLString = @"https://www.livinglocal.com/Static/privacy-1.html";
  }
}

- (id<UIViewControllerAnimatedTransitioning>)
           navigationController:(UINavigationController *)navigationController
animationControllerForOperation:(UINavigationControllerOperation)operation
             fromViewController:(UIViewController *)fromVC
               toViewController:(UIViewController *)toVC {
  if ([toVC isKindOfClass:[SearchViewController class]] ||
      [fromVC isKindOfClass:[SearchViewController class]]) {
    RightToLeftAnimationController *animator =
        [RightToLeftAnimationController new];
    animator.presenting = (operation == UINavigationControllerOperationPush);
    return animator;
  }

  return nil;
}

@end
