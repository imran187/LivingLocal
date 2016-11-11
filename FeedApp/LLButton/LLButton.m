//
//  LLButton.m
//  FeedApp
//
//  Created by TechLoverr on 15/09/16.
//
//

#import "LLButton.h"

@implementation LLButton

- (void)awakeFromNib {
  [super awakeFromNib];

  self.titleLabel.font = FONT_DEFAULT_REGULAR(self.titleLabel.font.pointSize);

  if (self.titleLabel.attributedText) {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
        initWithAttributedString:self.titleLabel.attributedText];

    [attrString addAttributes:@{
      NSFontAttributeName : self.titleLabel.font
    }
                        range:NSMakeRange(0, attrString.length)];
    [self setAttributedTitle:attrString forState:UIControlStateNormal];
  }
}

@end
