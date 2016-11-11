//
//  LLMediumLabel.m
//  FeedApp
//
//  Created by TechLoverr on 20/09/16.
//
//

#import "LLMediumLabel.h"

@implementation LLMediumLabel

- (void)awakeFromNib {
  self.font = FONT_DEFAULT_BOLD(self.font.pointSize);

  if (self.attributedText) {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
        initWithAttributedString:self.attributedText];

    [attrString removeAttribute:NSFontAttributeName
                          range:NSMakeRange(0, attrString.length)];

    [attrString addAttributes:@{
      NSFontAttributeName : self.font
    }
                        range:NSMakeRange(0, attrString.length)];
    self.attributedText = attrString;
  }
}

@end
