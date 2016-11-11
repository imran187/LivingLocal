//
//  SearchTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 11/09/16.
//
//

#import "SearchTableViewCell.h"

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

@implementation SearchTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  _lblPost.numberOfLines = 0;
}

- (void)setPost:(LLPost *)post {
  _post = post;

  _lblName.userID = [[NSString alloc] initWithFormat:@"%ld", (long)post.userId];
  _imgUser.userID = [[NSString alloc] initWithFormat:@"%ld", (long)post.userId];
  _imgUser.hoodId = post.userHood;
  [_imgUser sd_setImageWithURL:[NSURL URLWithString:post.userImage]
              placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];

  _lblName.text = post.userName;
  _lblSection.text = post.section.name;

  NSDateFormatter *df = [NSDateFormatter new];
  [df setDateFormat:@"dd MMMM yyyy, hh:mm a"];

  _lblDate.text = [df stringFromDate:post.createdOn];

  NSMutableParagraphStyle *paragraphStyle =
      [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraphStyle setLineSpacing:1];

  NSInteger maxChar = 200;

  if (_post.contentDescription) {
    _lblPost.text = _post.contentDescription;
    maxChar = [_lblPost fitString:_post.contentDescription ForHeight:35];

    NSMutableAttributedString *postText = [[NSMutableAttributedString alloc]
        initWithString:_post.contentDescription.length > maxChar
                           ? [_post.contentDescription substringToIndex:maxChar]
                           : _post.contentDescription
            attributes:@{
              NSFontAttributeName : _lblPost.font,
              NSParagraphStyleAttributeName : paragraphStyle,
              NSForegroundColorAttributeName : _lblPost.textColor
            }];

    if (_post.contentDescription.length > maxChar) {
      [postText
          appendAttributedString:[[NSAttributedString alloc]
                                     initWithString:@"..."
                                         attributes:@{
                                           NSFontAttributeName : _lblPost.font,
                                           NSParagraphStyleAttributeName :
                                               paragraphStyle,
                                           NSForegroundColorAttributeName :
                                               _lblPost.textColor
                                         }]];

      [postText
          appendAttributedString:[[NSAttributedString alloc]
                                     initWithString:@" See more"
                                         attributes:@{
                                           NSFontAttributeName : _lblPost.font,
                                           NSParagraphStyleAttributeName :
                                               paragraphStyle,
                                           NSForegroundColorAttributeName :
                                               THEME_BLUE_COLOR
                                         }]];
    }

    _lblPost.attributedText = postText;
  } else {
    _lblPost.text = @"";
  }
}

- (void)setUser:(LLUser *)user {
  _user = user;
  _lblName.userID = user.userID;
  _imgUser.userID = user.userID;
  _imgUser.hoodId = ServiceManager.selctedHood.ID;
  [_imgUser sd_setImageWithURL:[NSURL URLWithString:user.photo]
              placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];

  _lblName.text = user.fullName;
  _lblRank.text = [[NSString alloc] initWithFormat:@"Rank %d", user.rank];
}

@end
