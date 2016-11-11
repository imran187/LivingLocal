//
//  LLLabel.m
//  FeedApp
//
//  Created by TechLoverr on 15/09/16.
//
//

#import "LLLabel.h"

@implementation LLLabel
- (void)awakeFromNib {
  self.font = FONT_DEFAULT_REGULAR(self.font.pointSize);

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
