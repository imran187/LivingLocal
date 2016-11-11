//
//  GroupDetailHeaderTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "GroupDetailHeaderTableViewCell.h"

@implementation GroupDetailHeaderTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  _btnGroup.layer.borderColor =
      [_btnGroup titleColorForState:UIControlStateNormal].CGColor;
  _btnGroup.layer.borderWidth = 1;
}

- (void)setGroup:(LLGroup *)group {
  _group = group;

  _lblGroupOwner.text = group.userName;
  _lblSection.text = group.section.name;
  _lblGroupTitle.text = group.groupName.uppercaseString;
  _lblHoodersCount.text =
      [NSString stringWithFormat:@"Hooders: %.2lu", _group.hoodersCount];
  _lblGroupDescription.text = group.groupDescription;

  [_imgUser sd_setImageWithURL:[NSURL URLWithString:group.userPhoto]
              placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
  _imgUser.hoodId = _group.hood.ID;
  _imgUser.userID = [NSString stringWithFormat:@"%ld", (long)_group.userId];
  _lblGroupOwner.userID =
      [NSString stringWithFormat:@"%ld", (long)_group.userId];
  NSDateFormatter *df = [NSDateFormatter new];
  [df setDateFormat:@"EEE, dd MMMM"];

  _lblCreatedDate.text = [df stringFromDate:group.createdOn];

  _btnGroup.selected = group.userJoined;
  _btnGroup.hidden = [group.groupStatus isEqual:@"myCreated"];
  if (!_btnGroup.selected) {
    _btnGroup.backgroundColor = [UIColor clearColor];
    _btnGroup.layer.borderColor =
        [_btnGroup titleColorForState:UIControlStateNormal].CGColor;
    _btnGroup.layer.borderWidth = 1;
  } else {

    _btnGroup.backgroundColor =
        [UIColor colorWithRed:0.984 green:0.565 blue:0.149 alpha:1.00];
    _btnGroup.layer.borderColor = [UIColor clearColor].CGColor;
    _btnGroup.layer.borderWidth = 0;
  }
}

- (IBAction)joinGroupPressed:(UIButton *)sender {
  if (sender.selected) {
    [ServiceManager
          leaveGroup:_group
        onCompletion:^(BOOL success) {
          if (success) {
            sender.selected = !sender.selected;
            if (!sender.selected) {
              sender.backgroundColor = [UIColor clearColor];
              sender.layer.borderColor =
                  [sender titleColorForState:UIControlStateNormal].CGColor;
              sender.layer.borderWidth = 1;
              _group.hoodersCount -= 1;
              _group.userJoined = NO;
            } else {

              sender.backgroundColor = [UIColor colorWithRed:0.984
                                                       green:0.565
                                                        blue:0.149
                                                       alpha:1.00];
              sender.layer.borderColor = [UIColor clearColor].CGColor;
              sender.layer.borderWidth = 0;
              _group.hoodersCount += 1;
              _group.userJoined = YES;
            }

            _reloadHandler();
            _lblHoodersCount.text = [NSString
                stringWithFormat:@"Hooders: %.2lu", _group.hoodersCount];
          }
        }];
  } else
    [ServiceManager
           joinGroup:_group
        onCompletion:^(BOOL success) {
          if (success) {
            sender.selected = !sender.selected;
            if (!sender.selected) {
              sender.backgroundColor = [UIColor clearColor];
              sender.layer.borderColor =
                  [sender titleColorForState:UIControlStateNormal].CGColor;
              sender.layer.borderWidth = 1;
              _group.hoodersCount -= 1;
              _group.userJoined = NO;
            } else {

              sender.backgroundColor = [UIColor colorWithRed:0.984
                                                       green:0.565
                                                        blue:0.149
                                                       alpha:1.00];
              sender.layer.borderColor = [UIColor clearColor].CGColor;
              sender.layer.borderWidth = 0;
              _group.hoodersCount += 1;
              _group.userJoined = YES;
            }
            _reloadHandler();
            _lblHoodersCount.text = [NSString
                stringWithFormat:@"Hooders: %.2lu", _group.hoodersCount];
          }
        }];
}

@end
