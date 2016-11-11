//
//  MenuOptionsTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "MenuOptionsTableViewCell.h"

@implementation MenuOptionsTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  _lblName.highlighted = selected;
  self.contentView.backgroundColor =
      selected ? [UIColor colorWithRed:0.984 green:0.565 blue:0.149 alpha:1.00]
               : [UIColor whiteColor];
  // Configure the view for the selected state
}

@end
