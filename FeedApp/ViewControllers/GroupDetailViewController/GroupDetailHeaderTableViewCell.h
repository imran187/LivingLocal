//
//  GroupDetailHeaderTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "LLButton.h"
#import <UIKit/UIKit.h>

@interface GroupDetailHeaderTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet LLButton *btnGroup;
@property(strong, nonatomic) LLGroup *group;
@property(weak, nonatomic) IBOutlet LLLabel *lblHoodersCount;
@property(weak, nonatomic) IBOutlet LLLabel *lblGroupTitle;
@property(weak, nonatomic) IBOutlet LLLabel *lblSection;
@property(weak, nonatomic) IBOutlet LLImageView *imgUser;
@property(weak, nonatomic) IBOutlet LLNameLabel *lblGroupOwner;
@property(weak, nonatomic) IBOutlet UILabel *lblCreatedDate;
@property(weak, nonatomic) IBOutlet LLLabel *lblGroupDescription;
@property(nonatomic, copy) void (^reloadHandler)(void);
@end
