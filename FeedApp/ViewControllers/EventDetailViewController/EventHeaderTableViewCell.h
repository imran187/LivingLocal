//
//  EventHeaderTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 23/10/16.
//
//

#import <UIKit/UIKit.h>

@interface EventHeaderTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet LLLabel *lblEventName;
@property(weak, nonatomic) IBOutlet LLLabel *lblSectionName;
@property(weak, nonatomic) IBOutlet LLNameLabel *lblEventUserName;
@property(weak, nonatomic) IBOutlet LLLabel *lblEventDescription;
@property(weak, nonatomic) IBOutlet LLLabel *lblInterestedCount;
@property(weak, nonatomic) IBOutlet UIButton *btnInterested;
@property(weak, nonatomic) IBOutlet LLImageView *imgUser;
@property(strong, nonatomic) LLEvent *event;

@end
