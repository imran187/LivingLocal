//
//  FeedsTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 03/09/16.
//
//

#import "FeedsTableViewCell.h"
#import "SlideView.h"
#import <NSDate+TimeAgo.h>

@interface UILabel (SizeLabel)
- (NSUInteger)fitString:(NSString *)string ForHeight:(CGFloat)height;

@end

@implementation UILabel (SizeLabel)

- (NSUInteger)fitString:(NSString *)string ForHeight:(CGFloat)height {
  UIFont *font = self.font;
  NSLineBreakMode mode = self.lineBreakMode;

  CGFloat labelWidth = self.frame.size.width;
  CGFloat labelHeight = height;
  CGSize sizeConstraint = CGSizeMake(labelWidth, CGFLOAT_MAX);

  if ([string sizeWithFont:font
          constrainedToSize:sizeConstraint
              lineBreakMode:mode]
          .height > labelHeight) {
    NSUInteger index = 0;
    NSUInteger prev;
    NSCharacterSet *characterSet =
        [NSCharacterSet whitespaceAndNewlineCharacterSet];

    do {
      prev = index;
      if (mode == UILineBreakModeCharacterWrap)
        index++;
      else
        index = [string rangeOfCharacterFromSet:characterSet
                                        options:0
                                          range:NSMakeRange(index + 1,
                                                            [string length] -
                                                                index - 1)]
                    .location;
    } while (index != NSNotFound && index < [string length] &&
             [[string substringToIndex:index] sizeWithFont:font
                                         constrainedToSize:sizeConstraint
                                             lineBreakMode:mode]
                     .height <= labelHeight);

    return prev;
  }

  return [string length];
}

@end

@implementation FeedsTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  _imgViewHeightConstraint.constant = 200;
  _lblPost.numberOfLines = 5;
  _lblComment.numberOfLines = 0;
  _btnReply.imageView.contentMode = UIViewContentModeScaleAspectFit;
  _btnMoreReplies.imageView.contentMode = UIViewContentModeScaleAspectFit;
  _imgUser2.layer.borderColor = [UIColor orangeColor].CGColor;
  _imgUser.layer.borderColor = [UIColor orangeColor].CGColor;
  _lblSeeMore.userInteractionEnabled = YES;

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(moreReplyPressed:)];
  [_lblSeeMore addGestureRecognizer:tap];
  self.viewCatName.layer.masksToBounds = NO;
  self.viewCatName.layer.shadowOffset = CGSizeMake(0, 1);
  self.viewCatName.layer.shadowRadius = 1;
  self.viewCatName.layer.shadowOpacity = 0.3;

  for (UIImageView *img in @[ _imgPost1, _imgPost2, _imgView ]) {
    img.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(moreImagePressed:)];
    [img addGestureRecognizer:tap];
  }

  _btnReport.hidden = YES;
}

