//
//  LLTextField.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "LLTextField.h"

@implementation LLTextField

- (void)awakeFromNib {
  [super awakeFromNib];
  self.leftViewMode = UITextFieldViewModeAlways;
  self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
  self.font = FONT_DEFAULT_REGULAR(self.font.pointSize - 1);

  self.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:self.placeholder
          attributes:@{
            NSForegroundColorAttributeName :
                [[UIColor whiteColor] colorWithAlphaComponent:0.8],
            NSFontAttributeName : self.font
          }];
  self.textColor = [UIColor whiteColor];
  self.tintColor = [UIColor whiteColor];

  self.layer.borderWidth = 1;
  self.layer.borderColor =
      [UIColor colorWithRed:0.318 green:0.314 blue:0.310 alpha:1.00].CGColor;
}

@end
