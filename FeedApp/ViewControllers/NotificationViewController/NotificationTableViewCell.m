//
//  NotificationTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  _imgUser.layer.borderColor = [UIColor orangeColor].CGColor;
  self.accessoryView = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"notification_accessory"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
