//
//  EventInfoTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import "EventInfoTableViewCell.h"

@implementation EventInfoTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setEvent:(LLEvent *)event {
  _event = event;
  _lblLocation.text = _event.eventVenue;

  NSDateFormatter *df = [NSDateFormatter new];
  df.dateFormat = @"hh:mm a";
  _lblDate.text = @"";
  if (_event.startTime) {
    _lblDate.text = [NSString
        stringWithFormat:@"%@ - %@", [df stringFromDate:_event.startTime],
                         [df stringFromDate:_event.endTime]].lowercaseString;
  }

  _lblEmail.text = _event.emailId;
  _lblContactNo.text = _event.contactNo;
  _lblLink.text = _event.eventLink;
  _lblFees.text = _event.fees;

  _locationHeightConstraint.constant = _lblLocation.text.length ? 20 : 0;
  _dateHeightConstraint.constant = _lblDate.text.length ? 20 : 0;
  _emailHeightConstraint.constant = _lblEmail.text.length ? 20 : 0;
  _contactNoHeightConstraint.constant = _lblContactNo.text.length ? 20 : 0;
  _linkHeightConstraint.constant = _lblLink.text.length ? 20 : 0;
  _feesHeightConstraint.constant = _lblFees.text.length ? 20 : 0;

  _locationTopConstraint.constant = _lblLocation.text.length ? 10 : 0;
  _dateTopConstraint.constant = _lblDate.text.length ? 10 : 0;
  _emailTopConstraint.constant = _lblEmail.text.length ? 10 : 0;
  _contactNoTopConstraint.constant = _lblContactNo.text.length ? 10 : 0;
  _linkTopConstraint.constant = _lblLink.text.length ? 10 : 0;
  _feesTopConstraint.constant = _lblFees.text.length ? 10 : 0;

  _lblPlaceholderFees.hidden = _feesHeightConstraint.constant == 0;

  [self layoutIfNeeded];
}

@end
