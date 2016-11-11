//
//  SearchTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet LLImageView *imgUser;
@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic) IBOutlet LLNameLabel *lblName;
@property(weak, nonatomic) IBOutlet LLLabel *lblSection;
@property(weak, nonatomic) IBOutlet LLLabel *lblDate;
@property(weak, nonatomic) IBOutlet LLLabel *lblPost;
@property(weak, nonatomic) IBOutlet LLLabel *lblRank;
@property(strong, nonatomic) LLPost *post;
@property(strong, nonatomic) LLUser *user;
@end
