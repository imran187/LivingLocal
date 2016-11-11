//
//  FeedDetailTableView.m
//  FeedApp
//
//  Created by TechLoverr on 07/09/16.
//
//

#import "CommentTableViewCell.h"
#import "FeedDetailTableView.h"
#import "FeedsTableViewCell.h"

@interface FeedDetailTableView () {
  NSInteger selectedIndex;
}

@end

@implementation FeedDetailTableView

- (void)awakeFromNib {
  [super awakeFromNib];
  self.estimatedRowHeight = 100;
  self.delegate = self;
  self.dataSource = self;
  selectedIndex = -1;
}

- (void)setPost:(LLPost *)post {
  _post = post;
  [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 1 + _post.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  NSString *cellIdentifier = indexPath.row == 0 ? @"Cell" : @"Cell2";

  if (indexPath.row == 0) {
    FeedsTableViewCell *cell = (FeedsTableViewCell *)[tableView
        dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.post = _post;
    if (_post.contentDescription) {
      NSMutableParagraphStyle *paragraphStyle =
          [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
      [paragraphStyle setLineSpacing:1];
      NSMutableAttributedString *postText = [[NSMutableAttributedString alloc]
          initWithString:_post.contentDescription
              attributes:@{
                NSFontAttributeName : cell.lblPost.font,
                NSParagraphStyleAttributeName : paragraphStyle,
                NSForegroundColorAttributeName : cell.lblPost.textColor
              }];
      cell.lblPost.attributedText = postText;
      cell.lblPost.numberOfLines = 0;
    }
    return cell;
  } else {
    CommentTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.comment = _post.comments[indexPath.row - 1];
    cell.dividerView.hidden = NO;
    if (indexPath.row == [tableView numberOfRowsInSection:0] - 1) {
      cell.dividerView.hidden = YES;
    }

    return cell;
  }
}

- (IBAction)actionArrowToReport:(UIButton *)sender {

  selectedIndex = sender.tag;
  [self reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  selectedIndex = -1;
  [self reloadData];
}

@end
