//
//  CommentTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 09/10/16.
//
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet LLImageView *imgUser;
@property(weak, nonatomic) IBOutlet LLNameLabel *lblName;
@property(weak, nonatomic) IBOutlet UILabel *lblTimeAgo;
@property(weak, nonatomic) IBOutlet UILabel *lblCommentLikeComment;
@property(weak, nonatomic) IBOutlet UIButton *btnLike;
@property(weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIView *dividerView;

@property(strong, nonatomic) LLComment *comment;

@end
