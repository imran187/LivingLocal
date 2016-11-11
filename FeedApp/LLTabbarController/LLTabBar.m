//
//  LLTabBar.m
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "LLTabBar.h"

@implementation LLTabBar

- (void)awakeFromNib {
  [super awakeFromNib];
  for (LLTabBarItem *item in self.items) {
    item.itemDelegate = self;
  }
  self.layer.masksToBounds = NO;
  self.layer.shadowOffset = CGSizeMake(0, -1);
  self.layer.shadowRadius = 1;
  self.layer.shadowOpacity = 0.3;
}

- (NSArray *)getItems {
  return [self.subviews
      filteredArrayUsingPredicate:
          [NSPredicate
              predicateWithFormat:@"class = %@", [LLTabBarItem class]]];
}

- (void)selectItemAtIndex:(TabBarItemType)index {

  if (self.selectedItemType == index) {
    return;
  }

  if ([self viewWithTag:index]) {
    LLTabBarItem *item = [self viewWithTag:index];
    item.selected = YES;
  } else {
    for (LLTabBarItem *item in self.items) {
      item.selected = NO;
    }
  }
}

- (TabBarItemType)getSelectedItem {
  LLTabBarItem *item = [[self.items
      filteredArrayUsingPredicate:[NSPredicate
                                      predicateWithFormat:@"selected = 1"]]
      firstObject];
  if (item) {
    return item.tag;
  }

  return TabBarItemTypeNone;
}

#pragma mark - LLTabBarItemDelegate implementations
- (void)tabBarItemDidSelect:(LLTabBarItem *)selectedItem {

  for (LLTabBarItem *item in self.items) {
    if (![item isEqual:selectedItem]) {
      item.selected = false;
    }
  }

  if ([self.delegate
          respondsToSelector:@selector(tabBarItemDidSelectAtIndex:)]) {
    [self.delegate tabBarItemDidSelectAtIndex:selectedItem.tag];
  }
}

@end
