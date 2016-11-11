//
//  FeedsTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 03/09/16.
//
//

#import "LLLabel.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface FeedsTableViewCell : UITableViewCell{
    CGRect oldFrame;
}
@property(weak, nonatomic)
    IBOutlet NSLayoutConstraint *commentViewHeightConstraint;
@property(weak, nonatomic) IBOutlet UILabel *lblTimeAgo;
@property(weak, nonatomic) IBOutlet LLNameLabel *lblUserName;
@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(weak, nonatomic) IBOutlet UIButton *btnMoreReplies;
@property(weak, nonatomic) IBOutlet UIButton *btnReply;
@property(weak, nonatomic) IBOutlet LLImageView *imgUser;
@property(weak, nonatomic) IBOutlet LLImageView *imgUser2;
@property(weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(weak, nonatomic) IBOutlet UIView *viewCatName;
@property(weak, nonatomic) IBOutlet UIButton *btnReport;
@property(weak, nonatomic) IBOutlet UIButton *btnArrowForReport;
@property(weak, nonatomic) IBOutlet LLLabel *lblPost;
@property(weak, nonatomic) IBOutlet UIImageView *imgHeart;
@property(weak, nonatomic) IBOutlet LLLabel *lblHeartCount;
@property(weak, nonatomic) IBOutlet UIView *dividerView;

@property(weak, nonatomic) IBOutlet LLNameLabel *lblUserName2;
@property(weak, nonatomic) IBOutlet UILabel *lblTimeAgo2;
@property(weak, nonatomic) IBOutlet UIButton *btnMoreImages;
@property(weak, nonatomic) IBOutlet LLLabel *lblComment;
@property(weak, nonatomic) IBOutlet UIImageView *imgView;
@property(weak, nonatomic) IBOutlet UIImageView *imgPost1;
@property(weak, nonatomic) IBOutlet UIImageView *imgPost2;
@property(weak, nonatomic) IBOutlet UIButton *btnPostLike;
@property(weak, nonatomic) IBOutlet UIButton *btnCommentLike;
@property(weak, nonatomic) IBOutlet LLLabel *lblCommentLikeComment;
@property(weak, nonatomic) IBOutlet UIView *imgGroupView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConstraint;
@property(nonatomic, copy) void (^moreReplyHandler)(void);
@property(nonatomic, copy) void (^replyHandler)(void);
- (IBAction)moreReplyPressed:(id)sender;
- (IBAction)replyPressed:(id)sender;
- (IBAction)arrowPressed:(id)sender;
- (IBAction)reportSpamPressed:(id)sender;
- (IBAction)moreImagePressed:(id)sender;
- (IBAction)postLikePressed:(id)sender;
- (IBAction)commentLikePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblSeeMore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seeMoreHeightConstraint;

@property(nonatomic, strong) LLPost *post;

@end
