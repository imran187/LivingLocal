//
//  CBView + UIView.m
//  Chirping Block
//
//  Created by TechLoverr on 1/5/15.
//  Copyright (c) 2015 techloverr All rights reserved.
//

#import "LLView + UIView.h"

#define MARGIN_VIEW 5.0

NSString *const kNewPropertyKey = @"kNewPropertyKey";

@implementation UIView (LLView)

@dynamic shakeCount;

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (id)getSuperviewOfKind:(Class)className {

  if ([self isKindOfClass:className]) {
    return self;
  } else {
    if (self.superview) {
      return [self.superview getSuperviewOfKind:className];
    } else {
      return nil;
    }
  }
}

- (id)getViewWithTag:(int)tag {

  if ([self viewWithTag:tag]) {
    return [self viewWithTag:tag];
  } else {

    if ([self.superview viewWithTag:tag]) {
      return [self.superview viewWithTag:tag];
    }

    if (self.superview.superview) {
      for (UIView *view in self.superview.superview.subviews) {
        if (!view.subviews.count) {
          continue;
        }

        return [view getViewWithTag:tag];
      }
    }
  }
  return nil;
}

- (NSLayoutConstraint *)getConstraintOfType:(NSLayoutAttribute)attribute {
  NSLayoutConstraint *constraint = [[self.constraints
      filteredArrayUsingPredicate:
          [NSPredicate predicateWithFormat:@"firstAttribute = %d", attribute]]
      firstObject];

  return constraint;
}

- (NSLayoutConstraint *)heightConstraint {
  return [self getConstraintOfType:NSLayoutAttributeHeight];
}
- (NSLayoutConstraint *)widthConstraint {
  return [self getConstraintOfType:NSLayoutAttributeWidth];
}
- (NSLayoutConstraint *)topConstraint {

  if (![self getConstraintOfType:NSLayoutAttributeTop]) {
    NSLayoutConstraint *constraint = [[self.superview.constraints
        filteredArrayUsingPredicate:
            [NSPredicate
                predicateWithFormat:@"firstAttribute = %d && (firstItem = %@) ",
                                    NSLayoutAttributeTop, self]] firstObject];

    return constraint;
  }

  return [self getConstraintOfType:NSLayoutAttributeTop];
}

- (NSLayoutConstraint *)bottomConstraint {

  if (![self getConstraintOfType:NSLayoutAttributeBottom]) {
    NSLayoutConstraint *constraint = [[self.superview.constraints
        filteredArrayUsingPredicate:
            [NSPredicate
                predicateWithFormat:@"(secondAttribute = %d && firstItem = %@)",
                                    NSLayoutAttributeBottom, self]]
        firstObject];

    return constraint;
  }

  return [self getConstraintOfType:NSLayoutAttributeBottom];
}

- (NSLayoutConstraint *)leadingConstraint {

  if (![self getConstraintOfType:NSLayoutAttributeLeading]) {
    NSLayoutConstraint *constraint = [[self.superview.constraints
        filteredArrayUsingPredicate:
            [NSPredicate
                predicateWithFormat:@"firstAttribute = %d && (firstItem = %@ "
                                    @"|| secondItem = %@)",
                                    NSLayoutAttributeLeading, self, self]]
        firstObject];

    return constraint;
  }

  return [self getConstraintOfType:NSLayoutAttributeLeading];
}

- (NSLayoutConstraint *)trailingConstraint {

  if (![self getConstraintOfType:NSLayoutAttributeTrailing]) {
    NSLayoutConstraint *constraint = [[self.superview.constraints
        filteredArrayUsingPredicate:
            [NSPredicate
                predicateWithFormat:@"firstAttribute = %d && (firstItem = %@ "
                                    @"|| secondItem = %@)",
                                    NSLayoutAttributeTrailing, self, self]]
        firstObject];

    return constraint;
  }

  return [self getConstraintOfType:NSLayoutAttributeTrailing];
}

- (void)setConstraintsWithHeight:(CGFloat)height {

  self.hidden = height <= 0;
  self.topConstraint.constant = height > 0 ? MARGIN_VIEW : 0;
  self.bottomConstraint.constant = height > 0 ? MARGIN_VIEW : 0;
  self.heightConstraint.constant = height > 0 ? height : 0;
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {

  CGRect frame = self.frame;

  frame.size.width = width;

  self.frame = frame;
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {

  CGRect frame = self.frame;

  frame.size.height = height;

  self.frame = frame;
}

- (CGFloat)xValue {
  return self.frame.origin.x;
}

- (void)setXValue:(CGFloat)xValue {

  CGRect frame = self.frame;

  frame.origin.x = xValue;

  self.frame = frame;
}

- (CGFloat)yValue {
  return self.frame.origin.y;
}

- (void)setYValue:(CGFloat)yValue {

  CGRect frame = self.frame;

  frame.origin.y = yValue;

  self.frame = frame;
}

- (void)collapseView {

  self.heightConstraint.constant = 0;
  self.topConstraint.constant = 0;
  self.bottomConstraint.constant = 0;
  self.hidden = YES;
  [self layoutIfNeeded];
}

@end
