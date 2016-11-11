//
//  VSBaseViewController.m
//
//  Created by Vishal on 29/12/15.
//  Copyright © 2015 vishal. All rights reserved.
//

#import "FilterView.h"
#import "ProfileViewController.h"
#import "RecommendationsViewController.h"
#import "VSBaseViewController.h"

@interface VSBaseViewController ()

@end

@implementation VSBaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
    _lblNotificationCount.superview.hidden = YES;
  _lblHood.text = ServiceManager.selctedHood.name;
  [_imgUser
      sd_setImageWithURL:[NSURL URLWithString:ServiceManager.loggedUser.photo]
        placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _lblHood.text = ServiceManager.selctedHood.name;
  [_imgUser
      sd_setImageWithURL:[NSURL URLWithString:ServiceManager.loggedUser.photo]
        placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];

  [ServiceManager
      getNotificationsForUserId:ServiceManager.loggedUser.userID
                   OnCompletion:^(BOOL success, NSArray *posts) {

                     NSInteger count =
                         [posts filteredArrayUsingPredicate:
                                    [NSPredicate predicateWithFormat:
                                                     @"isNotificationRead = 0"]]
                             .count;
                     _lblNotificationCount.text =
                         [NSString stringWithFormat:@"%lu", count];
                     _lblNotificationCount.superview.hidden = count == 0;
                   }];
}

- (IBAction)showLeftMenuPressed:(id)sender {
  [APPDelegate.sideMenu presentMenuViewController];
}
- (IBAction)showNotificationsPressed:(id)sender {
  UIStoryboard *storyboard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UIViewController *notificationVC = [storyboard
      instantiateViewControllerWithIdentifier:@"NotificationViewController"];
  [self showViewController:notificationVC sender:nil];
}
- (IBAction)showProfilePressed:(id)sender {

  if ([self isKindOfClass:[ProfileViewController class]]) {
    ProfileViewController *vc = (id)self;
    if (!vc.isFriendProfile) {
      return;
    }
  }

  UIStoryboard *storyboard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UIViewController *profileVC = [storyboard
      instantiateViewControllerWithIdentifier:@"ProfileViewController"];
  [self showViewController:profileVC sender:nil];
}
- (IBAction)searchPressed:(id)sender {
  [APPDelegate.tabBarController performSegueWithIdentifier:@"toSearch"
                                                    sender:nil];
}
- (IBAction)btnFilterPressed:(UIButton *)sender {
  sender.userInteractionEnabled = NO;
  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
      });

  _filterView =
      [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:nil options:nil]
          firstObject];
  _filterView.colFilters.arrSelectedData = [ServiceManager.selectedSections mutableCopy];
  _filterView.lblTitle.text =
      APPDelegate.tabBarController.customTabbar.selectedItemType ==
              TabBarItemTypeHome
          ? @"Show Categories in Timeline"
          : @"Show Categories in Recommendations";
  _filterView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
  _filterView.selectionHandler = ^(NSMutableArray *arrData) {
  ServiceManager.selectedSections = arrData;
//    if (![self isKindOfClass:[RecommendationsViewController class]]) {
//      ServiceManager.loggedUser.interests =
//          [[arrData valueForKey:@"ID"] componentsJoinedByString:@","];
//    }

    _selectionHandler();
  };
  [self.tabBarController.view addSubview:_filterView];

  [UIView animateWithDuration:0.5
                   animations:^{
                     _filterView.frame =
                         CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                   }];
}

@end
