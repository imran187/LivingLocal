//
//  LLFormTextField.m
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "LLFormTextField.h"

@implementation LLFormTextField

- (void)awakeFromNib {
  [super awakeFromNib];

  self.font = FONT_DEFAULT_REGULAR(self.font.pointSize - 1);

  if (self.placeholder) {
    self.attributedPlaceholder = [[NSAttributedString alloc]
        initWithString:self.placeholder
            attributes:@{
              NSForegroundColorAttributeName : [UIColor colorWithRed:0.710
                                                               green:0.714
                                                                blue:0.718
                                                               alpha:1.00],
              NSFontAttributeName : FONT_DEFAULT_REGULAR(self.font.pointSize)
            }];
  }

  self.tintColor = self.textColor;
}

@end
