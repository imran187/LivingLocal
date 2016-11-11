//
//  CommentTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 09/10/16.
//
//

#import "CommentTableViewCell.h"
#import <NSDate+TimeAgo.h>

@implementation CommentTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  [_btnLike.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setComment:(LLComment *)comment {
  _comment = comment;

  _btnLike.selected = [comment.commentRelaventData
      containsObject:ServiceManager.loggedUser.userID];
  _lblName.text = comment.fullName;
  _lblTimeAgo.text = [comment.createdOn timeAgo];
  [_imgUser sd_setImageWithURL:[NSURL URLWithString:comment.photo]
              placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
  _imgUser.hoodId = _comment.hood.ID;
  _imgUser.userID = [NSString stringWithFormat:@"%ld", (long)_comment.userId];
  _lblName.userID = [NSString stringWithFormat:@"%ld", (long)_comment.userId];
  NSMutableParagraphStyle *paragraphStyle =
      [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraphStyle setLineSpacing:1];

  NSAttributedString *postText = [[NSMutableAttributedString alloc]
      initWithString:comment.commentText
          attributes:@{
            NSFontAttributeName : _lblComment.font,
            NSParagraphStyleAttributeName : paragraphStyle,
            NSForegroundColorAttributeName : _lblComment.textColor
          }];

  _lblComment.attributedText = postText;

  _lblCommentLikeComment.text =
      [NSString stringWithFormat:@"%lu", comment.releventScore];
}

- (IBAction)commentLikePressed:(UIButton *)sender {
  [ServiceManager
      updateCommentRelevantForUserId:ServiceManager.loggedUser.userID
                        ForContentId:_comment.commentId
                          IsRelevant:!sender.selected
                        onCompletion:^(BOOL success, NSInteger count) {
                          if (success) {
                            sender.selected = !sender.selected;
                            _lblCommentLikeComment.text =
                                [NSString stringWithFormat:@"%lu", count];
                            if (sender.selected) {
                              _comment.commentRelaventData =
                                  [_comment.commentRelaventData
                                      arrayByAddingObjectsFromArray:@[
                                        ServiceManager.loggedUser.userID
                                      ]];
                              _comment.releventScore++;
                            } else {
                              NSMutableArray *arrData =
                                  [_comment.commentRelaventData mutableCopy];
                              [arrData removeObject:ServiceManager.loggedUser
                                                        .userID];
                              _comment.commentRelaventData = [arrData copy];
                              _comment.releventScore--;
                            }
                          }
                        }];
}

@end
