//
//  LLTextView.m
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "LLTextView.h"

@implementation LLTextView

- (void)awakeFromNib {
  self.font = FONT_DEFAULT_REGULAR(self.font.pointSize);
}

@end
