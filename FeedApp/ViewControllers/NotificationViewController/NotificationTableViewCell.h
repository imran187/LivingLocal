//
//  NotificationTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet LLLabel *lblNotification;
@property (weak, nonatomic) IBOutlet LLLabel *lblTime;

@end
