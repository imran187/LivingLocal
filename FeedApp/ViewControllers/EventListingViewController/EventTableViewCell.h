//
//  EventTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 05/10/16.
//
//

#import <Foundation/Foundation.h>

@interface EventTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *imgView;
@property(weak, nonatomic) IBOutlet LLLabel *lblEventName;
@property(weak, nonatomic) IBOutlet LLLabel *lblSectionName;
@property(weak, nonatomic) IBOutlet LLLabel *lblDate;

@end
