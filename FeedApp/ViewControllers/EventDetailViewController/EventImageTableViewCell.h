//
//  EventImageTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import <UIKit/UIKit.h>

@interface EventImageTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIImageView *imgOne;
@property(weak, nonatomic) IBOutlet UIImageView *imgTwo;
@property(weak, nonatomic) IBOutlet UIButton *btnCount;
@property(strong, nonatomic) LLEvent *event;
@property(weak, nonatomic) IBOutlet UIImageView *imgMain;
@end
