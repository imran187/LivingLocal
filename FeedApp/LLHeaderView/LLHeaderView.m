//
//  LLHeaderView.m
//  FeedApp
//
//  Created by TechLoverr on 25/09/16.
//
//

#import "LLHeaderView.h"

@implementation LLHeaderView

- (void)awakeFromNib {
  [super awakeFromNib];

  self.layer.masksToBounds = NO;
  self.layer.shadowOffset = CGSizeMake(0, 1);
  self.layer.shadowRadius = 1;
  self.layer.shadowOpacity = 0.3;

  [self.superview bringSubviewToFront:self];
}

@end
