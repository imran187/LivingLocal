//
//  CBView + UIView.h
//  Chirping Block
//
//  Created by TechLoverr on 1/5/15.
//  Copyright (c) 2015 techloverr All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (LLView)

@property(nonatomic, assign) id shakeCount;

- (id)getSuperviewOfKind:(Class)className;

- (id)getViewWithTag:(int)tag;

- (NSLayoutConstraint *)getConstraintOfType:(NSLayoutAttribute)attribute;

- (NSLayoutConstraint *)heightConstraint;
- (NSLayoutConstraint *)widthConstraint;
- (NSLayoutConstraint *)topConstraint;
- (NSLayoutConstraint *)bottomConstraint;
- (NSLayoutConstraint *)leadingConstraint;
- (NSLayoutConstraint *)trailingConstraint;

- (void)setConstraintsWithHeight:(CGFloat)height;

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)xValue;
- (CGFloat)yValue;

- (void)setYValue:(CGFloat)yValue;
- (void)setXValue:(CGFloat)xValue;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;

- (void)collapseView;

@end
