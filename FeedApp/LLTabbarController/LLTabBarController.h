//
//  LLTabBarController.h
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "LLTabBar.h"
#import "RightToLeftAnimationController.h"
#import <UIKit/UIKit.h>

#define HOME 0
#define CREATE_POST 1
#define RECOMMENDATIONS 2
#define GROUPS 3
#define EVENTS 4

@interface LLTabBarController
    : UITabBarController <UINavigationControllerDelegate>
@property(nonatomic, strong) LLTabBar *customTabbar;
- (void)selectViewControllerAtIndex:(NSInteger)index;
@end