- (void)setPost:(LLPost *)post {
  _btnReport.hidden = YES;
  _post = post;
  _lblTitle.text = post.section.name ?: @"Unknown";

  [_imgUser sd_setImageWithURL:[NSURL URLWithString:post.userImage]
              placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
  _lblUserName.text = post.userName;
  _lblTimeAgo.text = [post.createdOn timeAgo];

  _imgUser.hoodId = post.userHood;
  _imgUser.userID = [NSString stringWithFormat:@"%ld", (long)post.userId];
  _lblUserName.userID = [NSString stringWithFormat:@"%ld", (long)post.userId];
  NSMutableParagraphStyle *paragraphStyle =
      [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraphStyle setLineSpacing:1];

  if (_post.contentDescription) {
    _lblPost.text = _post.contentDescription;

    NSMutableAttributedString *postText = [[NSMutableAttributedString alloc]
        initWithString:_post.contentDescription
            attributes:@{
              NSFontAttributeName : _lblPost.font,
              NSParagraphStyleAttributeName : paragraphStyle,
              NSForegroundColorAttributeName : _lblPost.textColor
            }];
    _lblPost.attributedText = postText;
    _seeMoreHeightConstraint.constant = 0;
    if ([self.class getSizeFromAttributedString:postText
                                        forSize:_lblPost.frame.size]
            .height > 90) {
      _seeMoreHeightConstraint.constant = 15;
    }

    _lblPost.attributedText = postText;
  } else {
    _lblPost.text = @"";
  }

  _lblHeartCount.text = [NSString stringWithFormat:@"%lu", _post.releventScore];
  _btnPostLike.selected =
      [_post.postReleventData containsObject:ServiceManager.loggedUser.userID];
  if (_post.contentImageList.count > 0) {

    _imgView.hidden = YES;
    if (_post.contentImageList.count == 1) {
      _imgGroupView.hidden = YES;
      _imgView.hidden = NO;
      _imgViewHeightConstraint.constant = _post.mainImageHeight;
      [_imgView
          sd_setImageWithURL:[NSURL URLWithString:_post.contentImageList
                                                      .firstObject]
            placeholderImage:[UIImage imageNamed:@"noPictureAvailable"]
                     options:SDWebImageContinueInBackground
                   completed:^(UIImage *image, NSError *error,
                               SDImageCacheType cacheType, NSURL *imageURL) {
                     if (image == nil) {
                       return;
                     }
                     float aspectRatio = image.size.height / image.size.width *
                                         _imgView.frame.size.width;
                     _post.mainImageHeight = aspectRatio;
                     if (_imgViewHeightConstraint.constant != aspectRatio) {
                       _imgViewHeightConstraint.constant = aspectRatio;

                       dispatch_after(
                           dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(0.25 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                             UITableView *tbl =
                                 [self getSuperviewOfKind:[UITableView class]];
                             NSIndexPath *indexPath =
                                 [tbl indexPathForCell:self];
                             if (indexPath) {
                               [tbl reloadRowsAtIndexPaths:@[ indexPath ]
                                          withRowAnimation:
                                              UITableViewRowAnimationNone];
                             }

                           });
                     }
                   }];
    } else {
      _imgGroupView.hidden = NO;
      _imgViewHeightConstraint.constant = 135;
      [_imgPost1 sd_setImageWithURL:[NSURL URLWithString:_post.contentImageList
                                                             .firstObject]
                   placeholderImage:[UIImage imageNamed:@"noPictureAvailable"]];
      [_imgPost2
          sd_setImageWithURL:[NSURL URLWithString:_post.contentImageList[1]]
            placeholderImage:[UIImage imageNamed:@"noPictureAvailable"]];

      _btnMoreImages.hidden = _post.contentImageList.count <= 2;
      [_btnMoreImages
          setTitle:[NSString stringWithFormat:@"+%u",
                                              _post.contentImageList.count - 2]
          forState:UIControlStateNormal];
    }
  } else {
    _imgViewHeightConstraint.constant = 0;
  }

  if (_post.comments.count > 0) {

    if (_post.comments.count == 1) {
      [_btnMoreReplies setTitle:@"No more replies"
                       forState:UIControlStateNormal];
      [_btnMoreReplies setTitle:@"No more replies"
                       forState:UIControlStateSelected];
    } else {
      [_btnMoreReplies
          setTitle:[NSString stringWithFormat:@"%u more replies",
                                              _post.comments.count - 1]
          forState:UIControlStateNormal];
      [_btnMoreReplies
          setTitle:[NSString stringWithFormat:@"%u more replies",
                                              _post.comments.count - 1]
          forState:UIControlStateSelected];
    }

    if (_lblComment) {
      LLComment *comment = _post.comments.firstObject;
      _btnCommentLike.selected = [comment.commentRelaventData
          containsObject:ServiceManager.loggedUser.userID];
      _lblUserName2.text = comment.fullName;
      _lblTimeAgo2.text = [comment.createdOn timeAgo];
      [_imgUser2 sd_setImageWithURL:[NSURL URLWithString:comment.photo]
                   placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
      _imgUser2.hoodId = comment.hood.ID;
      _imgUser2.userID =
          [NSString stringWithFormat:@"%ld", (long)comment.userId];
      _lblUserName2.userID =
          [NSString stringWithFormat:@"%ld", (long)comment.userId];
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

      _commentViewHeightConstraint.constant =
          (60 +
           [FeedsTableViewCell
               getSizeFromAttributedString:postText
                                   forSize:_lblComment.frame.size]
               .height);
    }

  } else {
    _commentViewHeightConstraint.constant = 0;
    [_btnMoreReplies setTitle:@"0 replies" forState:UIControlStateNormal];
    [_btnMoreReplies setTitle:@"0 replies" forState:UIControlStateSelected];
  }
}

+ (CGSize)getSizeFromAttributedString:(NSAttributedString *)text
                              forSize:(CGSize)size {

  if ([text isKindOfClass:[NSNull class]]) {
    return CGSizeZero;
  }

  //  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
  //            initWithData:[text dataUsingEncoding:NSUTF8StringEncoding]
  //                 options:@{
  //                   NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
  //                   NSCharacterEncodingDocumentAttribute :
  //                       @(NSUTF8StringEncoding)
  //                 }
  //      documentAttributes:nil
  //                   error:nil];

  return [text boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                            options:NSStringDrawingUsesLineFragmentOrigin
                            context:nil]
      .size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (IBAction)moreReplyPressed:(id)sender {
  if (_moreReplyHandler) {
    _moreReplyHandler();
  }
}

- (IBAction)replyPressed:(id)sender {
  if (_replyHandler) {
    _replyHandler();
  }
}

- (IBAction)arrowPressed:(id)sender {
  _btnReport.hidden = !_btnReport.hidden;
}

- (IBAction)reportSpamPressed:(UIButton *)sender {
  [ServiceManager reportSpam:_post
                onCompletion:^(BOOL success) {
                  if (success) {
                    [APPDelegate showAlertWithMessage:@"Reported as a spam!"];
                  }
                  sender.hidden = YES;
                }];
}

- (IBAction)moreImagePressed:(UIButton *)sender {
  SlideView *slideView =
      [[[NSBundle mainBundle] loadNibNamed:@"SlideView" owner:nil options:nil]
          firstObject];
  UIView *view = sender;

  if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
    view = ((UITapGestureRecognizer *)sender).view;
  }
  slideView.clipsToBounds = YES;
  CGPoint origin = [view.superview convertPoint:view.frame.origin toView:nil];
  oldFrame = CGRectMake(origin.x, origin.y, view.frame.size.width,
                        view.frame.size.height);
  slideView.frame = CGRectMake(origin.x, origin.y, view.frame.size.width,
                               view.frame.size.height);
  slideView.oldFrame = oldFrame;
  slideView.arrImagesURL = _post.contentImageList;
  [APPDelegate.window addSubview:slideView];
  [APPDelegate.window bringSubviewToFront:slideView];
  [UIView animateWithDuration:0.0
                   animations:^{
                     slideView.frame =
                         CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                   }];
}

- (IBAction)postLikePressed:(UIButton *)sender {
  [ServiceManager
      updateRelevantForUserId:ServiceManager.loggedUser.userID
                 ForContentId:_post.ID
                 onCompletion:^(BOOL success, NSInteger count) {
                   if (success) {
                     sender.selected = !sender.selected;
                     _lblHeartCount.text =
                         [NSString stringWithFormat:@"%lu", count];

                     if (sender.selected) {
                       _post.postReleventData = [_post.postReleventData
                           arrayByAddingObjectsFromArray:@[
                             ServiceManager.loggedUser.userID
                           ]];
                       _post.releventScore++;
                     } else {
                       NSMutableArray *arrData =
                           [_post.postReleventData mutableCopy];
                       [arrData removeObject:ServiceManager.loggedUser.userID];
                       _post.postReleventData = [arrData copy];
                       _post.releventScore--;
                     }
                   }
                 }];
}

- (IBAction)commentLikePressed:(UIButton *)sender {
  [ServiceManager
      updateCommentRelevantForUserId:ServiceManager.loggedUser.userID
                        ForContentId:[_post.comments.firstObject commentId]
                          IsRelevant:!sender.selected
                        onCompletion:^(BOOL success, NSInteger count) {
                          if (success) {
                            sender.selected = !sender.selected;
                            _lblCommentLikeComment.text =
                                [NSString stringWithFormat:@"%lu", count];
                            LLComment *comment = _post.comments.firstObject;
                            if (sender.selected) {
                              comment.commentRelaventData =
                                  [comment.commentRelaventData
                                      arrayByAddingObjectsFromArray:@[
                                        ServiceManager.loggedUser.userID
                                      ]];
                              comment.releventScore++;
                            } else {
                              NSMutableArray *arrData =
                                  [comment.commentRelaventData mutableCopy];
                              [arrData removeObject:ServiceManager.loggedUser
                                                        .userID];
                              comment.commentRelaventData = [arrData copy];
                              comment.releventScore--;
                            }
                          }
                        }];
}
@end
