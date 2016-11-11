//
//  LLTabBar.h
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "LLTabBarItem.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TabBarItemType) {
  TabBarItemTypeNone = -1,
  TabBarItemTypeHome = 1000,
  TabBarItemTypeRecommendation = 1001,
  TabBarItemTypePost = 1002,
  TabBarItemTypeGroups = 1003,
  TabBarItemTypeEvents = 1004
};

@protocol LLTabBarDelegate <NSObject>

- (void)tabBarItemDidSelectAtIndex:(TabBarItemType)index;

@end

@interface LLTabBar : UIView <LLTabBarItemDelegate>
@property(nonatomic, readonly, getter=getItems) NSArray *items;
@property(nonatomic, weak) id<LLTabBarDelegate> delegate;
@property(nonatomic, readonly, getter=getSelectedItem)
    TabBarItemType selectedItemType;
- (void)selectItemAtIndex:(TabBarItemType)index;
@end
