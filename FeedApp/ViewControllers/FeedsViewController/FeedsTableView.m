//
//  FeedsTableView.m
//  FeedApp
//
//  Created by TechLoverr on 03/09/16.
//
//

#import "EventGroupFeedCell.h"
#import "FeedsTableView.h"
#import "FeedsTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface FeedsTableView () <DZNEmptyDataSetSource> {
  NSInteger selectedIndex;
}

@end

@implementation FeedsTableView

- (void)awakeFromNib {
  [super awakeFromNib];

  [self registerNib:[UINib nibWithNibName:NSStringFromClass(
                                              [FeedsTableViewCell class])
                                   bundle:nil]
      forCellReuseIdentifier:@"Cell"];

  self.delegate = self;
  self.dataSource = self;
  self.emptyDataSetSource = self;
  self.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.estimatedRowHeight = 200;
  self.rowHeight = UITableViewAutomaticDimension;
  self.separatorStyle = UITableViewCellSelectionStyleNone;
  selectedIndex = -1;
  self.allowsSelection = YES;
}

- (void)setArrFeeds:(NSArray *)arrFeeds {
  _arrFeeds = arrFeeds;
  [super reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _arrFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  //  if (indexPath.row == 1) {
  //    UITableViewCell *cell =
  //        [tableView dequeueReusableCellWithIdentifier:@"NewHooderCell"];
  //    if (cell != nil) {
  //      return cell;
  //    }
  //  }
  //
  //  if (indexPath.row == 3) {
  //    UITableViewCell *cell =
  //        [tableView dequeueReusableCellWithIdentifier:@"NewEventCell"];
  //
  //    if (cell != nil) {
  //      return cell;
  //    }
  //  }

  LLPost *post = _arrFeeds[indexPath.row];

  if ((post.contentType == 5) || (post.contentType == 9)) {
    EventGroupFeedCell *cell = (EventGroupFeedCell *)[tableView
        dequeueReusableCellWithIdentifier:(post.contentType == 5)
                                              ? @"NewEventCell"
                                              : @"NewHooderCell"];
    [cell.imgEvent
        sd_setImageWithURL:[NSURL URLWithString:post.userImage]
          placeholderImage:[UIImage imageNamed:(post.contentType == 5)
                                                   ? @"eventPlaceholder"
                                                   : @"default-group-image"]];
    cell.lblEvent.text = post.userName;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

  } else {

    FeedsTableViewCell *cell = (FeedsTableViewCell *)[tableView
        dequeueReusableCellWithIdentifier:@"Cell"];
    cell.containerView.layer.borderColor =
        [UIColor colorWithWhite:0.8 alpha:0.5].CGColor;
    cell.containerView.layer.masksToBounds = NO;
    cell.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    cell.containerView.layer.shadowRadius = 1;
    cell.containerView.layer.shadowOpacity = 0.1;

    cell.btnArrowForReport.tag = indexPath.row;

    if (selectedIndex == indexPath.row) {
      if (cell.btnReport.hidden) {
        cell.btnReport.hidden = NO;
      } else {
        cell.btnReport.hidden = YES;
      }
    } else {
      cell.btnReport.hidden = YES;
    }

    cell.post = _arrFeeds[indexPath.row];

    cell.replyHandler = ^{
      if (_replyHandler) {
        _replyHandler(_arrFeeds[indexPath.row]);
      }
    };

    cell.moreReplyHandler = ^{
      if (_moreReplyHandler) {
        _moreReplyHandler(_arrFeeds[indexPath.row]);
      }
    };

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
  CGPoint offset = aScrollView.contentOffset;
  CGRect bounds = aScrollView.bounds;
  CGSize size = aScrollView.contentSize;
  UIEdgeInsets inset = aScrollView.contentInset;
  float y = offset.y + bounds.size.height - inset.bottom;
  float h = size.height;
  // NSLog(@"offset: %f", offset.y);
  // NSLog(@"content.height: %f", size.height);
  // NSLog(@"bounds.height: %f", bounds.size.height);
  // NSLog(@"inset.top: %f", inset.top);
  // NSLog(@"inset.bottom: %f", inset.bottom);
  // NSLog(@"pos: %f of %f", y, h);

  float reload_distance = 10;
  if (y > h + reload_distance) {
    _moreRowsHandler();
  }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  return [UIImage imageNamed:@"no_content"];
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LLPost *post = _arrFeeds[indexPath.row];
  selectedIndex = -1;
  [self reloadData];
  if ((post.contentType == 5) || (post.contentType == 9)) {
    if (_selectionHandler) {
      _selectionHandler(_arrFeeds[indexPath.row]);
    }
  }
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;
{
  return [[NSAttributedString alloc]
      initWithString:@"\"Be the first one to start your "
                     @"neighbour\"Hood\"\nconnect. Create a Post to Connect / "
                     @"Share /\nSeek Help from Fellow Hooders\""
          attributes:@{
            NSFontAttributeName : FONT_DEFAULT_REGULAR(13),
            NSForegroundColorAttributeName : UIColorFromRGB(0x2276B8)
          }];
}

@end
