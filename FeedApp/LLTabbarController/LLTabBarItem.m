//
//  LLTabBarItem.m
//  FeedApp
//
//  Created by TechLoverr on 10/09/16.
//
//

#import "LLTabBarItem.h"

@implementation LLTabBarItem

- (void)awakeFromNib {
  [super awakeFromNib];
  UIButton *btnItem = [[UIButton alloc] initWithFrame:self.bounds];
  btnItem.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  [btnItem addTarget:self
                action:@selector(itemSelected)
      forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:btnItem];
}

- (void)setSelected:(BOOL)selected {

  if (selected &&
      [self.itemDelegate respondsToSelector:@selector(tabBarItemDidSelect:)]) {
    [self.itemDelegate tabBarItemDidSelect:self];
  }

  _imgView.highlighted = selected;
  _lblName.highlighted = selected;
  _selected = selected;
}

- (void)itemSelected {
  self.selected = YES;
}

@end
