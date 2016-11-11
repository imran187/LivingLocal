//
//  EventHeaderTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 23/10/16.
//
//

#import "EventHeaderTableViewCell.h"

@implementation EventHeaderTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setEvent:(LLEvent *)event {
  _event = event;
  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"EEE, dd MMM, yy";
  _lblEventName.text = _event.eventName.uppercaseString;
  _lblSectionName.text =
      [NSString stringWithFormat:@"%@ %@ - %@", _event.section.name,
                                 [df stringFromDate:_event.startDate],
                                 [df stringFromDate:_event.endDate]];
  _lblEventUserName.text = _event.createdByName;
  _lblEventDescription.text = _event.eventDescription;
  [_imgUser sd_setImageWithURL:[NSURL URLWithString:_event.createdByImage]
              placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
  _lblInterestedCount.text =
      [NSString stringWithFormat:@"%2ld", (long)_event.noOfIntrested];
  _imgUser.hoodId = _event.hoodId;
  _imgUser.userID = _event.createdBy;
  _lblEventUserName.userID = _event.createdBy;
  _btnInterested.selected = event.isInterested;
  if (!_btnInterested.selected) {
    _btnInterested.backgroundColor = [UIColor clearColor];
    _btnInterested.layer.borderColor =
        [_btnInterested titleColorForState:UIControlStateNormal].CGColor;
    _btnInterested.layer.borderWidth = 1;
  } else {

    _btnInterested.backgroundColor =
        [UIColor colorWithRed:0.984 green:0.565 blue:0.149 alpha:1.00];
    _btnInterested.layer.borderColor = [UIColor clearColor].CGColor;
    _btnInterested.layer.borderWidth = 0;
  }
}

- (IBAction)interestedCellPressed:(UIButton *)sender {

  [ServiceManager
      updateEventInterestForUserId:ServiceManager.loggedUser.userID
                        ForEventId:_event.eventId
                      onCompletion:^(BOOL success, NSInteger count) {

                        if (!success) {
                          return;
                        }
                        _event.isInterested = !_event.isInterested;
                        _event.noOfIntrested = count;
                        _lblInterestedCount.text = [NSString
                            stringWithFormat:@"%2ld",
                                             (long)_event.noOfIntrested];
                        sender.selected = !sender.selected;
                        if (!sender.selected) {
                          sender.backgroundColor = [UIColor clearColor];
                          sender.layer.borderColor =
                              [sender titleColorForState:UIControlStateNormal]
                                  .CGColor;
                          sender.layer.borderWidth = 1;
                        } else {

                          sender.backgroundColor = [UIColor colorWithRed:0.984
                                                                   green:0.565
                                                                    blue:0.149
                                                                   alpha:1.00];
                          sender.layer.borderColor =
                              [UIColor clearColor].CGColor;
                          sender.layer.borderWidth = 0;
                        }
                      }];
}

@end
